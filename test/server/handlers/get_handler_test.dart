import 'package:dio/dio.dart';
import 'package:json_rest_server/src/server/json_rest_server.dart';
import 'package:test/test.dart';

void main() {
  group('Getter Testss', () {
    setUpAll(() async {
      await JsonRestServer().startServer();
    });

    test('should find user for page 1 and limit 5', () async {
      final response =
          await Dio().get('http://localhost:8080/users?page=1&limit=5');

      final data = response.data as List;

      expect(data.length, equals(5));
    });

    test('should find user pagination without limit', () async {
      // await JsonRestServer().startServer();

      final response = await Dio().get('http://localhost:8080/users?page=1');

      final data = response.data as List;

      expect(data.isNotEmpty, isTrue);
      expect(data.length, greaterThan(1));
      expect(data.length, lessThan(11));
    });
  });
}
