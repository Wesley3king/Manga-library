import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/download/download_controller.dart';
// import 'package:manga_library/app/controllers/extensions/model_extension.dart';
import 'package:manga_library/app/controllers/file_manager.dart';
import 'package:manga_library/app/models/download_model.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

// import '../../../../../controllers/hive/hive_controller.dart';
import '../../../../extensions/extensions.dart';
import '../../../../controllers/off_line/manga_info_off_line.dart';

class OffLineWidgetController {
  ValueNotifier<DownloadStates> state =
      ValueNotifier<DownloadStates>(DownloadStates.download);
  ValueNotifier<Map<String, int?>> downloadProgress =
      ValueNotifier<Map<String, int?>>({});

  start(Capitulos capitulo) {
    if (capitulo.download) {
      state.value = DownloadStates.delete;
    } else {
      // implement downloading verify
      // List<DownloadModel> filaDownloadFreezed =
      //     List.unmodifiable(DownloadController.filaDeDownload);
      try {
        bool isDownloading =
            false; // DownloadModel model in filaDownloadFreezed
        for (int i = 0; i < DownloadController.filaDeDownload.length; ++i) {
          final DownloadModel model = DownloadController.filaDeDownload[i];
          if (model.capitulo.id == capitulo.id) {
            state.value = DownloadStates.downloading;
            Map<String, int?> progressData = {
              "total": model.capitulo.pages.length,
              "progress": null
            };
            downloadProgress.value = progressData;
            model.state = state;
            model.valueNotifier = downloadProgress;
            isDownloading = true;
          }
        }

        if (!isDownloading) {
          state.value = DownloadStates.download;
        }
      } catch (e) {
        debugPrint("erro no start at OffLineWidgetController: $e");
        state.value = DownloadStates.error;
      }
    }
  }

  void download(
      {required MangaInfoOffLineModel mangaModel,
      required Capitulos capitulo}) async {
    state.value = DownloadStates.downloading;
    //print("init length: ${capitulo.pages.length}");
    final DownloadModel model = DownloadModel(
        model: mangaModel,
        capitulo: capitulo,
        attempts: 0,
        cancel: false,
        state: state,
        valueNotifier: downloadProgress);
    // int lengthChapter =
    //     model.capitulo.pages.isEmpty ? 0 : (model.capitulo.pages.length - 1);
    Map<String, int?> progressData = {
      "total": model.capitulo.pages.length,
      "progress": null
    };
    downloadProgress.value = progressData;

    if (!mapOfExtensions[mangaModel.idExtension]!.isTwoRequests) {
      // precisa conseguir as paginas primeiro
      List<String> data = [];
      if (capitulo.pages.isEmpty) {
        data = await mapOfExtensions[mangaModel.idExtension]!.getPagesForDownload(capitulo.id);
        // editar o model
        model.capitulo.pages = data;
      }

      DownloadController.addDownload(model);
    } else {
      DownloadController.addDownload(model);
    }

    // encontrar sua extensão DownloadController.addDownload(model);
    // mapOfExtensions[mangaModel.idExtension]!.download(DownloadActions.download,
    // model: model, idExtension: mangaModel.idExtension);
    // state.value = DownloadStates.delete;
  }

  void cancel(Capitulos capitulo, int idExtension) async {
    // await mapOfExtensions[idExtension]!.download(DownloadActions.cancel,
    // chapter: capitulo, idExtension: idExtension);
    await DownloadController.cancelDownload(capitulo, idExtension);
    state.value = DownloadStates.download;
    // DownloadController.cancelDownload(capitulo);
  }

  void delete(
      {required MangaInfoOffLineModel mangaModel,
      required Capitulos capitulo}) async {
    final MangaInfoOffLineController mangaInfoOffLineController =
        MangaInfoOffLineController();
    // final HiveController _hiveController = HiveController();
    final FileManager fileManager = FileManager();

    MangaInfoOffLineModel? atualBook = await mangaInfoOffLineController
        .verifyDatabase(mangaModel.link, mangaModel.idExtension);
    if (atualBook == null) {
      state.value = DownloadStates.error;
    } else {
      // aqui fazemos as alterações
      for (Capitulos chapter in atualBook.capitulos) {
        if (chapter.id == capitulo.id) {
          bool deleteCap =
              await fileManager.deleteDownloads(chapter.downloadPages[0]);
          if (deleteCap) {
            chapter.downloadPages = [];
            chapter.download = false;
            bool saveResult = await mangaInfoOffLineController.updateBook(
                model: atualBook, capitulos: atualBook.capitulos);
            debugPrint("deletado da memória! : $saveResult");
            if (saveResult == false) {
              state.value = DownloadStates.error;
            } else {
              DownloadController.mangaInfoController?.updateChaptersAfterDownload(atualBook.link, atualBook.idExtension);
              state.value = DownloadStates.download;
            }
            break;
          } else {
            state.value = DownloadStates.error;
          }
        }
      }
    } 
  }
}

enum DownloadStates { download, downloading, delete, error }
