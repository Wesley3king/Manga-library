import 'dart:io';

import 'package:flutter/rendering.dart';

/// save images from lists
class SaverFromLists {

  /// saves an image from a list of bytes
  Future<void> saveAnImageFromBytes(List<int> bytes, savePath) async {
    try {
      File file = File(savePath);
      file = await file.create(recursive: true);
      await file.writeAsBytes(bytes, mode: FileMode.writeOnlyAppend, flush: true);
    } catch (e) {
      debugPrint("ImageSaver - ERROR: $e");
      throw Exception(e.toString());
    }
  }
}
