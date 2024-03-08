import 'dart:convert';
import 'dart:io';

import 'package:json_rest_server/src/server/core/env.dart';
import 'package:path/path.dart' as path;
import 'package:yaml_writer/yaml_writer.dart';

class EnvMock extends Env {
  @override
  String get debugPath {
    return '${path.join(path.current, 'test', 'server', 'server_config')}${path.separator}';
  }
}

class EnvMockAuth extends Env {
  EnvMockAuth._();

  factory EnvMockAuth.defaultAuth() {
    // Substituir o arquivo pelo template do config_defaults.yaml
    final basePath = path.joinAll([path.current, 'test', 'server', 'mock']);
    
    final jsonConfig =
        File(path.joinAll([basePath, 'auth_default_config.json']));
    var yamlWriter = YamlWriter(allowUnquotedStrings:true);
    var yamlDoc = yamlWriter.write(jsonDecode(jsonConfig.readAsStringSync()));
    print(yamlDoc);
    final finalFile = File(path.joinAll([basePath, 'config.yaml']));
    finalFile.writeAsStringSync(yamlDoc);
    return EnvMockAuth._();
  }

  factory EnvMockAuth.customFieldsAuth() {
    // Substituir o arquivo pelo template do config_auth_fields.yaml
    final basePath =
        path.joinAll([path.current, 'test', 'server', 'server_config_auth']);
    final fileBase = File(path.joinAll([basePath, 'config_auth_fields.yaml']));
    final finalFile = File(path.joinAll([basePath, 'config.yaml']));
    finalFile.writeAsStringSync(fileBase.readAsStringSync());
    return EnvMockAuth._();
  }

  @override
  String get debugPath {
    return '${path.join(path.current, 'test', 'server', 'server_config_auth')}${path.separator}';
  }
}
