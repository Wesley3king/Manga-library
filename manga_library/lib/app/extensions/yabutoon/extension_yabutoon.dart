import 'package:flutter/foundation.dart';
import 'package:manga_library/app/extensions/model_extension.dart';
import 'package:manga_library/app/extensions/yabutoon/repositories/extension_yabutoon_repositories.dart';
import 'package:manga_library/app/extensions/yabutoon/scraping/extension_yabutoon_scraping.dart';

import '../../models/home_page_model.dart';
import '../../models/libraries_model.dart';
import '../../models/manga_info_offline_model.dart';

class ExtensionYabutoon implements Extension {
  @override
  dynamic fetchServices = YabutoonRepositories();
  @override
  String nome = "YabuToons";
  @override
  String extensionPoster = "YabuToons.png";
  @override
  int id = 12;
  @override
  bool nsfw = false;

  @override
  Future<List<ModelHomePage>> homePage() async {
    return await compute(scrapingHomePage, 0);
  }

  @override
  Future<MangaInfoOffLineModel?> mangaDetail(String link) async {
    return await compute(scrapingMangaDetail, link);
  }

  @override
  String getLink(String pieceOfLink) => 'https://yabutoons.com/webtoon/$pieceOfLink/';

  @override
  Future<Capitulos> getPages(String id, List<Capitulos> listChapters) async {
    Capitulos result = Capitulos(
        capitulo: "error",
        id: "error",
        mark: false,
        description: '',
        download: false,
        downloadPages: [],
        pages: [],
        readed: false);
    for (int i = 0; i < listChapters.length; ++i) {
      if (listChapters[i].id == id) {
        result = listChapters[i];
        break;
      }
    }
    if (!result.download) {
      try {
        result.pages = await compute(scrapingLeitor, id);
      } catch (e) {
        debugPrint("erro - não foi possivel obter as paginas on-line: $e");
      }
    }
    return result;
  }

  @override
  Future<List<String>> getPagesForDownload(String url) async {
    return await compute(scrapingLeitor, url);
  }

  @override
  Future<List<Books>> search(String txt) async {
    try {
      debugPrint("YABUTOONS SEARCH STARTING...");
      StringBuffer buffer = StringBuffer();
      List<String> cortes = txt.split(" ");

      for (int i = 0; i < cortes.length; ++i) {
        final String str = cortes[i];
        if (i == (cortes.length - 1)) {
          buffer.write(str);
        } else {
          buffer.write('$str+');
        }
      }

      List<Map> books = await compute(fetchServices.search, buffer.toString());

      return books.map<Books>((json) => Books.fromJson(json)).toList();
    } catch (e) {
      debugPrint("erro no search at ExtensionUnionMangas: $e");
      return [];
    }
  }
}
