import 'dart:developer';

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/extensions/manga_yabu/extension_yabu.dart';
// import 'package:manga_library/app/controllers/extensions/extension_manga_yabu.dart';
// import 'package:manga_library/app/models/manga_info_model.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';
import 'package:manga_library/app/models/search_model.dart';

void main() {
  ExtensionMangaYabu extensionManga = ExtensionMangaYabu();
  test('aqui deve retornar uma lista de maps com os dados necessarios',
      () async {
    var result = await extensionManga.homePage();
    debugPrint('$result');
    // expect(result is List, true);
  });

  test('deve retornar uma instancia do model com os dados do manga', () async {
    MangaInfoOffLineModel? result =
        await extensionManga.mangaDetail('dragon-ball-super');
    // wind-breaker dragon-ball-super

    log('${result?.name}');
    expect(result != null, true);
  });

  test("deve retornar um model Capitulos", () async {
    var data =
        await extensionManga.getPages("wind-breaker-capitulo-397-my944597", [
      Capitulos(
          id: 'wind-breaker-capitulo-397-my944597',
          capitulo: '397',
          description: '',
          download: false,
          readed: false,
          mark: false,
          downloadPages: [],
          pages: [])
    ]);
    debugPrint("data: $data");
  });
  test('deve retornar um SearchModel', () async {
    SearchModel data = await extensionManga.search('one piece');
    debugPrint(data.books[0].name);
  });
}
