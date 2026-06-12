import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/shloka.dart';
import '../models/language_option.dart';

class ShlokaCard extends StatelessWidget {
  final Shloka shloka;
  final int chapterNum;
  final String bookmarkKey;
  final String translationLang; // language code from AppProvider
  final double fontSize;
  final bool isBookmarked;
  final VoidCallback onBookmark;

  const ShlokaCard({
    super.key,
    required this.shloka,
    required this.chapterNum,
    required this.bookmarkKey,
    required this.translationLang,
    required this.fontSize,
    required this.isBookmarked,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = langByCode(translationLang);
    final hasNative = shloka.hasNativeTranslation(translationLang);
    final translation = shloka.getTranslation(translationLang);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── 1. Sanskrit verse ──────────────────────────────────────────
          _VerseContainer(
            isDark: isDark,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _Badge('श्लोक ${shloka.verseNumber}'),
                    IconButton(
                      icon: Icon(
                        isBookmarked
                            ? Icons.bookmark
                            : Icons.bookmark_outline,
                        color: const Color(0xFFC8922A),
                      ),
                      onPressed: onBookmark,
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  shloka.shlok,
                  style: GoogleFonts.tiroDevanagariMarathi(
                    fontSize: fontSize + 2,
                    height: 1.9,
                    color: isDark
                        ? const Color(0xFFF5DEB3)
                        : const Color(0xFF3E1E00),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // ── 2. Regional translation ────────────────────────────────────
          const SizedBox(height: 16),
          _SectionDivider(
            label: lang.name,
            isDark: isDark,
            trailing: !hasNative && translationLang != 'hi'
                ? _FallbackChip(lang.nameEn)
                : null,
          ),
          const SizedBox(height: 12),
          _ExplanationContainer(
            isDark: isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!hasNative && translationLang != 'hi') ...[
                  Row(
                    children: [
                      const Icon(Icons.info_outline,
                          size: 13, color: Colors.orange),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${lang.nameEn} translation coming soon. Showing Hindi.',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.orange,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
                Text(
                  translation,
                  style: GoogleFonts.tiroDevanagariMarathi(
                    fontSize: fontSize,
                    height: 1.75,
                    color: isDark
                        ? const Color(0xFFE8C99A)
                        : const Color(0xFF3E1E00),
                  ),
                ),
              ],
            ),
          ),

          // ── 3. English (always) ────────────────────────────────────────
          const SizedBox(height: 16),
          _SectionDivider(label: 'In English', isDark: isDark),
          const SizedBox(height: 12),
          _ExplanationContainer(
            isDark: isDark,
            borderColor: const Color(0xFF1A6B3C),
            child: Text(
              shloka.expEn,
              style: TextStyle(
                fontSize: fontSize - 1,
                height: 1.7,
                color: isDark
                    ? const Color(0xFFB8D4C0)
                    : const Color(0xFF1A4A2E),
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared sub-widgets ─────────────────────────────────────────────────────

class _VerseContainer extends StatelessWidget {
  final bool isDark;
  final Widget child;
  const _VerseContainer({required this.isDark, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF2C1A0A), const Color(0xFF3D2410)]
              : [const Color(0xFFFDF6E3), const Color(0xFFF5E0B0)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFC8922A).withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: child,
    );
  }
}

class _ExplanationContainer extends StatelessWidget {
  final bool isDark;
  final Widget child;
  final Color? borderColor;
  const _ExplanationContainer(
      {required this.isDark, required this.child, this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF2C1A0A)
            : Colors.white.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (borderColor ?? const Color(0xFFA0522D))
              .withValues(alpha: 0.25),
        ),
      ),
      child: child,
    );
  }
}

class _SectionDivider extends StatelessWidget {
  final String label;
  final bool isDark;
  final Widget? trailing;
  const _SectionDivider(
      {required this.label, required this.isDark, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
              color: const Color(0xFFC8922A).withValues(alpha: 0.35)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: GoogleFonts.tiroDevanagariMarathi(
                  color: const Color(0xFFC8922A),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 6),
                trailing!,
              ],
            ],
          ),
        ),
        Expanded(
          child: Divider(
              color: const Color(0xFFC8922A).withValues(alpha: 0.35)),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  const _Badge(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFC8922A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _FallbackChip extends StatelessWidget {
  final String langName;
  const _FallbackChip(this.langName);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border:
            Border.all(color: Colors.orange.withValues(alpha: 0.4)),
      ),
      child: Text(
        'Soon',
        style: const TextStyle(
          fontSize: 9,
          color: Colors.orange,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
