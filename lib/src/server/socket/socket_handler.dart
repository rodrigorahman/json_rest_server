import 'dart:io';
import 'dart:typed_data';

class SocketHandler {
  late final ServerSocket server;
  List<Socket> clients = [];
  // Avoid self isntance
  Future<SocketHandler> load(
      {required int socketPort, required String socketIp}) async {
    await _init(socketPort: socketPort, socketIp: socketIp);
    return this;
  }

  Future<void> _init(
      {required int socketPort, required String socketIp}) async {
    server = await ServerSocket.bind(socketIp, socketPort);
    server.listen((client) {
      _listenConnection(client);
    });
  }

  _removeFromServer(client) {
    client.close();
    clients.remove(client);
    print(" ${clients.length} left on server");
  }

  _addFromServer(client) {
    clients.add(client);
    print(" ${clients.length} on server");
  }

  void _listenConnection(Socket client) {
    print(
        'Connection from  ${client.remoteAddress.address}:${client.remotePort}');
    _addFromServer(client);

    client.listen(
      (event) {
        _listenEvents(event);
      },
      onError: (error) {
        print(error);
        _removeFromServer(client);
      },
      onDone: () {
        _removeFromServer(client);
      },
    );
  }

  bool sendMessage(dynamic data) {
    if (clients.isNotEmpty) {
      for (var client in clients) {
        client.write(data);
      }
      return true;
    }
    return false;
  }

  void _listenEvents(Uint8List event) async {
    await Future.delayed(Duration(seconds: 1));
    final message = String.fromCharCodes(event);
    print(message);
  }
}
