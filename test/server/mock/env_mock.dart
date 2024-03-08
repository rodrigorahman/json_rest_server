import 'dart:io';

import 'package:json_rest_server/src/server/core/env.dart';
import 'package:path/path.dart' as path;

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
    final basePath =
        path.joinAll([path.current, 'test', 'server', 'server_config_auth']);
    final fileBase = File(path.joinAll([basePath, 'config_default.yaml']));
    final finalFile = File(path.joinAll([basePath, 'config.yaml']));
    finalFile.writeAsStringSync(fileBase.readAsStringSync());
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
