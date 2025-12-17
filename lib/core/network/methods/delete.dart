import 'package:smart_interview_ai/core/network/api_client.dart';

class Delete {
  final ApiClient _client;
  Delete(this._client);
  Future<T> call<T>(String path, {Object? data, Map<String, dynamic>? headers}) async {
    final res = await _client.delete<T>(path, data: data, headers: headers);
    return res.data as T;
  }
}
