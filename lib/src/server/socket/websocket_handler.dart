import 'dart:async';
import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:uuid/uuid.dart';

typedef WebSocketRegister = ({
  String id,
  List<String>? tables,
  dynamic socket,
});

final class WebSocketHandler {
  final sockets = <WebSocketRegister>[];

  FutureOr<Response> load(Request request) {
    final handler = webSocketHandler((webSocket) {
      final tables = request.url.queryParameters['tables'];

      sockets.add(
        (
          id: Uuid().v1(),
          tables: tables?.split(','),
          socket: webSocket,
        ),
      );

      webSocket.stream.listen(
        (message) {},
        onDone: () {
          sockets.removeWhere((element) => element.socket == webSocket);
          print('closed socket: ${webSocket.hashCode}');
        },
        onError: (error) {
          sockets.removeWhere((element) => element.socket == webSocket);
          print('Closed socket (Error: $error) ${webSocket.hashCode}');
        },
      );
    });

    return handler(request);
  }

  bool sendMessage(dynamic data) {
    final {'table': table} = jsonDecode(data);
    for (final notifications in sockets) {
      final (id: _, :tables, :socket) = notifications;

      switch (tables) {
        case List(isEmpty: false) when tables.contains(table):
          socket.sink.add(data);
        case List(isEmpty: true) || null:
          socket.sink.add(data);
      }
    }
    return true;
  }
}
