import 'package:dio/dio.dart';
import 'package:json_rest_server/src/server/json_rest_server.dart';
import 'package:test/test.dart';

import '../mock/env_mock.dart';
import '../mock/generate_config.dart';
import '../mock/generate_database.dart';

void main() {
  group('Timeout Tests', () {
    JsonRestServer? server;
    setUpAll(() async {
      GenerateDatabase.uuid();
      GenerateConfig.basic();
      server = JsonRestServer(EnvMock());
      await server!.startServer();
    });

    tearDownAll(() => server?.closeServer());
    test('sould validate the timeout exception ', () async {
      try {
        await Dio(BaseOptions(receiveTimeout: Duration(seconds: 3))).get(
            'http://localhost:8080/users',
            options: Options(headers: {'mock-delay': 10}));
      } on DioException catch (e) {
        expect(e.type, DioExceptionType.receiveTimeout);
      }
    });
  });
}
