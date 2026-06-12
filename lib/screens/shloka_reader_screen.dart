import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_provider.dart';
import '../widgets/shloka_card.dart';
import '../models/language_option.dart';

class ShlokReaderScreen extends StatefulWidget {
  final int chapterNum;
  final String chapterTitle;

  const ShlokReaderScreen({
    super.key,
    required this.chapterNum,
    required this.chapterTitle,
  });

  @override
  State<ShlokReaderScreen> createState() => _ShlokReaderScreenState();
}

class _ShlokReaderScreenState extends State<ShlokReaderScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final shlokas = provider.currentShlokas;
    final lang = langByCode(provider.translationLang);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chapter ${widget.chapterNum}',
              style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w400),
            ),
            Text(
              widget.chapterTitle,
              style: GoogleFonts.tiroDevanagariMarathi(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        // Show active translation language as a chip in the AppBar
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4)),
                ),
                child: Text(
                  lang.name,
                  style: GoogleFonts.tiroDevanagariMarathi(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: shlokas.isEmpty
          ? const Center(
              child:
                  CircularProgressIndicator(color: Color(0xFFC8922A)),
            )
          : Column(
              children: [
                // Progress bar
                LinearProgressIndicator(
                  value: (_currentIndex + 1) / shlokas.length,
                  backgroundColor:
                      Colors.grey.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFFC8922A)),
                  minHeight: 3,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    '${_currentIndex + 1}  /  ${shlokas.length}',
                    style: const TextStyle(
                      color: Color(0xFFC8922A),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                // Shloka pages
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: shlokas.length,
                    onPageChanged: (i) =>
                        setState(() => _currentIndex = i),
                    itemBuilder: (context, index) {
                      final shloka = shlokas[index];
                      final key =
                          '${widget.chapterNum}-${shloka.id}';
                      return ShlokaCard(
                        shloka: shloka,
                        chapterNum: widget.chapterNum,
                        bookmarkKey: key,
                        translationLang: provider.translationLang,
                        fontSize: provider.fontSize,
                        isBookmarked: provider.isBookmarked(key),
                        onBookmark: () =>
                            provider.toggleBookmark(key),
                      );
                    },
                  ),
                ),
                // Prev / Next navigation
                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _currentIndex > 0
                              ? () => _pageController.previousPage(
                                    duration: const Duration(
                                        milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  )
                              : null,
                          icon: const Icon(
                              Icons.arrow_back_ios,
                              size: 14),
                          label: const Text('Prev'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor:
                                const Color(0xFFC8922A),
                            side: const BorderSide(
                                color: Color(0xFFC8922A)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed:
                              _currentIndex < shlokas.length - 1
                                  ? () => _pageController.nextPage(
                                        duration: const Duration(
                                            milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      )
                                  : null,
                          icon: const Icon(
                              Icons.arrow_forward_ios,
                              size: 14),
                          label: const Text('Next'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFFC8922A),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
