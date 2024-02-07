abstract class StorageRepo {
  Future<void> setUser({required String username, required String password});

  Future<void> deleteUser();

  Future<Map<String, String>?> getUser();
}
