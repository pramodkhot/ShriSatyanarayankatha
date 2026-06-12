import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_provider.dart';
import '../models/language_option.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Translation Language')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Text(
              'Sanskrit and English are always shown. '
              'Select the language for the middle translation slot.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ),
          Expanded(
            child: RadioGroup<String>(
              groupValue: provider.translationLang,
              onChanged: (code) {
                if (code != null) {
                  provider.setTranslationLang(code);
                  Navigator.pop(context);
                }
              },
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                itemCount: kLanguages.length,
                separatorBuilder: (_, _) =>
                    const Divider(height: 1, indent: 56),
                itemBuilder: (context, i) {
                  final lang = kLanguages[i];
                  final isSelected =
                      provider.translationLang == lang.code;
                  return RadioListTile<String>(
                    value: lang.code,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    title: Text(
                      lang.name,
                      style: GoogleFonts.tiroDevanagariMarathi(
                        fontSize: 16,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? const Color(0xFFC8922A)
                            : null,
                      ),
                    ),
                    subtitle: Text(
                      lang.nameEn,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey[600]),
                    ),
                    secondary: lang.available
                        ? _Badge(
                            label: 'Available',
                            bg: Colors.green,
                          )
                        : _Badge(
                            label: 'Coming soon',
                            bg: Colors.orange,
                          ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color bg;
  const _Badge({required this.label, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: bg.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: bg,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
