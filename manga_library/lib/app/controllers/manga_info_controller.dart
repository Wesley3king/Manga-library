import 'package:flutter/material.dart';
import 'package:manga_library/app/models/manga_info_model.dart';
import 'package:manga_library/repositories/yabu/yabu_fetch_services.dart';

import '../models/leitor_model.dart';
import 'extensions/extension_manga_yabu.dart';

class MangaInfoController {
  final mangaYabu = ExtensionMangaYabu();
  final YabuFetchServices yabuFetchServices = YabuFetchServices();
  ModelMangaInfo data = ModelMangaInfo(
    chapterName: '',
    chapters: 0,
    description: '',
    cover: '',
    genres: [],
    chapterList: '',
    alternativeName: false,
    allposts: [],
  );
  final List<ModelLeitor> capitulosDisponiveis = [];

  ValueNotifier state = ValueNotifier<MangaInfoStates>(MangaInfoStates.start);

  Future start(String url) async {
    state.value = MangaInfoStates.loading;
    try {
      final ModelMangaInfo? _dados = await mangaYabu.mangaInfo(url);
      if (_dados != null) {
        data = _dados;
        state.value = MangaInfoStates.sucess1;
      } else {
        state.value = MangaInfoStates.error;
      }
      final List<ModelLeitor>? _capitulosDisponiveis =
          await yabuFetchServices.fetchCapitulos(url);
      print(_capitulosDisponiveis);

      if (_capitulosDisponiveis != null &&
          state.value != MangaInfoStates.error) {
        state.value = MangaInfoStates.sucess2;
      } else {
        state.value = MangaInfoStates.error;
      }
    } catch (e) {
      state.value = MangaInfoStates.error;
    }
  }
}

enum MangaInfoStates { start, loading, sucess1, sucess2, error }
