import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/controllers/extensions/extension_manga_yabu.dart';
import 'package:manga_library/app/models/manga_info_model.dart';

void main() {
  ExtensionMangaYabu extensionManga = ExtensionMangaYabu();
  test('aqui deve retornar uma lista de maps com os dados necessarios',
      () async {
    var result = await extensionManga.homePage();

    log(result[result.length - 1]);
    expect(result is List, true);
  });

  test('deve retornar uma instancia do model com os dados do manga', () async {
    ModelMangaInfo? result = await extensionManga.mangaInfo('dragon-ball-super');

    log(result!.allposts[1].num);
    //expect(result is ModelMangaInfo, true);
  });
}
