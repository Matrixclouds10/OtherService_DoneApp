
class CountryModel {
  int? id;
  String? title;
  String? code;
  String? logo;
  String? facebook;
  String? twitter;
  String? whatsapp;
  String? taam;

  CountryModel(
      {this.id,
      this.title,
      this.code,
      this.logo,
      this.facebook,
      this.twitter,
      this.whatsapp,
      this.taam});

  CountryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    code = json['code'].toString();
    logo = json['logo'];
    facebook = json['facebook'];
    twitter = json['twitter'];
    whatsapp = json['whatsapp'];
    taam = json['taam'];
  }
}