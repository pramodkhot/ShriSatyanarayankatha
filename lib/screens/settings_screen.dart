import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/app_provider.dart';
import '../models/language_option.dart';
import '../utils/constants.dart';
import 'language_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.creative.shri_satyanarayankatha';

  Future<void> _shareApp() async {
    await Share.share(
      'Read the Shri Satyanarayankatha — a timeless Advaita Vedanta scripture — '
      'with Sanskrit, Hindi, and English translations.\n\n'
      '📱 Download the app:\n$_playStoreUrl',
    );
  }

  Future<void> _rateUs(BuildContext context) async {
    final uri = Uri.parse(_playStoreUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Play Store')),
      );
    }
  }

  void _showAboutDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                AppConstants.appImage,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              AppConstants.appName,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              AppConstants.appNameHindi,
              style: GoogleFonts.tiroDevanagariMarathi(
                color: const Color(0xFFC8922A),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppConstants.appSubtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            const Text(
              'Version 1.0.25',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              'The Shri Satyanarayankatha records the dialogue between Sage Ashtavakra '
              'and King Janaka on the nature of the Self, liberation, and '
              'ultimate reality.',
              style: TextStyle(
                fontSize: 13,
                height: 1.6,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _InfoStat('20', 'Chapters'),
                _InfoStat('298', 'Shlokas'),
                _InfoStat('10', 'Languages'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close',
                style: TextStyle(color: Color(0xFFC8922A))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final selectedLang = langByCode(provider.translationLang);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Home ───────────────────────────────────────────────────────
          _SectionLabel('Home'),
          Card(
            child: ListTile(
              leading:
                  const Icon(Icons.home_outlined, color: Color(0xFFC8922A)),
              title: const Text('Go to Home'),
              subtitle: const Text('Return to the main screen'),
              trailing: const Icon(Icons.arrow_forward_ios,
                  size: 14, color: Colors.grey),
              onTap: () => Navigator.popUntil(
                  context, (route) => route.isFirst),
            ),
          ),

          // ── Share & Rate ────────────────────────────────────────────────
          const SizedBox(height: 16),
          _SectionLabel('Share App'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.share_outlined,
                      color: Color(0xFFC8922A)),
                  title: const Text('Share App'),
                  subtitle:
                      const Text('Invite friends to read Shri Satyanarayankatha'),
                  onTap: _shareApp,
                ),
                const Divider(height: 1, indent: 16),
                ListTile(
                  leading: const Icon(Icons.star_rate_outlined,
                      color: Color(0xFFC8922A)),
                  title: const Text('Rate Us'),
                  subtitle:
                      const Text('Share your feedback on the Play Store'),
                  onTap: () => _rateUs(context),
                ),
              ],
            ),
          ),

          // ── Display ────────────────────────────────────────────────────
          const SizedBox(height: 16),
          _SectionLabel('Display'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Switch to dark theme'),
                  secondary: const Icon(Icons.dark_mode_outlined,
                      color: Color(0xFFC8922A)),
                  value: provider.isDarkMode,
                  activeThumbColor: const Color(0xFFC8922A),
                  onChanged: (_) => provider.toggleDarkMode(),
                ),
                const Divider(height: 1, indent: 16),
                ListTile(
                  leading: const Icon(Icons.format_size,
                      color: Color(0xFFC8922A)),
                  title: const Text('Font Size'),
                  subtitle: Slider(
                    value: provider.fontSize,
                    min: 12,
                    max: 22,
                    divisions: 5,
                    activeColor: const Color(0xFFC8922A),
                    label: provider.fontSize.round().toString(),
                    onChanged: provider.setFontSize,
                  ),
                  trailing: Text(
                    provider.fontSize.round().toString(),
                    style: const TextStyle(
                        color: Color(0xFFC8922A),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // ── Language ───────────────────────────────────────────────────
          const SizedBox(height: 16),
          _SectionLabel('Language'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.translate,
                  color: Color(0xFFC8922A)),
              title: const Text('Translation Language'),
              subtitle: Row(
                children: [
                  Text(
                    selectedLang.name,
                    style: GoogleFonts.tiroDevanagariMarathi(
                      fontSize: 14,
                      color: const Color(0xFFC8922A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '(${selectedLang.nameEn})',
                    style: TextStyle(
                        fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              trailing: const Icon(Icons.chevron_right,
                  color: Color(0xFFC8922A)),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const LanguageScreen()),
              ),
            ),
          ),

          // ── About App ──────────────────────────────────────────────────
          const SizedBox(height: 16),
          _SectionLabel('About App'),
          Card(
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  AppConstants.appImage,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              title: const Text(AppConstants.appName),
              subtitle: Text(
                AppConstants.appNameHindi,
                style: GoogleFonts.tiroDevanagariMarathi(
                  fontSize: 13,
                  color: const Color(0xFFC8922A),
                ),
              ),
              trailing: const Icon(Icons.info_outline,
                  color: Color(0xFFC8922A)),
              onTap: () => _showAboutDialog(context),
            ),
          ),

          const SizedBox(height: 24),
          Center(
            child: Text(
              'Version 1.0.0  •  com.creative.shri_satyanarayankatha',
              style:
                  TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFFC8922A),
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class _InfoStat extends StatelessWidget {
  final String value;
  final String label;
  const _InfoStat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFFC8922A),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }
}
