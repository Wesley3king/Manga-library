import 'package:flutter/foundation.dart';
import 'package:manga_library/app/controllers/extensions/hen_season/scraping/scraping_hen_season.dart';
import 'package:manga_library/app/controllers/extensions/model_extension.dart';

import '../../../models/home_page_model.dart';
import '../../../models/manga_info_offline_model.dart';
import '../../../models/search_model.dart';

class ExtensionHenSeason implements Extension {
  @override
  dynamic fetchServices;
  @override
  String nome = "Hentai Season";
  @override
  String extensionPoster = "Hentai-Season.png";
  @override
  int id = 7;
  @override
  bool isTwoRequests = false;
  @override
  bool enable = true;
  @override
  bool nsfw = true;

  @override
  Future<List<ModelHomePage>> homePage() async {
    return await compute(scrapingHomePage, 0);
  }

  @override
  Future<MangaInfoOffLineModel?> mangaDetail(String link) async {
    link = link.replaceAll("_", "/");
    return await compute(scrapingMangaDetail, link);
  }

  @override
  String getLink(String pieceOfLink) {
    pieceOfLink = pieceOfLink.replaceAll("_", "/");
    return "https://hentaiseason.com/$pieceOfLink";
  }

  @override
  Future<Capitulos> getPages(String id, List<Capitulos> listChapters) async {
    return listChapters[0];
  }

  @override
  Future<List<String>> getPagesForDownload(String url) async {
    return [];
  }

  @override
  Future<SearchModel> search(String txt) async {
    try {
      debugPrint("HENT SEASON SEARCH STARTING...");
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

      List<Map> books = await compute(scrapingSearch, buffer.toString());

      return SearchModel.fromJson(
          {"font": nome, "data": books, "idExtension": id});
    } catch (e) {
      debugPrint("erro no search at ExtensionHenSeason: $e");
      return SearchModel(books: [], font: nome, idExtension: id);
    }
  }
}
