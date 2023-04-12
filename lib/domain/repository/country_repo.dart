import '../../data/model/base/api_response.dart';

abstract class CountryRepository {
  Future<ApiResponse> getCountries();
}
