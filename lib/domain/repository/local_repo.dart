abstract class LocalRepository {
  Future<bool> saveSecuredData(String token);
  Future<bool> clearSharedData();
  bool isLoggedIn();
  Future<String> getUserToken();
}
