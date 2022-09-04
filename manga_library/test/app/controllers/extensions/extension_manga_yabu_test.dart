import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/controllers/extensions/extension_manga_yabu.dart';
import 'package:manga_library/app/models/manga_info_model.dart';
import 'package:manga_library/app/models/search_model.dart';

void main() {
  ExtensionMangaYabu extensionManga = ExtensionMangaYabu();
  test('aqui deve retornar uma lista de maps com os dados necessarios',
      () async {
    var result = await extensionManga.homePage();

    log(result[result.length - 1]);
    expect(result is List, true);
  });

  test('deve retornar uma instancia do model com os dados do manga', () async {
    ModelMangaInfo? result =
        await extensionManga.mangaInfo('dragon-ball-super');

    log(result!.allposts[1].num);
    //expect(result is ModelMangaInfo, true);
  });

  test('deve retornar um SearchModel', () async {
    SearchModel data = await extensionManga.search('one');
    print(data.books[0].name);
  });

  // ExtensionMangaYabu Adimin
  final ExtensionMangaYabuAdimin mangaYabuAdimin = ExtensionMangaYabuAdimin();
  test('deve retornar um SearchModel com os mangas ainda indisponiveis',
      () async {
    var data = await mangaYabuAdimin.search("tail");
    print(data);
    expect(data.books.isNotEmpty, true);
  });
}
