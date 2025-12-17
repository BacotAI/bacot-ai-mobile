import 'package:smart_interview_ai/core/network/api_client.dart';

class Post {
  final ApiClient _client;
  Post(this._client);
  Future<T> call<T>(String path, {Object? data, Map<String, dynamic>? headers}) async {
    final res = await _client.post<T>(path, data: data, headers: headers);
    return res.data as T;
  }
}
