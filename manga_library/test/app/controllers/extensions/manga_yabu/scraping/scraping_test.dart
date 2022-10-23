import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/controllers/extensions/manga_yabu/extension_yabu.dart';
import 'package:manga_library/app/controllers/extensions/manga_yabu/scraping/scraping_yabu.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

void main() {
  // ExtensionMangaYabu extensionManga = ExtensionMangaYabu();
  ExtensionMangaYabu extensionManga = ExtensionMangaYabu();
  test('aqui deve retornar uma lista de maps com os dados necessarios',
      () async {
    var result = await scrapingHomePage(0);
    debugPrint('$result');
    // expect(result is List, true);
  });

  // manga detail
  test('deve retornar uma instancia do model com os dados do manga', () async {
    MangaInfoOffLineModel? result =
        await extensionManga.mangaDetail('dragon-ball-super');

    debugPrint(result!.name);
  });
}
