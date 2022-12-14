import 'dart:developer';

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:manga_library/app/controllers/message_core.dart';
import 'package:manga_library/app/extensions/extensions.dart';
import 'package:manga_library/app/controllers/file_manager.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/models/download_model.dart';
import 'package:manga_library/app/models/downloads_pages_model.dart';
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
      List<Map<String, dynamic>> dataToRemove = [];
      final List<DownloadModel> filaModificable =
          List<DownloadModel>.from(filaDeDownload);
      // laço
      for (int i = 0; i < filaModificable.length; ++i) {
        final DownloadModel model = filaModificable[i];
        debugPrint("attemps: ${model.attempts}");
        bool result = await downloadController.processOneChapter(
          capitulo: model.capitulo,
          pieceOfLink: model.pieceOfLink,
          index: i,
          model: model.model,
        );
        if (result) {
          dataToRemove.add({
            "idExtension": model.model.idExtension,
            "link": model.model.link,
            "idChapter": model.capitulo.id
          });
          model.state?.value = DownloadStates.delete;
        } else {
          ++model.attempts;
          // debugPrint("erro attempts: ${model.attempts}");
          if (model.attempts >= 3) {
            MessageCore.showMessage("Download Error: +3 Tentativas com falhas");
            if (model.attempts == 4) {
              model.state?.value = DownloadStates.download;
            } else {
              model.state?.value = DownloadStates.error;
            }
            //model.state?.value = DownloadStates.error;
            // filaDeDownload.removeWhere((DownloadModel downloadModel) =>
            //     downloadModel.capitulo.id == model.capitulo.id);
            dataToRemove.add({
              "idExtension": model.model.idExtension,
              "link": model.model.link,
              "idChapter": model.capitulo.id
            });
          }
        }
      }
      // caso ainda tenha downloads
      // filaDeDownload = filaDeDownloadUnmodifiable;
      /// ========== [ método em Teste ] =====================
      for (Map<String, dynamic> removeData in dataToRemove) {
        // filaDeDownload.removeAt(index);
        filaDeDownload.removeWhere((DownloadModel downloadModel) =>
            downloadModel.capitulo.id == removeData["idChapter"] &&
            downloadModel.model.idExtension == removeData["idExtension"] &&
            downloadModel.model.link == removeData["link"]);
        //model.state?.value = DownloadStates.delete;
      }
      if (filaDeDownload.isNotEmpty) downloadMachine();
      isDownloading = false;
    } catch (e) {
      debugPrint("erro fatal no downloadMachine at DownloadController: $e");
      isDownloading = false;
    }
  }

  Future<bool> processOneChapter({
    required Capitulos capitulo,
    required String pieceOfLink,
    required MangaInfoOffLineModel model,
    required int index,
  }) async {
    final HiveController hiveController = HiveController();
    try {
      log("processOneChapter - DOWNLOAD - pages= ${capitulo.pages.length}");

      /// verifica se este capítulo é de uma novel
      if (capitulo.pages[0].contains("== NOVEL READER ==")) {
        return await downloadNovel(
            capitulo: capitulo,
            link: model.link,
            pieceOfLink: pieceOfLink,
            name: model.name,
            img: model.img,
            idExtension: model.idExtension,
            index: index,
            hiveController: hiveController);
      }

      /// pega todos os downloads
      List<DownloadPagesModel> downloadModels =
          await hiveController.getDownloads();
      // if (atualBook == null) return false;
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

      /// adiciona o download a memória
      downloadModels.add(DownloadPagesModel(
          id: capitulo.id,
          chapter: capitulo.capitulo,
          idExtension: model.idExtension,
          link: pieceOfLink,
          img: model.img,
          name: model.name,
          pages: downloadedPagesPath));

      /// save in database
      bool isSaved = await hiveController.updateDownloads(downloadModels);
      if (!isSaved) {
        deleteDownloadForCancel(downloadedPagesPath[0]);
        return false;
      } else {
        mangaInfoController?.updateChaptersAfterDownload(
            model.link, model.idExtension);
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
      List<Pattern> listOfRegExp = [
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
            ///[ deve-se modicar ao buildar com outro id ] com.king.manga_library com.example.manga_library
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
                destination: AndroidDestinationType.custom(
                    directory: "Manga Library")
                  ..inExternalFilesDir()
                  ..subDirectory(
                      "Downloads/$extensionaName/$chapterPath/$i.${exe[0]}"))
            .catchError((error) {
          if (error is PlatformException) {
            if (error.code == "404") {
              debugPrint("Not Found Error.");
              imagePath = "error: 404 Not Found Error.";
            } else if (error.code == "unsupported_file") {
              debugPrint("UnSupported FIle Error.");
              imagePath = "error: UnSupported FIle Error";
            }
          }
        });
        if (imageId == null) {
          log("SEM PERMISSÃO!");
          MessageCore.showMessage("Download Error: SEM PERMISSÃO");
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
      debugPrint("erro fatal no download!: $e");
      return null;
    }
  }

  /// baixa uma novel
  Future<bool> downloadNovel(
      {required Capitulos capitulo,
      required String link,
      required String pieceOfLink,
      required String img,
      required String name,
      required int idExtension,
      required int index,
      required HiveController hiveController}) async {
    /// pega todos os downloads
    List<DownloadPagesModel> downloadModels =
        await hiveController.getDownloads();

    /// adiciona o download a memória
    downloadModels.add(DownloadPagesModel(
        id: capitulo.id,
        chapter: capitulo.capitulo,
        idExtension: idExtension,
        link: pieceOfLink,
        img: img,
        name: name,
        pages: capitulo.pages));

    /// save in database
    bool isSaved = await hiveController.updateDownloads(downloadModels);
    if (!isSaved) return false;

    mangaInfoController?.updateChaptersAfterDownload(link, idExtension);
    log("capitulo ${capitulo.capitulo} baixado com sucesso!!!");
    return true;
  }
}
