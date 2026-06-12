class ChapterInfo {
  final int id;
  final String subtitle;

  const ChapterInfo({required this.id, required this.subtitle});

  factory ChapterInfo.fromJson(Map<String, dynamic> json) {
    return ChapterInfo(
      id: int.parse(json['id'].toString()),
      subtitle: json['subtitle'] as String,
    );
  }
}
