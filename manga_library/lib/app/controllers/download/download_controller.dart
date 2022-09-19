import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/controllers/off_line/manga_info_off_line.dart';
import 'package:manga_library/app/models/download_model.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

class DownloadController {
  // final HiveController _hiveController = HiveController();
  static List<DownloadModel> filaDeDownload = [];
  static bool isDownloading = false;

  static addDownload(DownloadModel model) {
    filaDeDownload.add(model);
    // caso o gerenciador de downloads não estiver ligado
    if (!isDownloading) downloadMachine();
  }

  static cancelDownload(Capitulos capitulos) {
    filaDeDownload.removeWhere(
        (DownloadModel model) => model.capitulo.id == capitulos.id);
  }

  static deleteDownload(Capitulos capitulos) async {
    // implement this
  }
  // este gerencia todos os downloads
  static Future<void> downloadMachine() async {
    isDownloading = true;
    final DownloadController downloadController = DownloadController();

    try {
      for (DownloadModel model in filaDeDownload) {
        await downloadController.processOneChapter(
            capitulo: model.capitulo,
            model: model.model,
            downloadProgress: model.valueNotifier);
      }
      // caso ainda tenha downloads
      if (filaDeDownload.isNotEmpty) downloadMachine();
      isDownloading = false;
    } catch (e) {
      print("erro fatal no downloadMachine at DownloadController: $e");
      isDownloading = false;
    }
  }

  Future<bool> processOneChapter(
      {required Capitulos capitulo,
      // required String link,
      // required String name
      required MangaInfoOffLineModel model,
      ValueNotifier<Map<String, int?>>? downloadProgress}) async {
    final MangaInfoOffLineController _mangaInfoOffLineController =
        MangaInfoOffLineController();
    // ValueNotifier<Map<String, int>> downloadProgress =
    //     ValueNotifier<Map<String, int?>>(
    //         {"total": capitulo.pages.length, "progress": 0});
    try {
      List<String> downloadedPagesPath = await download(
        capitulo: capitulo,
        link: model.link,
        name: model.name,
        downloadProgress: downloadProgress,
      );
      for (Capitulos chapter in model.capitulos) {
        if (chapter.id == capitulo.id) {
          chapter.downloadPages = downloadedPagesPath;
          chapter.download = true;
          bool saveResult = await _mangaInfoOffLineController.updateBook(
              model: model, capitulos: model.capitulos);
          print("salvo na memória! : $saveResult");
          break;
        }
      }
      log("caṕitulo baixado com sucesso!!!");
      return true;
    } catch (e) {
      print("erro no processOneChapter at DownloadController: $e");
      return false;
    }
  }

  Future<List<String>> download(
      {required Capitulos capitulo,
      required String link,
      required String name,
      ValueNotifier<Map<String, int?>>? downloadProgress}) async {
    try {
      // constroi o sub caminho das paginas baixadas
      List<RegExp> listOfRegExp = [
        RegExp(r" ", caseSensitive: false, dotAll: true),
        RegExp(r'/', caseSensitive: false, dotAll: true),
        // RegExp(r'\[', caseSensitive: false, dotAll: true),
        // RegExp(r'\[', caseSensitive: false, dotAll: true),
        RegExp(r'~', caseSensitive: false, dotAll: true),
      ];
      final String chapterPath = "$name/${capitulo.capitulo}";
      for (RegExp regex in listOfRegExp) {
        chapterPath.replaceAll(regex, "_");
      }

      // caminhos das paginas
      List<String> pagesPath = [];
      // indica a quantidade de downloads a ser executado.

      // inicia os downloads de capitulo
      for (int i = 0; i < capitulo.pages.length; ++i) {
        String imagePath = "";
        List<String> exe = capitulo.pages[i].split(".");
        var imageId = await ImageDownloader.downloadImage(capitulo.pages[i],
                destination: AndroidDestinationType.directoryPictures
                  ..inExternalFilesDir()
                  ..subDirectory("$chapterPath/$i.${exe[1]}"))
            .catchError((error) {
          if (error is PlatformException) {
            if (error.code == "404") {
              print("Not Found Error.");
              imagePath = "error: 404 Not Found Error.";
            } else if (error.code == "unsupported_file") {
              print("UnSupported FIle Error.");
              imagePath = "error: UnSupported FIle Error";
            }
          }
        });
        if (imageId == null) return [];

        imagePath = await ImageDownloader.findPath(imageId) ?? imagePath;
        print(imagePath);
        pagesPath.add(imagePath);
        Map<String, int?> progressData = {
          "total": capitulo.pages.length,
          "progress": i
        };
        downloadProgress?.value = progressData;
      }

      return pagesPath;
    } catch (e) {
      print("erro fatal no download!: $e");
      return [];
    }
  }
}
