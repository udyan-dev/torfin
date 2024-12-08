abstract class StorageRepository {
  String getToken();

  Future<bool> setToken({required String token});
}
