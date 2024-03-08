import 'dart:io';

import 'package:path/path.dart' as path;

class GenerateDatabase {
  static final String _basePath =
      path.joinAll([path.current, 'test', 'server']);

  static void uuid() => _generateConfig('database_uuid.json');
  static void int() => _generateConfig('database_int.json');


  static void _generateConfig(String mockFile) {
    final jsonConfig = File(path.joinAll([_basePath, 'mock', mockFile]));
    final finalFile =
        File(path.joinAll([_basePath, 'server_config', 'database.json']));

    finalFile.writeAsStringSync(jsonConfig.readAsStringSync());
  }
}
