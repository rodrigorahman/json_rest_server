import 'package:args/command_runner.dart';
import 'package:json_rest_server/src/commands/version_command.dart';

void main(List<String> arguments) {
  CommandRunner(
      'json_rest_server', 'Json Rest Server is a RESTful server based on JSON')
    ..addCommand(VersionCommand())
    ..run(arguments);
}
