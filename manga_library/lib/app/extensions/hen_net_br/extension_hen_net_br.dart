import 'package:flutter/foundation.dart';
import 'package:manga_library/app/extensions/hen_net_br/scraping/extension_hen_net_br_scraping.dart';
import 'package:manga_library/app/extensions/model_extension.dart';

import '../../models/home_page_model.dart';
import '../../models/libraries_model.dart';
import '../../models/manga_info_offline_model.dart';

class ExtensionHenNetBr implements Extension {
  @override
  dynamic fetchServices;
  @override
  String nome = "Hentai.net.br";
  @override
  String extensionPoster = "Hen_net_br.png";
  @override
  int id = 22;
  @override
  bool nsfw = true;
  @override
  bool isAnDeprecatedExtension = false;
  @override
  Map<String, dynamic>? fetchImagesHeader;

  @override
  Future<List<ModelHomePage>> homePage() async {
    return await compute(scrapingHomePage, 0);
  }

  @override
  Future<MangaInfoOffLineModel?> mangaDetail(String link) async {
    return await compute(scrapingMangaDetail, link);
    // scrapingMangaDetail(link);
  }

  @override
  String getLink(String pieceOfLink) => "https://hentais.net.br/$pieceOfLink/";

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
      debugPrint("HENT NET BR SEARCH STARTING...");
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
      debugPrint("erro no search at ExtensionHent.net.br: $e");
      return [];
    }
  }
}
