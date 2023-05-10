// import 'package:weltweit/features/data/models/response/country/country_model.dart';

// class LoginBody {
//   String _phone;
//   CountryModel _countryModel;
//   String _password;
//   String _deviceToken;

//   LoginBody({
//     required String phone,
//     required CountryModel countryModel,
//     required String password,
//     required String deviceToken,
//   })  : _phone = phone,
//         _countryModel = countryModel,
//         _password = password,
//         _deviceToken = deviceToken;

//   String get deviceToken => _deviceToken;
//   String get password => _password;
//   CountryModel get countryModel => _countryModel;
//   String get phone => _phone;

//   Map<String, dynamic> toJson() {
//     return {
//       "mobile_number": _phone,
//       "password": _password,
//       "country_countryModel": _countryModel,
//       "fcm_token": _deviceToken,
//     };
//   }

//   setData({
//     required String phone,
//     required String password,
//     required String deviceToken,
//   }) {
//     _phone = phone;
//     _password = password;
//     _deviceToken = deviceToken;
//   }

//   updateCountry(CountryModel countryModel) {
//     _countryModel = countryModel;
//   }
// }
