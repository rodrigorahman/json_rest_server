import 'package:args/command_runner.dart';
import 'package:json_rest_server/src/commands/create_project_command.dart';
import 'package:json_rest_server/src/commands/run_command.dart';
import 'package:json_rest_server/src/commands/update_server_command.dart';
import 'package:json_rest_server/src/commands/version_command.dart';

void main(List<String> arguments) {
  CommandRunner(
      'json_rest_server', 'Json Rest Server is a RESTful server based on JSON')
    ..addCommand(VersionCommand())
    ..addCommand(CreateProjectCommand())
    ..addCommand(RunCommand())
    ..addCommand(UpdateServerCommand())
    ..run(arguments);
}
