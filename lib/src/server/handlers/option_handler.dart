import 'package:get_it/get_it.dart';
import 'package:json_rest_server/src/core/helper/cors_helper.dart';
import 'package:shelf/shelf.dart';

class OptionHandler {
  Future<Response> execute(Request request) async {
    final _jsonHelper = GetIt.I.get<CorsHelper>();

    return Response(200, headers: _jsonHelper.jsonReturn);
  }
}
