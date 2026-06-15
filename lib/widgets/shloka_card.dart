import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/shloka.dart';
import '../providers/app_provider.dart';

class ShlokaCard extends StatefulWidget {
  final Shloka shloka;
  final int chapterNum;
  final String bookmarkKey;
  final String translationLang;
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
  State<ShlokaCard> createState() => _ShlokaCardState();
}

class _ShlokaCardState extends State<ShlokaCard> {
  String? _marathiText;
  bool _translating = false;

  @override
  void initState() {
    super.initState();
    if (widget.translationLang == 'mr') _loadMarathi();
  }

  @override
  void didUpdateWidget(ShlokaCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.translationLang == 'mr' && _marathiText == null && !_translating) {
      _loadMarathi();
    }
  }

  Future<void> _loadMarathi() async {
    // Use pre-filled JSON data if available
    if (widget.shloka.expMr.isNotEmpty) {
      setState(() => _marathiText = widget.shloka.expMr);
      return;
    }
    setState(() => _translating = true);
    final provider = context.read<AppProvider>();
    final translated = await provider.getMarathiTranslation(
      widget.shloka.id,
      widget.shloka.shlok,
    );
    if (mounted) {
      setState(() {
        _marathiText = translated;
        _translating = false;
      });
    }
  }

  void _share() {
    final buffer = StringBuffer();
    buffer.writeln('॥ श्री सत्यनारायण कथा ॥');
    buffer.writeln('अध्याय ${widget.chapterNum}  •  भाग ${widget.shloka.verseNumber}');
    buffer.writeln();
    buffer.writeln(widget.shloka.shlok);
    if (_marathiText != null && _marathiText!.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('── मराठी ──');
      buffer.writeln(_marathiText);
    }
    buffer.writeln();
    buffer.write('📱 Shri Satyanarayankatha App');
    Share.share(buffer.toString());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final showMarathi = widget.translationLang == 'mr';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Hindi katha ────────────────────────────────────────────────
          _StoryContainer(
            isDark: isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _Badge('भाग ${widget.shloka.verseNumber}'),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.share_outlined,
                          color: Color(0xFFC8922A)),
                      onPressed: _share,
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Share',
                    ),
                    IconButton(
                      icon: Icon(
                        widget.isBookmarked
                            ? Icons.bookmark
                            : Icons.bookmark_outline,
                        color: const Color(0xFFC8922A),
                      ),
                      onPressed: widget.onBookmark,
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Bookmark',
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  widget.shloka.shlok,
                  style: GoogleFonts.tiroDevanagariMarathi(
                    fontSize: widget.fontSize + 1,
                    height: 1.85,
                    color: isDark
                        ? const Color(0xFFF5DEB3)
                        : const Color(0xFF3E1E00),
                  ),
                ),
              ],
            ),
          ),

          // ── Marathi translation (only when Marathi is selected) ────────
          if (showMarathi) ...[
            const SizedBox(height: 20),
            _SectionDivider(label: 'मराठी', isDark: isDark),
            const SizedBox(height: 12),
            _TranslationContainer(
              isDark: isDark,
              child: _translating
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFFC8922A),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text('भाषांतर होत आहे…',
                                style: TextStyle(
                                    color: Color(0xFFC8922A), fontSize: 13)),
                          ],
                        ),
                      ),
                    )
                  : _marathiText != null && _marathiText!.isNotEmpty
                      ? Text(
                          _marathiText!,
                          style: GoogleFonts.tiroDevanagariMarathi(
                            fontSize: widget.fontSize,
                            height: 1.85,
                            color: isDark
                                ? const Color(0xFFE8C99A)
                                : const Color(0xFF3E1E00),
                          ),
                        )
                      : Row(
                          children: [
                            const Icon(Icons.wifi_off_outlined,
                                size: 14, color: Colors.orange),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'मराठी भाषांतर उपलब्ध नाही. इंटरनेट तपासा.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange.shade700,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Sub-widgets ────────────────────────────────────────────────────────────

class _StoryContainer extends StatelessWidget {
  final bool isDark;
  final Widget child;
  const _StoryContainer({required this.isDark, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 16),
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

class _TranslationContainer extends StatelessWidget {
  final bool isDark;
  final Widget child;
  const _TranslationContainer({required this.isDark, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1A2C1A)
            : const Color(0xFFEFF7EF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
        ),
      ),
      child: child,
    );
  }
}

class _SectionDivider extends StatelessWidget {
  final String label;
  final bool isDark;
  const _SectionDivider({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
              color: const Color(0xFF4CAF50).withValues(alpha: 0.4)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            label,
            style: GoogleFonts.tiroDevanagariMarathi(
              color: const Color(0xFF4CAF50),
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Expanded(
          child: Divider(
              color: const Color(0xFF4CAF50).withValues(alpha: 0.4)),
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
