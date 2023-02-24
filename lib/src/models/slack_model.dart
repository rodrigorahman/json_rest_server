// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SlackModel {
  final String url;
  final String? channel;
  SlackModel({
    required this.url,
    this.channel,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'url': url,
      'channel': channel,
    };
  }

  factory SlackModel.fromMap(Map<String, dynamic> map) {
    return SlackModel(
      url: map['slackUrl'] as String,
      channel: map['slackChannel'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SlackModel.fromJson(String source) => SlackModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
