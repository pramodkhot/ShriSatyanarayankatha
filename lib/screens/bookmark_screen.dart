import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_provider.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

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
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: bookmarks.length,
              itemBuilder: (context, index) {
                final key = bookmarks[index];
                final parts = key.split('-');
                final chap = parts[0];
                final verse = parts.length > 1 ? parts[1] : parts[0];
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
                    subtitle: Text('Shloka $verse',
                        style: const TextStyle(fontSize: 14)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline,
                          size: 20, color: Colors.grey),
                      onPressed: () =>
                          context.read<AppProvider>().toggleBookmark(key),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
