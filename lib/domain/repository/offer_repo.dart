import '../../data/model/base/api_response.dart';

abstract class OfferRepository {
  Future<ApiResponse> getOffers();
  Future<ApiResponse> getOfferDetails({required int offerId});
}
