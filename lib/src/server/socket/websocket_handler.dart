import 'dart:async';
import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:uuid/uuid.dart';

class WebSocketHandler {
  final sockets = [];
  final List<Map<String, dynamic>> socketsTableListener = [];

  FutureOr<Response> load(Request request) {
    final websocketHandler = webSocketHandler((webSocket) {
      if (request.url.queryParameters case {'tables': final tables}) {
        socketsTableListener.add({
          'id': Uuid().v1(),
          'tables': tables.split(','),
          'socket': webSocket,
        });
      } else {
        sockets.add(webSocket);
      }

      (webSocket.stream as Stream).listen(
        (message) {},
        onDone: () {
          sockets.remove(webSocket);
          socketsTableListener
              .removeWhere((element) => element['socket'] == webSocket);
          print('closed socket: ${webSocket.hashCode}');
        },
        onError: (error) {
          sockets.remove(webSocket);
          socketsTableListener
              .removeWhere((element) => element['socket'] == webSocket);
          print('Closed socket (Error: $error) ${webSocket.hashCode}');
        },
      );
    });

    return websocketHandler(request);
  }

  bool sendMessage(dynamic data) {
    final {'table': table} = jsonDecode(data);

    for (final socket in sockets) {
      socket.sink.add(data);
    }

    for (final socketListener in socketsTableListener) {
      if (socketListener
          case {
            'tables': final List<String> tableSocket,
            'socket': final socket
          } when tableSocket.contains(table)) {
        socket.sink.add(data);
      }
    }

    return true;
  }
}
