// {
//           "id": 1,
//           "image": "http://don.dev01.matrix-clouds.com/storage/banners/images/BAEm0jo7GcwBgbjDC7rNJ9cZFSUlH4T4FLw8UGfO.jpg"
//       },
class BannerModel {
  BannerModel({
    required this.id,
    required this.image,
  });

  final int id;
  final String? image;

  factory BannerModel.fromJson(Map<String, dynamic> json) => BannerModel(
        id: json["id"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
      };
}
