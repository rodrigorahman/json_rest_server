import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';

class VersionCommand extends Command<dynamic> {
  @override
  String get description => 'Show json rest server version';

  @override
  String get name => 'version';

  @override
  void run() {
    final result = Process.runSync('dart', ['pub', 'global', 'list']);
    final packages = _parsePackagesVersion(result.stdout.toString());
    final version = packages['json_rest_server'];

    print('');
    print('''
     ██╗███████╗ ██████╗ ███╗   ██╗    ██████╗ ███████╗███████╗████████╗    ███████╗███████╗██████╗ ██╗   ██╗███████╗██████╗
     ██║██╔════╝██╔═══██╗████╗  ██║    ██╔══██╗██╔════╝██╔════╝╚══██╔══╝    ██╔════╝██╔════╝██╔══██╗██║   ██║██╔════╝██╔══██╗
     ██║███████╗██║   ██║██╔██╗ ██║    ██████╔╝█████╗  ███████╗   ██║       ███████╗█████╗  ██████╔╝██║   ██║█████╗  ██████╔╝
██   ██║╚════██║██║   ██║██║╚██╗██║    ██╔══██╗██╔══╝  ╚════██║   ██║       ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██╔══╝  ██╔══██╗
╚█████╔╝███████║╚██████╔╝██║ ╚████║    ██║  ██║███████╗███████║   ██║       ███████║███████╗██║  ██║ ╚████╔╝ ███████╗██║  ██║
 ╚════╝ ╚══════╝ ╚═════╝ ╚═╝  ╚═══╝    ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝       ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝
    ''');
    print('');
    print('Version: $version');
  }

  Map<String, String> _parsePackagesVersion(String output) {
    final lines = LineSplitter.split(output);
    final packages = <String, String>{};

    for (final line in lines) {
      final parts = line.split(' ');
      if (parts.length >= 2) {
        final packageName = parts[0];
        final packageVersion = parts[1];
        packages[packageName] = packageVersion;
      }
    }
    return packages;
  }
}
