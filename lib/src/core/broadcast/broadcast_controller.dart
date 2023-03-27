import 'dart:developer';

import 'package:event_bus/event_bus.dart';
import 'package:json_rest_server/src/core/broadcast/broadcast_base.dart';
import 'package:json_rest_server/src/core/broadcast/broadcast_factory.dart';
import 'package:json_rest_server/src/core/enum/broadcast_type.dart';
import 'package:json_rest_server/src/models/broadcast_model.dart';

class BroadCastController {
  final EventBus _eventBus = EventBus();
  List<String> _customProviders = [];

  BroadCastController() {
    _eventBus.on<BroadcastModel>().listen((BroadcastModel broadCast) {
      BroadcastBase? broadcastBase =
          BroadcastFactory.create(broadcast: broadCast);

      broadcastBase?.execute(broadcast: broadCast);
    });
  }

  BroadCastController single(String provider) {
    _customProviders.clear();
    _customProviders.add(provider);
    return this;
  }

  BroadCastController multi(List<String> provider) {
    _customProviders.clear();
    _customProviders = provider.toSet().toList();
    return this;
  }

  void execute({List<String>? providers, required BroadcastModel broadcast}) {
    if (_customProviders.isNotEmpty) {
      providers = _customProviders;
    }
    if (providers != null) {
      for (var provider in providers) {
        if (BroadCastType.fromString(provider) == null) {
          log('BroadCast provider: $provider not found');
        } else {
          _eventBus.fire(broadcast.copyWith(
              broadCastType: BroadCastType.fromString(provider)));
        }
      }
    }
    _customProviders.clear();
  }
}
