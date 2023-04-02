import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:shelf/shelf.dart';
import 'package:shelf_multipart/form_data.dart';

class UploadHandler {
  Future<Map<String, dynamic>?> execute(Request request) async {
    var response = <String, dynamic>{};
    await for (final formData in request.multipartFormData) {
      final fileName = formData.filename;
      print(fileName);
      if (fileName == null) {
        throw Exception();
      }

      final extension = fileName.split('.').last;
      final file = await formData.part.readBytes();
      final finalFileName = _saveFile(file, extension);
      response = {
        'fileName': finalFileName,
        'url': '/storage/$finalFileName'
      };
    }
    return response;
  }

  String _saveFile(Uint8List file, String extension) {
    final random = Random();
    final letters = 'abcdefghijklmnopqrstuvwxyz';
    final nameLength = 8;
    var fileName = '';

    for (var i = 0; i < nameLength; i++) {
      fileName += letters[random.nextInt(letters.length)];
    }
    final date = DateTime.now();

    fileName = '${fileName}_jrs_${date.millisecondsSinceEpoch}.$extension';
    File('storage/$fileName').writeAsBytesSync(file);
    return fileName;
  }
}
