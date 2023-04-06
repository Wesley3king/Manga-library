import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';

import '../models/download_model.dart';

class ImageSaverDownloadCore {
  final Dio downloader = Dio();

  Future<String> download(ImageSaverDownloadModel model) async {
    try {
      await downloader.download(model.urlPath, model.savePath, options: model.options);
      return "Sucess!";
    } catch (e) {
      debugPrint("ERROR ON DOWNLOAD: $e");
      return e.toString();
    }
  }
}
