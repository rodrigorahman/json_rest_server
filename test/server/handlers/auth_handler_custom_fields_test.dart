import 'package:dio/dio.dart';
import 'package:json_rest_server/src/server/json_rest_server.dart';
import 'package:test/test.dart';

import '../mock/env_mock.dart';
import '../mock/generate_config.dart';
import '../mock/generate_database.dart';

void main() {
  group('Custom Fields Auth Handler Test', () {
    JsonRestServer? server;
    setUpAll(() async {
      print('start server');
      GenerateDatabase.uuid();
      GenerateConfig.customFieldsAuth();
      server = JsonRestServer(EnvMock());
      await server!.startServer();
    });

    tearDownAll(() => server?.closeServer());

    test('Should login success', () async {
      final Response(
        data: {
          'access_token': accessToken,
          'refresh_token': refreshToken,
          'type': type
        },
        statusCode: insertStatusCode
      ) = await Dio().post(
        'http://localhost:8080/auth',
        data: {
          'document': '123.123.123-12',
          'cellphone': 11999999999,
        },
      );

      expect(insertStatusCode, equals(200));
      expect(accessToken, isNotEmpty);
      expect(refreshToken, isNotEmpty);
      expect(type, equals('Bearer'));
    });

    test('Should erro user not found', () async {
      authFunc() async {
        await Dio().post(
          'http://localhost:8080/auth',
          data: {
            'document': '123.123.123-12',
            'cellphone': 11,
          },
        );
      }

      await expectLater(
        () => authFunc(),
        throwsA(
          isA<DioException>().having(
            (ex) {
              return ex.response?.statusCode;
            },
            'Status Error',
            equals(403),
          ),
        ),
      );
    });
  });
}
