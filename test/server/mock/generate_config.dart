import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:yaml_writer/yaml_writer.dart';

class GenerateConfig {
  static final String _basePath =
      path.joinAll([path.current, 'test', 'server']);

  static void basic() => _generateConfig('basic_config.json');
  static void defaultAuth() => _generateConfig('auth_default_config.json');
  static void defaultAuthIntId() => _generateConfig('auth_default_id_int_config.json');

  static void customFieldsAuth() =>
      _generateConfig('auth_custom_fields_config.json');


  static void defaultAuthIdInt() =>
      _generateConfig('auth_default_id_int_config.json');



  static void _generateConfig(String mockFile) {
    final jsonConfig = File(path.joinAll([_basePath, 'mock', mockFile]));
    var yamlWriter = YamlWriter(allowUnquotedStrings: true);
    var yamlDoc = yamlWriter.write(jsonDecode(jsonConfig.readAsStringSync()));
    print(yamlDoc);
    final finalFile =
        File(path.joinAll([_basePath, 'server_config', 'config.yaml']));

    finalFile.writeAsStringSync(yamlDoc);
  }
}
