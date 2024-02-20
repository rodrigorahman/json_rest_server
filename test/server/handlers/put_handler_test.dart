import 'package:dio/dio.dart';
import 'package:json_rest_server/src/server/json_rest_server.dart';
import 'package:test/test.dart';

import '../mock/env_mock.dart';

void main() {
  group('Put Tests group', () {
    JsonRestServer? server;
    setUpAll(() async {
      server = JsonRestServer(EnvMock());
      await server!.startServer();
    });

    tearDownAll(() => server?.closeServer());

    test('Should update data', () async {
      final Response(data: {'id': testID}, statusCode: insertStatusCode) =
          await Dio().post(
        'http://localhost:8080/tests/',
        data: {"name": "Teste shoud update"},
      );

      expect(insertStatusCode, equals(200));

      final Response(statusCode: updateStatus) = await Dio().put(
        'http://localhost:8080/tests/$testID',
        data: {"name": "Teste shoud updated"},
      );

      expect(updateStatus, equals(200));

      final Response(data: {'name': nameTest}) = await Dio().get(
        'http://localhost:8080/tests/$testID',
      );

      expect(nameTest, equals('Teste shoud updated'));

      await Dio().delete(
        'http://localhost:8080/tests/$testID',
      );
    });

    test('Should error 404', () async {
      try {
        await Dio().put(
          'http://localhost:8080/tests/123',
          data: {"name": "Teste shoud updated"},
        );
      } on DioException catch (e) {
        expect(e.response?.statusCode, equals(404));
      }
    });
  });
}
