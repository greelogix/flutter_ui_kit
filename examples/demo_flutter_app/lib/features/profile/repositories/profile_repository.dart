/// Data access for Profile.
abstract class ProfileRepository {
  Future<void> initialize();
}

class ProfileRepositoryImpl implements ProfileRepository {
  @override
  Future<void> initialize() async {}
}
