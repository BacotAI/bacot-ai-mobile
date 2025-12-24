import '../entities/sample_user.dart';

abstract class SampleRepository {
  Future<List<SampleUser>> getUsers();
}
