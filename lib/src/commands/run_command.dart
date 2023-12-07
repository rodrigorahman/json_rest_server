import 'package:args/command_runner.dart';
import 'package:json_rest_server/src/server/json_rest_server.dart';

class RunCommand extends Command {
  @override
  String get description => 'run server';

  @override
  String get name => 'run';

  @override
  void run() => JsonRestServer().startServer();
}
