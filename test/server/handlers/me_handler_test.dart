import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:json_rest_server/src/server/json_rest_server.dart';
import 'package:test/test.dart';

import '../mock/env_mock.dart';
import '../mock/generate_config.dart';
import '../mock/generate_database.dart';

void main() {
  group('Tests get me', () {
    setUpAll(() {
      GetIt.I.allowReassignment = true;
    });
    test('Shoud me data when id int', () async {
      GenerateConfig.defaultAuthIdInt();
      GenerateDatabase.int();

      final server = JsonRestServer(EnvMock());
      await server.startServer();

      final authToken = await _auth();
      final Response(data: Map(isNotEmpty: hasData)) = await Dio().get(
          'http://localhost:8080/me',
          options: Options(headers: {'Authorization': authToken}));

      expect(hasData, isTrue);
      await server.closeServer();
    });

    test('Shoud me data when id UUID', () async {
      print(DateTime.now().toIso8601String());
      GenerateConfig.defaultAuth();
      GenerateDatabase.uuid();
      final server = JsonRestServer(EnvMock());
      await server.startServer();

      final authToken = await _auth();
      final Response(data: Map(isNotEmpty: hasData)) = await Dio().get(
          'http://localhost:8080/me',
          options: Options(headers: {'Authorization': authToken}));

      expect(hasData, isTrue);
      await server.closeServer();
    });
  });
}

Future<String> _auth() async {
  final Response(
    data: {'access_token': accessToken, 'type': type},
    :statusCode
  ) = await Dio().post(
    'http://localhost:8080/auth',
    data: {
      "email": "at1@gmail.com",
      "password": "123123",
    },
  );
  expect(statusCode, equals(200));
  return '$type $accessToken';
}
