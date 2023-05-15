import 'portfolio_image.dart';

class PortfolioResponse {
  int? code;
  String? message;
  List<PortfolioModel>? portfolioImages;

  PortfolioResponse({this.code, this.message, this.portfolioImages});

  factory PortfolioResponse.fromJson(Map<String, dynamic> json) {
    return PortfolioResponse(
      code: json['code'] as int?,
      message: json['message'] as String?,
      portfolioImages: (json['portfolio_images'] as List<dynamic>?)
          ?.map((e) => PortfolioModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
        'data': portfolioImages?.map((e) => e.toJson()).toList(),
      };
}
