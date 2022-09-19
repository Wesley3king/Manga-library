import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/download/download_controller.dart';
import 'package:manga_library/app/models/download_model.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

class OffLineWidgetController {
  ValueNotifier<DownloadStates> state =
      ValueNotifier<DownloadStates>(DownloadStates.download);
  ValueNotifier<Map<String, int?>> downloadProgress =
      ValueNotifier<Map<String, int?>>({});

  // start() async {}

  void download(
      {required MangaInfoOffLineModel mangaModel,
      required Capitulos capitulo}) async {
    state.value = DownloadStates.downloading;
    final DownloadModel model = DownloadModel(
        model: mangaModel, capitulo: capitulo, valueNotifier: downloadProgress);
    Map<String, int?> progressData = {
      "total": model.capitulo.pages.length,
      "progress": null
    };
    downloadProgress.value = progressData;
    DownloadController.addDownload(model);
    state.value = DownloadStates.delete;
  }

  void cancel(Capitulos capitulo) async {
    DownloadController.cancelDownload(capitulo);
    state.value = DownloadStates.download;
  }

  void delete(
      {required MangaInfoOffLineModel mangaModel,
      required Capitulos capitulo}) async {
    final DownloadModel model =
        DownloadModel(model: mangaModel, capitulo: capitulo);
    state.value = DownloadStates.download;
  }
}

enum DownloadStates { download, downloading, delete }
