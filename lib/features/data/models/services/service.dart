import 'package:equatable/equatable.dart';

class ServiceModel extends Equatable {
  final int? id;
  final String? title;
  final String? breif;
  final String? image;
  final bool? myService;

  const ServiceModel({
    this.id,
    this.title,
    this.breif,
    this.image,
    this.myService,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        id: json['id'] as int?,
        title: json['title'] as String?,
        breif: json['breif'] as String?,
        image: json['image'] as String?,
        myService: json['my_service'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'breif': breif,
        'image': image,
        'my_service': myService,
      };
  copyWith({
    int? id,
    String? title,
    String? breif,
    String? image,
    bool? myService,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      title: title ?? this.title,
      breif: breif ?? this.breif,
      image: image ?? this.image,
      myService: myService ?? this.myService,
    );
  }

  @override
  List<Object?> get props => [id, title, breif, image, myService];
}
