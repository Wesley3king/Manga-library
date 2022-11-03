import 'package:flutter/foundation.dart';
import 'package:manga_library/app/controllers/extensions/model_extension.dart';
import 'package:manga_library/app/controllers/extensions/nhen/scraping/nhen_scraping.dart';

import '../../../models/home_page_model.dart';
import '../../../models/manga_info_offline_model.dart';
import '../../../models/search_model.dart';

class ExtensionNHen implements Extension {
  @override
  dynamic fetchServices;
  @override
  String nome = "NHentai";
  @override
  String extensionPoster = "N-Hentai.png";
  @override
  int id = 5;
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
    return await compute(scrapingMangaDetail, link);
  }

  @override
  String getLink(String pieceOfLink) =>
      "https://nhentai.to/g/$pieceOfLink";

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
      debugPrint("NHENT SEARCH STARTING...");
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
      debugPrint("erro no search at ExtensionUnionMangas: $e");
      return SearchModel.fromJson(
          {"font": nome, "data": [], "idExtension": id});
    }
  }
}
