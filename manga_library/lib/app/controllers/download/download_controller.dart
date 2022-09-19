import 'dart:developer';

import 'package:image_downloader/image_downloader.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

class DownloadController {
  final HiveController _hiveController = HiveController();
  List filaDeDownload = [];

  Future<bool> processOneChapter(
      {required Capitulos capitulo,
      required String link,
      required String name}) async {
    try {
      List<String> downloadedPagesPath =
          await download(capitulo: capitulo, link: link, name: name);

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
      required String name}) async {
    try {
      // constroi o sub caminho das paginas baixadas
      List<RegExp> listOfRegExp = [
        RegExp(" ", caseSensitive: false, dotAll: true),
        RegExp('/', caseSensitive: false, dotAll: true),
        // RegExp(r'()', caseSensitive: false, dotAll: true),
      ];
      final String chapterPath = name;
      listOfRegExp.forEach((RegExp regex) {
        chapterPath.replaceAll(regex, "_");
      });

      // caminhos das paginas
      List<String> pagesPath = [];
      // inicia os downloads de capitulo
      for (String page in capitulo.pages) {
        await ImageDownloader.downloadImage(page,
            destination: AndroidDestinationType.directoryPictures
              ..subDirectory(""));
      }

      return pagesPath;
    } catch (e) {
      print("erro fatal no download!: $e");
      return [];
    }
  }
}
