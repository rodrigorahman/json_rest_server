import 'package:json_rest_server/src/server/core/env.dart';
import 'package:path/path.dart' as path;

class EnvMock extends Env {
  @override
  String get debugPath {
    return '${path.join(path.current, 'test', 'server', 'server_config')}${path.separator}';
  }
}
