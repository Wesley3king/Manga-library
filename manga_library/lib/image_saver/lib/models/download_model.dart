import 'package:dio/dio.dart';

class ImageSaverDownloadModel {
  ///the url from where the file will be extracted
  late final String urlPath;
  ///the path where the image will be saved
  late final String savePath;
  ///extra network settings
  late final Options? options;
  ImageSaverDownloadModel({required this.urlPath, required this.savePath, this.options});
}
