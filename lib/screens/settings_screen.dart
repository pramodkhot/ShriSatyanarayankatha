import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_provider.dart';
import '../models/language_option.dart';
import '../utils/constants.dart';
import 'language_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final selectedLang = langByCode(provider.translationLang);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Display ────────────────────────────────────────────────────
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

          // ── About ──────────────────────────────────────────────────────
          const SizedBox(height: 16),
          _SectionLabel('About'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      AppConstants.appImage,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppConstants.appName,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                        SizedBox(height: 2),
                        Text(
                          AppConstants.appNameHindi,
                          style: TextStyle(
                              color: Color(0xFFC8922A),
                              fontSize: 13),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Version 1.0.0',
                          style: TextStyle(
                              color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
