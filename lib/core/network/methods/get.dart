import 'package:smart_interview_ai/core/network/api_client.dart';

class Get {
  final ApiClient _client;
  Get(this._client);
  Future<T> call<T>(String path, {Map<String, dynamic>? query, Map<String, dynamic>? headers}) async {
    final res = await _client.get<T>(path, query: query, headers: headers);
    return res.data as T;
  }
}
