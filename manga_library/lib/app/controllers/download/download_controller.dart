import 'dart:developer';

// import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
// import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/controllers/off_line/manga_info_off_line.dart';
import 'package:manga_library/app/models/download_model.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

import '../../views/components/manga_info/off_line/controller/off_line_widget_controller.dart';

class DownloadController {
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

  // static deleteDownload(Capitulos capitulos) async {
  //   // implement this
  // }

  // este gerencia todos os downloads
  static Future<void> downloadMachine() async {
    isDownloading = true;
    final DownloadController downloadController = DownloadController();

    try {
      // final List<DownloadModel> filaDeDownloadUnmodifiable =
      //     List.unmodifiable(filaDeDownload);

      // esta gurada o indice do download a ser removida da fila
      
      List<int> indexToRemove = [];
      final List<DownloadModel> filaModificable =
          List<DownloadModel>.from(filaDeDownload);
      // laço
      for (int i = 0; i < filaModificable.length; ++i) {
        final DownloadModel model = filaModificable[i];
        debugPrint("attemps: ${model.attempts}");
        bool result = await downloadController.processOneChapter(
          capitulo: model.capitulo,
          index: i,
          model: model.model,
          // state: model.state,
          //downloadProgress: model.valueNotifier
        );
        if (result) {
          // filaDeDownload.removeWhere((DownloadModel downloadModel) =>
          //     downloadModel.capitulo.id == model.capitulo.id);
          indexToRemove.add(i);
          model.state?.value = DownloadStates.delete;
        } else {
          ++model.attempts;
          if (model.attempts >= 3) {
            model.state?.value = DownloadStates.error;
            // filaDeDownload.removeWhere((DownloadModel downloadModel) =>
            //     downloadModel.capitulo.id == model.capitulo.id);
            indexToRemove.add(i);
          }
        }
      }
      // caso ainda tenha downloads
      // filaDeDownload = filaDeDownloadUnmodifiable;
      for (int index in indexToRemove) {
        filaDeDownload.removeAt(index);
        //removeWhere((DownloadModel downloadModel) =>
        //  downloadModel.capitulo.id == model.capitulo.id
        //);
        //model.state?.value = DownloadStates.delete;
      }
      if (filaDeDownload.isNotEmpty) downloadMachine();
      isDownloading = false;
    } catch (e) {
      print("erro fatal no downloadMachine at DownloadController: $e");
      isDownloading = false;
    }
  }

  Future<bool> processOneChapter({
    required Capitulos capitulo,
    required MangaInfoOffLineModel model,
    required int index,
    // ValueNotifier<Map<String, int?>>? downloadProgress
  }) async {
    final MangaInfoOffLineController mangaInfoOffLineController =
        MangaInfoOffLineController();
    // final HiveController _hiveController = HiveController();
    try {
      log("process - pages = ${capitulo.pages.length}");

      /// pega os daddos atuais do banco
      MangaInfoOffLineModel? atualBook =
          await mangaInfoOffLineController.verifyDatabase(model.link);
      if (atualBook == null) return false;
      // start the download
      List<String>? downloadedPagesPath = await download(
        capitulo: capitulo,
        link: model.link,
        name: model.name,
        index: index,
        // downloadProgress: downloadProgress,
      );
      // caso seja null deu um erro!
      if (downloadedPagesPath == null) return false;
      // procura na memória até achar o capitulo
      for (Capitulos chapter in atualBook.capitulos) {
        if (chapter.id == capitulo.id) {
          chapter.downloadPages = downloadedPagesPath;
          chapter.download = true;
          bool saveResult = await mangaInfoOffLineController.updateBook(
              model: atualBook, capitulos: atualBook.capitulos);
          print("salvo na memória! : $saveResult");
          if (saveResult == false) return false;
          break;
        }
      }
      log("capitulo ${capitulo.capitulo} baixado com sucesso!!!");
      return true;
    } catch (e) {
      print("erro no processOneChapter at DownloadController: $e");
      return false;
    }
  }

  Future<List<String>?> download({
    required Capitulos capitulo,
    required String link,
    required String name,
    required int index,
    //ValueNotifier<Map<String, int?>>? downloadProgress
  }) async {
    try {
      // constroi o sub caminho das paginas baixadas
      List<dynamic> listOfRegExp = [
        // RegExp(r"( )", caseSensitive: false, dotAll: true),
        " ",
        RegExp(r'/', caseSensitive: false, dotAll: true),
        // RegExp(r'\[', caseSensitive: false, dotAll: true),
        // RegExp(r'\[', caseSensitive: false, dotAll: true),
        RegExp(r'~', caseSensitive: false, dotAll: true),
      ];
      final String chapterPath = "$name/cap_${capitulo.capitulo}";
      for (dynamic regex in listOfRegExp) {
        chapterPath.replaceAll(regex, "_");
      }

      // caminhos das paginas
      List<String> pagesPath = [];
      // indica a quantidade de downloads a ser executado.

      // inicia os downloads de capitulo
      log("quantidade de paginas : ${capitulo.pages.length}");
      for (int i = 0; i < capitulo.pages.length; ++i) {
        String imagePath = "";
        List<String> exe = capitulo.pages[i].split(".");
        exe = exe.reversed.toList();
        var imageId = await ImageDownloader.downloadImage(capitulo.pages[i],
                destination:
                    AndroidDestinationType.custom(directory: "Manga Libray")
                      ..inExternalFilesDir()
                      ..subDirectory("Downloads/$chapterPath/$i.${exe[0]}"))
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
        if (imageId == null) {
          log("SEM PERMISSÃO!");

          return null;
        }

        imagePath = await ImageDownloader.findPath(imageId) ?? imagePath;
        log(imagePath);
        pagesPath.add(imagePath);
        Map<String, int?> progressData = {
          "total": capitulo.pages.length,
          "progress": i
        };
        filaDeDownload[index].valueNotifier?.value = progressData;
      }

      return pagesPath;
    } catch (e) {
      print("erro fatal no download!: $e");
      return null;
    }
  }
}
