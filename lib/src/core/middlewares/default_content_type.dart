import 'package:shelf/shelf.dart';

import 'middlewares.dart';

class DefaultContentType extends Middlewares {
  final String contentType;

  DefaultContentType(this.contentType);

  @override
  Future<Response> execute(Request request) async {
    final response = await innerHandler(request);
    final headers = {...response.headers};
    if(headers.containsKey('keepContentType')){
      headers.remove('keepContentType');
      return response.change(headers: headers);
    }
    return response.change(headers: {'content-type': contentType});
  }
}
