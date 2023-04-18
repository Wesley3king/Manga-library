import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/download/download_controller.dart';
import 'package:manga_library/app/controllers/file_manager.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/models/download_model.dart';
import 'package:manga_library/app/models/downloads_pages_model.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

import '../../../../extensions/extensions.dart';
import '../../../../controllers/off_line/manga_info_off_line.dart';

class OffLineWidgetController {
  ValueNotifier<DownloadStates> state =
      ValueNotifier<DownloadStates>(DownloadStates.download);
  ValueNotifier<Map<String, int?>> downloadProgress =
      ValueNotifier<Map<String, int?>>({});

  void start(Capitulos capitulo,
      {required String link, required int idExtension}) {
    if (capitulo.download) {
      state.value = DownloadStates.delete;
    } else {
      // implement downloading verify
      try {
        bool isDownloading =
            false; // DownloadModel model in filaDownloadFreezed
        for (int i = 0; i < DownloadController.filaDeDownload.length; ++i) {
          final DownloadModel model = DownloadController.filaDeDownload[i];
          final completeLink = mapOfExtensions[model.model.idExtension]!
              .getLink(model.pieceOfLink);
          if (model.capitulo.id == capitulo.id &&
              completeLink == link &&
              model.model.idExtension == idExtension) {
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
      required String link,
      required Capitulos capitulo}) async {
    state.value = DownloadStates.downloading;
    //print("init length: ${capitulo.pages.length}");
    final DownloadModel model = DownloadModel(
        pieceOfLink: link,
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

    // precisa conseguir as paginas primeiro
    List<String> data = [];
    if (capitulo.pages.isEmpty) {
      data = await mapOfExtensions[mangaModel.idExtension]!
          .getPagesForDownload(capitulo.id);
      // editar o model
      model.capitulo.pages = data;
    }
    DownloadController.addDownload(model);

    // encontrar sua extensão DownloadController.addDownload(model);
    // mapOfExtensions[mangaModel.idExtension]!.download(DownloadActions.download,
    // model: model, idExtension: mangaModel.idExtension);
    // state.value = DownloadStates.delete;
  }

  void cancel(Capitulos capitulo, String link) async {
    await DownloadController.cancelDownload(capitulo, link);
    state.value = DownloadStates.download;
  }

  void delete(
      {required MangaInfoOffLineModel mangaModel,
      required Capitulos capitulo}) async {
    final HiveController hiveController = HiveController();
    final MangaInfoOffLineController mangaInfoOffLineController =
        MangaInfoOffLineController();
    // final HiveController _hiveController = HiveController();
    final FileManager fileManager = FileManager();
    try {
      List<DownloadPagesModel> models = await hiveController.getDownloads();

      for (DownloadPagesModel model in models) {
        final completeLink =
            mapOfExtensions[model.idExtension]!.getLink(model.link);
        if (model.id == capitulo.id &&
            completeLink == mangaModel.link &&
            model.idExtension == mangaModel.idExtension) {
          fileManager.deleteDownloads(model.pages[0]);
        }
      }
      models.removeWhere((model) {
        final completeLink =
            mapOfExtensions[model.idExtension]!.getLink(model.link);
        return model.id == capitulo.id &&
            completeLink == mangaModel.link &&
            model.idExtension == mangaModel.idExtension;
      });
      await hiveController.updateDownloads(models);
      DownloadController.mangaInfoController?.updateChaptersAfterDownload(
          mangaModel.link, mangaModel.idExtension);
      state.value = DownloadStates.download;
    } catch (e) {
      debugPrint("erro no delete at OffLineWidgetController: $e");
      state.value = DownloadStates.error;
    }
  }
}

enum DownloadStates { download, downloading, delete, error }
