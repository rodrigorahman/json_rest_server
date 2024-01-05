import 'dart:io';

import 'package:args/command_runner.dart';

class UpdateServerCommand extends Command {
  @override
  String get description => 'Update server';

  @override
  String get name => 'upgrade';

  @override
  void run() {
    final ProcessResult(:stdout) = Process.runSync(
        'dart', ['pub', 'global', 'activate', 'json_rest_server'],
        runInShell: true);

    stdout.write(stdout);
    print('Json Rest Server Upgrated!');
  }
}
