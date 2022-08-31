import 'dart:io';

import 'package:args/command_runner.dart';

class UpdateServerCommand extends Command {
  @override
  String get description => 'Update server';

  @override
  String get name => 'upgrade';

  @override
  void run() {
    final updateProcess = Process.runSync('dart', ['pub', 'global', 'activate', 'json_rest_server'],
        runInShell: true);
    
    stdout.write(updateProcess.stdout);
    print('Json Rest Server Upgrated!');
  }
}
