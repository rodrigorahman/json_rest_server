import 'package:event_bus/event_bus.dart';
import 'package:json_rest_server/src/core/broadcast/broadcast_base.dart';
import 'package:json_rest_server/src/core/broadcast/broadcast_factory.dart';
import 'package:json_rest_server/src/core/enum/broadcast_type.dart';
import 'package:json_rest_server/src/models/broadcast_model.dart';

class BroadCastController {
  final EventBus _eventBus = EventBus();

  BroadCastController() {
    _eventBus.on<BroadcastModel>().listen((BroadcastModel broadCast) {
      BroadcastBase broadcastBase = BroadcastFactory.create(broadcast: broadCast);
      broadcastBase.execute(broadcast: broadCast);
    });
  }
  void execute({List<String>? providers, required BroadcastModel broadcast}) {
    if (providers != null) {
      for (var provider in providers) {
        _eventBus.fire(broadcast.copyWith(broadCastType: BroadCastType.fromString(provider)));
      }
    }
  }
}
