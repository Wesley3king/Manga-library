import 'package:flutter/foundation.dart';
import 'package:manga_library/app/extensions/neox_scans/scraping/extension_neox_scans_scraping.dart';
// import 'package:manga_library/app/models/extension_model.dart';

import '../../models/home_page_model.dart';
import '../../models/libraries_model.dart';
import '../../models/manga_info_offline_model.dart';
import '../model_extension.dart';

class ExtensionNeoxScans implements Extension {
  @override
  dynamic fetchServices = "";
  @override
  String nome = "Neox Scans";
  @override
  String extensionPoster = "Neox-Scans.webp";
  @override
  int id = 14;
  @override
  bool nsfw = false;

  @override
  Future<List<ModelHomePage>> homePage() async {
    return await compute(scrapingHomePage, 1);
  }

  @override
  Future<MangaInfoOffLineModel?> mangaDetail(String link) async {
    return await compute(scrapingMangaDetail, link);
  }

  @override
  String getLink(String pieceOfLink) =>
      'https://neoxscans.net/manga/$pieceOfLink/';

  @override
  Future<Capitulos> getPages(String id, List<Capitulos> listChapters) async {
    Capitulos result = Capitulos(
        capitulo: "",
        id: "",
        mark: false,
        description: "",
        download: false,
        downloadPages: [],
        pages: [],
        readed: false);
    for (int i = 0; i < listChapters.length; ++i) {
      // print(
      //     "teste: num cap: ${listChapters[i].id} $id, id: $id / ${int.parse(listChapters[i].id) == int.parse(id)}");
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
  Future<List<String>> getPagesForDownload(String id) async {
    return await scrapingLeitor(id);
  }

  @override
  Future<List<Books>> search(String txt) async {
    debugPrint("NEOX SCANS SEARCH STARTING...");
    try {
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
      List<Map<String, dynamic>> data =
          await compute(scrapingSearch, buffer.toString().toLowerCase());
      debugPrint('$data');
      return data.map<Books>((json) => Books.fromJson(json)).toList();
    } catch (e) {
      debugPrint("erro no search at ExtensionNeoxScans: $e");
      return [];
    }
  }
}
