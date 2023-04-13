class Document {
  int? id;
  int? providerId;
  String? image;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool deleting;
  Document({
    this.id,
    this.providerId,
    this.image,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.deleting = false,
  });

  factory Document.fromJson(Map<String, dynamic> json) => Document(
        id: json['id'] as int?,
        providerId: json['provider_id'] as int?,
        image: json['image'] as String?,
        type: json['type'] as String?,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'provider_id': providerId,
        'image': image,
        'type': type,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };

  copyWith({
    int? id,
    int? providerId,
    String? image,
    String? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? deleting,
  }) {
    return Document(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      image: image ?? this.image,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deleting: deleting ?? this.deleting,
    );
  }
}
