import 'dart:core';

class CorsHelper {
  static CorsHelper? _instance;

  final List<String> _origins = [];
  final List<String> _methods = [];
  final List<String> _headers = [];
  // Avoid self instance

  CorsHelper load(
      {List<String>? allowOrigins,
      List<String>? allowMethods,
      List<String>? allowHeaders}) {
    _instance ??= CorsHelper();
    _instance?._origins.addAll(allowOrigins ?? []);
    _instance?._methods.addAll(allowMethods ?? []);
    _instance?._headers.addAll(allowHeaders ?? []);

    return _instance!;
  }

  void addAllowOrigins(List<String> origin) {
    _origins.clear();
    _origins.addAll(origin);
  }

  String get _getOrigins {
    if (_origins.isEmpty) {
      return '*';
    } else {
      return _origins.join(',');
    }
  }

  void addAllowMethods(List<String> methods) {
    _methods.clear();
    _methods.addAll(methods);
  }

  String get _getMethods {
    if (_methods.isEmpty) {
      return '*';
    } else {
      return _methods.join(',');
    }
  }

  void addAllowHeaders(List<String> headers) {
    _headers.clear();
    _headers.addAll(headers);
  }

  String get _getHeaders {
    if (_headers.isEmpty) {
      return 'Origin, Content-Type, Authorization';
    } else {
      return _headers.join(',');
    }
  }

  Map<String, String> get jsonReturn => {
        'content-type': 'application/json',
        'Access-Control-Allow-Origin': _getOrigins,
        'Access-Control-Allow-Methods': _getMethods,
        'Access-Control-Allow-Headers': _getHeaders,
      };
}
