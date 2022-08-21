import 'package:flutter/material.dart';
import 'package:manga_library/app/models/manga_info_model.dart';

import 'extensions/extension_manga_yabu.dart';

class MangaInfoController {
  final mangaYabu = ExtensionMangaYabu();
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
  ValueNotifier state = ValueNotifier<MangaInfoStates>(MangaInfoStates.start);

  Future start(String url) async {
    state.value = MangaInfoStates.loading;
    final ModelMangaInfo? _dados = await mangaYabu.mangaInfo(url);

    if (_dados != null) {
      data = _dados;
      state.value = MangaInfoStates.sucess;
    } else {
      state.value = MangaInfoStates.error;
    }
  }
}

enum MangaInfoStates { start, loading, sucess, error }
