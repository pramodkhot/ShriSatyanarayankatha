class LanguageOption {
  final String code;
  final String name;    // native script
  final String nameEn;  // English label
  final bool available; // true = data exists in JSON

  const LanguageOption({
    required this.code,
    required this.name,
    required this.nameEn,
    required this.available,
  });
}

// Add exp_XX field to chapter JSON files to light up each language.
const List<LanguageOption> kLanguages = [
  LanguageOption(code: 'hi', name: 'हिन्दी',    nameEn: 'Hindi',     available: true),
  LanguageOption(code: 'mr', name: 'मराठी',     nameEn: 'Marathi',   available: false),
  LanguageOption(code: 'gu', name: 'ગુજરાતી',   nameEn: 'Gujarati',  available: false),
  LanguageOption(code: 'bn', name: 'বাংলা',     nameEn: 'Bengali',   available: false),
  LanguageOption(code: 'ta', name: 'தமிழ்',    nameEn: 'Tamil',     available: false),
  LanguageOption(code: 'te', name: 'తెలుగు',   nameEn: 'Telugu',    available: false),
  LanguageOption(code: 'kn', name: 'ಕನ್ನಡ',    nameEn: 'Kannada',   available: false),
  LanguageOption(code: 'ml', name: 'മലയാളം',   nameEn: 'Malayalam', available: false),
  LanguageOption(code: 'pa', name: 'ਪੰਜਾਬੀ',   nameEn: 'Punjabi',   available: false),
  LanguageOption(code: 'or', name: 'ଓଡ଼ିଆ',    nameEn: 'Odia',      available: false),
];

LanguageOption langByCode(String code) =>
    kLanguages.firstWhere((l) => l.code == code, orElse: () => kLanguages.first);
