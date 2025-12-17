import 'package:smart_interview_ai/core/network/api_client.dart';

class Put {
  final ApiClient _client;
  Put(this._client);
  Future<T> call<T>(String path, {Object? data, Map<String, dynamic>? headers}) async {
    final res = await _client.put<T>(path, data: data, headers: headers);
    return res.data as T;
  }
}
