// {
//           "id": 1,
//           "title_en": "small description",
//           "title_ar": "وصف صغير",
//           "created_at": "2023-07-26T18:06:48.000000Z",
//           "updated_at": "2023-07-26T18:06:48.000000Z"
//       }

class HiringDocumentModel {
  int? id;
  String? titleEn;
  String? titleAr;
  DateTime? createdAt;
  DateTime? updatedAt;

  HiringDocumentModel({
    this.id,
    this.titleEn,
    this.titleAr,
    this.createdAt,
    this.updatedAt,
  });

  factory HiringDocumentModel.fromJson(Map<String, dynamic> json) => HiringDocumentModel(
        id: json["id"] as int?,
        titleEn: json["title_en"] as String?,
        titleAr: json["title_ar"] as String?,
        createdAt: DateTime.tryParse(json["created_at"] as String),
        updatedAt: DateTime.tryParse(json["updated_at"] as String),
      );
}
