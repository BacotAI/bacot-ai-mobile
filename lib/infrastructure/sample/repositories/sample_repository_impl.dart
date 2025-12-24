import 'package:injectable/injectable.dart';
import 'package:smart_interview_ai/core/network/api_client.dart';
import 'package:smart_interview_ai/core/network/endpoints.dart';
import 'package:smart_interview_ai/domain/sample/entities/sample_user.dart';
import 'package:smart_interview_ai/domain/sample/repositories/sample_repository.dart';
import 'package:smart_interview_ai/infrastructure/sample/models/sample_user_model.dart';

@LazySingleton(as: SampleRepository)
class SampleRepositoryImpl implements SampleRepository {
  final ApiClient apiClient;

  SampleRepositoryImpl({required this.apiClient});

  @override
  Future<List<SampleUser>> getUsers() async {
    final res = await apiClient.get<List<dynamic>>(Endpoints.users);
    final data = res.data ?? [];
    return data
        .map((e) => SampleUserModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
