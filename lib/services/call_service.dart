import '../models/call.dart';
import 'api_client.dart';

class CallService {
  final ApiClient _apiClient;
  CallService(this._apiClient);

  Future<Call> initiateCall(String calleeId) async {
    final res = await _apiClient.post('/protected/calls', data: {'callee_id': calleeId});
    return Call.fromJson(res.data);
  }

  Future<Call> updateCallStatus(String callId, CallStatus status) async {
    final res = await _apiClient.put('/protected/calls/$callId/status', data: {'status': status.name});
    return Call.fromJson(res.data);
  }
}