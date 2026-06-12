class Shloka {
  final String id;
  final String shlok;
  final String expHi;
  final String expMr;
  final String expEn;

  const Shloka({
    required this.id,
    required this.shlok,
    required this.expHi,
    required this.expMr,
    required this.expEn,
  });

  factory Shloka.fromJson(Map<String, dynamic> json) {
    return Shloka(
      id: json['id'].toString(),
      shlok: json['shlok'] as String? ?? '',
      expHi: json['exp_hi'] as String? ?? '',
      expMr: json['exp_mr'] as String? ?? '',
      expEn: json['exp_en'] as String? ?? '',
    );
  }

  String get verseNumber {
    final parts = id.split('-');
    return parts.length > 1 ? parts[1] : id;
  }
}
