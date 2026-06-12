import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_provider.dart';
import 'shloka_reader_screen.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  Future<void> _openBookmark(BuildContext context, String key) async {
    final dashIndex = key.indexOf('-');
    if (dashIndex < 0) return;

    final chapterNum = int.parse(key.substring(0, dashIndex));
    final shlokaId = key.substring(dashIndex + 1);

    final provider = context.read<AppProvider>();

    // Find chapter title
    final chapters = provider.chapters;
    final chapterInfo = chapters.firstWhere(
      (c) => c.id == chapterNum,
      orElse: () => chapters.first,
    );

    // Load the chapter shlokas
    await provider.loadChapter(chapterNum);

    if (!context.mounted) return;

    // Find the page index for this shloka
    final shlokas = provider.currentShlokas;
    final pageIndex =
        shlokas.indexWhere((s) => s.id == shlokaId);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ShlokReaderScreen(
          chapterNum: chapterNum,
          chapterTitle: chapterInfo.subtitle,
          initialPage: pageIndex >= 0 ? pageIndex : 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookmarks = context.watch<AppProvider>().bookmarks.toList()
      ..sort();

    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: bookmarks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bookmark_outline,
                      size: 64, color: Color(0xFFC8922A)),
                  const SizedBox(height: 16),
                  Text(
                    'No bookmarks yet',
                    style: GoogleFonts.tiroDevanagariMarathi(
                        fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Tap the bookmark icon while reading a shloka',
                    style:
                        TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final key = bookmarks[index];
                final dashIndex = key.indexOf('-');
                final chap = dashIndex >= 0
                    ? key.substring(0, dashIndex)
                    : key;
                final verse = dashIndex >= 0
                    ? key.substring(dashIndex + 1)
                    : key;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    leading: const Icon(Icons.bookmark,
                        color: Color(0xFFC8922A)),
                    title: Text(
                      'Chapter $chap',
                      style: const TextStyle(
                        color: Color(0xFFA0522D),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    subtitle: Text(
                      'Shloka $verse  •  Tap to read',
                      style: const TextStyle(fontSize: 13),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.chevron_right,
                            color: Color(0xFFC8922A), size: 20),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              size: 20, color: Colors.grey),
                          tooltip: 'Remove bookmark',
                          onPressed: () => context
                              .read<AppProvider>()
                              .toggleBookmark(key),
                        ),
                      ],
                    ),
                    onTap: () => _openBookmark(context, key),
                  ),
                );
              },
            ),
    );
  }
}
