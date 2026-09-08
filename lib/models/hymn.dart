class Hymn {
  final int id;
  final String number;
  final String title;
  final String category;
  final List<String> stanzas;
  final String? refrain;
  final String? keySignature;
  final String? tune;
  bool isFavorite;

  Hymn({
    required this.id,
    required this.number,
    required this.title,
    required this.category,
    required this.stanzas,
    this.refrain,
    this.keySignature,
    this.tune,
    this.isFavorite = false,
  });

  Hymn copyWith({
    int? id,
    String? number,
    String? title,
    String? category,
    List<String>? stanzas,
    String? refrain,
    String? keySignature,
    String? tune,
    bool? isFavorite,
  }) {
    return Hymn(
      id: id ?? this.id,
      number: number ?? this.number,
      title: title ?? this.title,
      category: category ?? this.category,
      stanzas: stanzas ?? this.stanzas,
      refrain: refrain ?? this.refrain,
      keySignature: keySignature ?? this.keySignature,
      tune: tune ?? this.tune,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
