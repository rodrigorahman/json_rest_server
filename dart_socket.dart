import 'dart:io';

Future<void> main() async {
  await Socket.connect('localhost', 8081);
}
