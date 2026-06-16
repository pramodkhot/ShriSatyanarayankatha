import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import 'chapter_list_screen.dart';
import 'bookmark_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Status bar height — used to push the image below the notification bar
    final topInset = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // Total expanded height = status bar + visible image area
            expandedHeight: topInset + 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                AppConstants.appNameHindi,
                style: GoogleFonts.tiroDevanagariMarathi(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              background: Column(
                children: [
                  // Push image below the status bar so its text is visible
                  SizedBox(height: topInset),
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          AppConstants.appImage,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.72),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.bookmark_outlined, color: Colors.white),
                tooltip: 'Bookmarks',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const BookmarkScreen()),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                tooltip: 'Settings',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const SettingsScreen()),
                ),
              ),
            ],
          ),
          // SliverSafeArea adds bottom padding so the quote card
          // never goes behind the phone's navigation bar
          SliverSafeArea(
            top: false,
            sliver: SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StatsCard(),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ChapterListScreen()),
                      ),
                      icon: const Icon(Icons.menu_book_rounded),
                      label: const Text('Read Shri Satyanarayankatha'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC8922A),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 32),
                    _AboutSection(),
                    const SizedBox(height: 32),
                    _QuoteCard(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _Stat('5', 'Adhyayas'),
            _VDivider(),
            _Stat('3', 'Sections'),
            _VDivider(),
            _Stat('2', 'Languages'),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFFC8922A),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }
}

class _VDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: 1,
      color: Colors.grey.withValues(alpha: 0.3),
    );
  }
}

class _AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFC8922A),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'श्री सत्यनारायण व्रत कथा भगवान विष्णु के सत्यनारायण स्वरूप की पूजा और '
          'व्रत की पावन कथा है। इसमें पाँच अध्याय, पूजा विधि और आरती सम्मिलित हैं। '
          'यह व्रत मनोकामनाओं की पूर्ति और सुख-समृद्धि के लिए किया जाता है।',
          style: TextStyle(
            fontSize: 14,
            height: 1.7,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}

class _QuoteCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF2C1A0A)
            : const Color(0xFFF5E0B0),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFC8922A).withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        children: [
          const Icon(Icons.format_quote, color: Color(0xFFC8922A), size: 28),
          const SizedBox(height: 8),
          Text(
            'सत्यनारायणो विष्णुर्वाञ्छितार्थफलप्रदः।',
            style: GoogleFonts.tiroDevanagariMarathi(
              fontSize: 15,
              height: 1.8,
              color: isDark
                  ? const Color(0xFFF5DEB3)
                  : const Color(0xFF3E1E00),
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '"भगवान सत्यनारायण सभी मनोवांछित फलों को देने वाले हैं।"',
            style: TextStyle(
              fontSize: 13,
              height: 1.6,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          const Text(
            '— प्रथम अध्याय',
            style: TextStyle(
              color: Color(0xFFC8922A),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
