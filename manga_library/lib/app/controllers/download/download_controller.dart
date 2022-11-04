import 'dart:developer';

// import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:manga_library/app/extensions/extensions.dart';
import 'package:manga_library/app/controllers/file_manager.dart';
// import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/controllers/off_line/manga_info_off_line.dart';
import 'package:manga_library/app/models/download_model.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

import '../../views/manga_info/off_line/controller/off_line_widget_controller.dart';
import '../manga_info_controller.dart';

class DownloadController {
  static List<DownloadModel> filaDeDownload = [];
  static MangaInfoController? mangaInfoController;
  static bool isDownloading = false;

  static addDownload(DownloadModel model) {
    filaDeDownload.add(model);
    // caso o gerenciador de downloads não estiver ligado
    if (!isDownloading) downloadMachine();
  }

  static cancelDownload(Capitulos capitulo, int idExtension) {
    try {
      for (int i = 0; i < filaDeDownload.length; ++i) {
        if (filaDeDownload[i].capitulo.id == capitulo.id) {
          filaDeDownload[i].cancel = true;
        }
      }
    } catch (e) {
      debugPrint("erro no cancelDownload at DownloadController: $e");
      cancelDownload(capitulo, idExtension);
    }
  }

  static deleteDownloadForCancel(String path) async {
    FileManager fileManager = FileManager();
    debugPrint("path - deleteDownload at DownloadController: $path");
    await fileManager.deleteDownloads(path);
  }

  // este gerencia todos os downloads
  static Future<void> downloadMachine() async {
    isDownloading = true;
    final DownloadController downloadController = DownloadController();

    try {
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
        );
        if (result) {
          indexToRemove.add(i);
          model.state?.value = DownloadStates.delete;
        } else {
          ++model.attempts;
          // debugPrint("erro attempts: ${model.attempts}");
          if (model.attempts >= 3) {
            if (model.attempts == 4) {
              model.state?.value = DownloadStates.download;
            } else {
              model.state?.value = DownloadStates.error;
            }
            //model.state?.value = DownloadStates.error;
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
      MangaInfoOffLineModel? atualBook = await mangaInfoOffLineController
          .verifyDatabase(model.link, model.idExtension);
      if (atualBook == null) return false;
      // start the download
      List<String>? downloadedPagesPath = await download(
        capitulo: capitulo,
        link: model.link,
        name: model.name,
        idExtension: model.idExtension,
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
          if (saveResult == false) {
            deleteDownloadForCancel(downloadedPagesPath[0]);
            return false;
          } else {
            log("atualizando a view: ${mangaInfoController == null ? "is null" : "is not Null"}");
            mangaInfoController?.updateChaptersAfterDownload(
                atualBook.link, atualBook.idExtension);
          }
          break;
        }
      }
      log("capitulo ${capitulo.capitulo} baixado com sucesso!!!");
      return true;
    } catch (e) {
      debugPrint("erro no processOneChapter at DownloadController: $e");
      return false;
    }
  }

  Future<List<String>?> download({
    required Capitulos capitulo,
    required String link,
    required String name,
    required int idExtension,
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
        // build exe
        List<String> exe = capitulo.pages[i].split(".");
        exe = exe.reversed.toList(); // file type na posição 0

        // get extesion name
        String extensionaName = mapOfExtensions[idExtension]!.nome;

        // cancel download
        if (filaDeDownload[index].cancel) {
          log("Cancelando o download!!!");
          filaDeDownload[index].attempts = 3;
          if (pagesPath.isEmpty) {
            await deleteDownloadForCancel(
                "/storage/emulated/0/Android/data/com.example.manga_library/files/Manga Library/Downloads/$extensionaName/$chapterPath/$i.${exe[0]}");
          } else {
            if (pagesPath[0].contains("error:")) {
              await deleteDownloadForCancel(
                  "/storage/emulated/0/Android/data/com.example.manga_library/files/Manga Library/Downloads/$extensionaName/$chapterPath/$i.${exe[0]}");
            } else {
              await deleteDownloadForCancel(pagesPath[0]);
            }
          }
          return null;
        }

        String imagePath = "";
        var imageId = await ImageDownloader.downloadImage(capitulo.pages[i],
                destination:
                    AndroidDestinationType.custom(directory: "Manga Library")
                      ..inExternalFilesDir()
                      ..subDirectory("Downloads/$extensionaName/$chapterPath/$i.${exe[0]}"))
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
