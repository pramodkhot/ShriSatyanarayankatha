import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/shloka.dart';
import '../providers/app_provider.dart';

class ShlokaCard extends StatelessWidget {
  final Shloka shloka;
  final int chapterNum;
  final String bookmarkKey;
  final Language language;
  final double fontSize;
  final bool isBookmarked;
  final VoidCallback onBookmark;

  const ShlokaCard({
    super.key,
    required this.shloka,
    required this.chapterNum,
    required this.bookmarkKey,
    required this.language,
    required this.fontSize,
    required this.isBookmarked,
    required this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final explanation =
        language == Language.hindi ? shloka.expHi : shloka.expEn;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sanskrit verse
          Container(
            padding: const EdgeInsets.all(20),
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
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC8922A),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'श्लोक ${shloka.verseNumber}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
                const SizedBox(height: 14),
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
          const SizedBox(height: 18),
          // Divider with label
          Row(
            children: [
              Expanded(
                child: Divider(
                    color: const Color(0xFFC8922A).withValues(alpha: 0.35)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  language == Language.hindi ? 'अर्थ' : 'Meaning',
                  style: const TextStyle(
                    color: Color(0xFFC8922A),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                    color: const Color(0xFFC8922A).withValues(alpha: 0.35)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Explanation
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF2C1A0A)
                  : Colors.white.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFA0522D).withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              explanation,
              style: GoogleFonts.tiroDevanagariMarathi(
                fontSize: fontSize,
                height: 1.75,
                color: isDark
                    ? const Color(0xFFE8C99A)
                    : const Color(0xFF3E1E00),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
