import 'package:flutter/foundation.dart';
import 'package:manga_library/app/extensions/model_extension.dart';
import 'package:manga_library/app/extensions/nhen_net/scraping/extension_nhen_net_scraping.dart';

import '../../models/home_page_model.dart';
import '../../models/libraries_model.dart';
import '../../models/manga_info_offline_model.dart';

class ExtensionNHenNet implements Extension {
  @override
  dynamic fetchServices;
  @override
  String nome = "NHentai.net";
  @override
  String extensionPoster = "N-Hentai.png";
  @override
  int id = 19;
  @override
  bool nsfw = true;
  @override
  Map<String, dynamic>? fetchImagesHeader;

  @override
  Future<List<ModelHomePage>> homePage() async {
    return await compute(scrapingHomePage, 0);
  }

  @override
  Future<MangaInfoOffLineModel?> mangaDetail(String link) async {
    return await compute(scrapingMangaDetail, link);
  }

  @override
  String getLink(String pieceOfLink) => "https://nhentai.net/g/$pieceOfLink/";

  @override
  Future<Capitulos> getPages(String id, List<Capitulos> listChapters) async {
    return listChapters[0];
  }

  @override
  Future<List<String>> getPagesForDownload(String url) async {
    return [];
  }

  @override
  Future<List<Books>> search(String txt) async {
    try {
      debugPrint("NHENT.NET SEARCH STARTING...");
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

      return books.map<Books>((json) => Books.fromJson(json)).toList();
    } catch (e) {
      debugPrint("erro no search at ExtensionNhen.net: $e");
      return [];
    }
  }
}
