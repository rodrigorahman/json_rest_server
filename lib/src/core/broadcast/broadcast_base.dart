import '../../models/broadcast_model.dart';

abstract class BroadcastBase {
  Future<bool> execute({required BroadcastModel broadcast});
}
