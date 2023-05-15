//  {
//    "code": 200,
//    "message": "Data Fetched Successfully",
//    "data": {
//      "about_us": "تطبيق \"تم\" منصة خدمات إلكترونية متخصصة في مجال المقاولات والصيانة، وهي منصة وسيطة بين مزودي الخدمات من ناحية والعملاء من ناحية أخرى، فيستهدف التطبيق مزودي الخدمات الأفراد من الفنيين والمهنيين وكذلك الشركات والمؤسسات التي لديها فنيين ومهنيين متخصصين يعملون وفق أنظمة العمل السعودية، وتتيح لهم الاشتراك في التطبيق وتقديم خدمات المقاولات والصيانة، كما يستهدف التطبيق العملاء الراغبين في الاستفادة من هذه الخدمات ويتيح لهم التواصل مع مزودي الخدمات المسجلين بالتطبيق للاستفادة من خدماتهم، وتقدم جميع خدمات التطبيق وفق الأنظمة المعمول بها في الم�
// I/flutter ( 8745): │ 🐛   }
// I/flutter ( 8745): │ 🐛 }

//    }

  class AboutResponse {
    AboutResponse({
      required this.code,
      required this.message,
      required this.data,
    });

    int code;
    String message;
    AboutData data;

    factory AboutResponse.fromJson(Map<String, dynamic> json) => AboutResponse(
      code: json["code"],
      message: json["message"],
      data: AboutData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
      "code": code,
      "message": message,
      "data": data.toJson(),
    };
  }

  class AboutData {
    AboutData({
      required this.aboutUs,
    });

    String aboutUs;

    factory AboutData.fromJson(Map<String, dynamic> json) => AboutData(
      aboutUs: json["about_us"],
    );

    Map<String, dynamic> toJson() => {
      "about_us": aboutUs,
    };
  }