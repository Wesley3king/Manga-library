import 'package:flutter/material.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

import '../views/manga_info/off_line/controller/off_line_widget_controller.dart';

class DownloadModel {
  late final String pieceOfLink;
  late final MangaInfoOffLineModel model;
  late final Capitulos capitulo;
  late int attempts;
  late bool cancel;
  late ValueNotifier<DownloadStates>? state;
  late ValueNotifier<Map<String, int?>>? valueNotifier;

  DownloadModel({
    required this.pieceOfLink,
    required this.model,
    required this.capitulo,
    required this.attempts,
    required this.cancel,
    this.state,
    this.valueNotifier
  });
}
