import 'package:flutter/material.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

class DownloadModel {
  late final MangaInfoOffLineModel model;
  late final Capitulos capitulo;
  late ValueNotifier<Map<String, int?>>? valueNotifier;

  DownloadModel({required this.model, required this.capitulo, this.valueNotifier});
}
