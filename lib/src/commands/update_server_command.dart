import 'dart:io';

import 'package:args/command_runner.dart';

class UpdateServerCommand extends Command {
  @override
  String get description => 'Update server';

  @override
  String get name => 'upgrade';

  @override
  void run() {
    Process.run('dart', ['pub', 'global', 'activate', 'json_rest_server'],
        runInShell: true);
    print('Json Rest Server Upgrated!');
  }
}
