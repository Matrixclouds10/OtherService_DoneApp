class PortfolioModel {
  int? id;
  int? providerId;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool isDeleting;
  bool isUploading;

  PortfolioModel({
    this.id,
    this.providerId,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.isDeleting = false,
    this.isUploading = false,
  });

  factory PortfolioModel.fromJson(Map<String, dynamic> json) {
    return PortfolioModel(
      id: json['id'] as int?,
      providerId: json['provider_id'] as int?,
      image: json['image'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'provider_id': providerId,
        'image': image,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}
