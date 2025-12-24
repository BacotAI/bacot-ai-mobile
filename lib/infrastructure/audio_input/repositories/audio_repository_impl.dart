import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:smart_interview_ai/core/network/api_client.dart';
import 'package:smart_interview_ai/domain/audio_input/models/transcribe_response_model.dart';
import 'package:smart_interview_ai/domain/audio_input/audio_repository.dart';

@LazySingleton(as: AudioRepository)
class AudioRepositoryImpl implements AudioRepository {
  final ApiClient _client;

  AudioRepositoryImpl(this._client);

  @override
  Future<String> uploadAudio(String filePath) async {
    final fileName = filePath.split('/').last;

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
    });

    try {
      final response = await _client.post(
        'https://paulene-eluvial-nila.ngrok-free.dev/transcribe',
        data: formData,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        );
      }

      TranscribeResponseModel model = TranscribeResponseModel.fromJson(
        response.data,
      );

      return model.text;
    } catch (e) {
      rethrow;
    }
  }
}
