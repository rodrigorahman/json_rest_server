import 'package:dio/dio.dart';
import 'package:json_rest_server/src/server/json_rest_server.dart';
import 'package:test/test.dart';

import '../mock/env_mock.dart';
import '../mock/generate_config.dart';
import '../mock/generate_database.dart';

void main() {
  group('Getter Tests', () {
    JsonRestServer? server;
    setUpAll(() async {
      GenerateDatabase.uuid();
      GenerateConfig.basic();
      server = JsonRestServer(EnvMock());
      await server!.startServer();
    });

    tearDownAll(() => server?.closeServer());
    test('should find user for page 1 and limit 5', () async {
      final response =
          await Dio().get('http://localhost:8080/users?page=1&limit=2');

      final data = response.data as List;

      expect(data.length, equals(2));
    });

    test('should find user pagination without limit', () async {
      final response = await Dio().get('http://localhost:8080/users?page=1');

      final data = response.data as List;

      expect(data.isNotEmpty, isTrue);
      expect(data.length, greaterThan(1));
      expect(data.length, lessThan(11));
    });

    test('should find users when sending any character that is not a number',
        () async {
      final response =
          await Dio().get('http://localhost:8080/users?page=A&limit=Q');

      final data = response.data as List;

      expect(data.isNotEmpty, isTrue);
      expect(data.length, greaterThan(1));
      expect(data.length, lessThan(11));
    });
  });
}
