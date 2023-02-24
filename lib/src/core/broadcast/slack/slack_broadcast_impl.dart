// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:json_rest_server/src/models/broadcast_model.dart';
import 'package:json_rest_server/src/models/config_model.dart';

import '../broadcast_base.dart';

class SlackBroadCastImpl implements BroadcastBase {
  final ConfigModel _config;
  SlackBroadCastImpl({
    required ConfigModel config,
  }) : _config = config;
  @override
  Future<bool> execute({required BroadcastModel broadcast}) async {
    if (_config.slack != null) {
      Map payload = {};
      if (_config.slack?.channel != null) {
        payload['channel'] = _config.slack?.channel ?? '';
      }
      payload['text'] = broadcast.toJson();
      final response = await http.post(Uri.parse(_config.slack!.url), body: json.encode(payload));
      if (response.statusCode == 200) {
        log('Send to Slack', time: DateTime.now());
      }
      return true;
    }
    return false;
  }
}
