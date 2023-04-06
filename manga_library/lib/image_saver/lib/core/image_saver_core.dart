import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:image_saver/core/downloader.dart';
import 'package:image_saver/core/saver.dart';
import 'package:image_saver/models/download_model.dart';

/// Image Saver is a package to help you save images on your device.
class ImageSaver {
  final ImageSaverDownloadCore _core = ImageSaverDownloadCore();

  ///downloads an image to the device.
  Future<bool> download(ImageSaverDownloadModel model) async {
    String response = await _core.download(model);
    if (response != "Sucess!") {
      debugPrint("ImageSaver - ERROR: $response");
    }
    return response == "Sucess!";
  }

  ///download multiple images to device.
  ///returns a boolean list in which each value represents its respective image, being:
  ///TRUE - download success
  ///FALSE - download error.
  ///
  /// [[======= additional settings =========]]
  ///
  ///`continueDownloadOnFailure`: continues to perform downloads regardless of failures.
  ///
  ///`options`: network options.
  ///
  ///`useTheSameConfigurationOnAllDownloads`: uses the same network options for all downloads.
  Future<List<bool>> multipleImageDownload(List<ImageSaverDownloadModel> models,
      {bool continueDownloadOnFailure = false,
      bool useTheSameConfigurationOnAllDownloads = false,
      Options? options}) async {
    ///
    List<bool> results = [];
    for (int i = 0; i < models.length; ++i) {
      ///saves response on every download
      String response = "";
      ///checks whether to use default network settings
      if (useTheSameConfigurationOnAllDownloads) {
        models[i].options = options;
        response = await _core.download(models[i]);
      } else {
        response = await _core.download(models[i]);
      }

      ///handle the download result.
      if (response != "Sucess!" && !continueDownloadOnFailure) {
        debugPrint("ImageSaver - ERROR: $response");
        results.add(false);
        break;
      } else if (response != "Sucess!") {
        debugPrint("ImageSaver - ERROR: $response");
        results.add(false);
      } else {
        debugPrint("ImageSaver - SUCESS ON DOWNLOAD: ${models[i].urlPath}");
        results.add(true);
      }
    }
    return results;
  }

  /// saves an image from a list of bytes
  Future<void> saveAnImageFromBytes(List<int> bytes, savePath) async {
    await SaverFromLists().saveAnImageFromBytes(bytes, savePath);
  }
}
