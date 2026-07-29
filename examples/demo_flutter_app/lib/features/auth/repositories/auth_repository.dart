/// Data access for Auth.
abstract class AuthRepository {
  Future<void> initialize();
}

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<void> initialize() async {}
}
