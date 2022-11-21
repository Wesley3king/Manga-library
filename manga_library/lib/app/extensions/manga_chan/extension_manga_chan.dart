import 'package:flutter/foundation.dart';
import 'package:manga_library/app/extensions/manga_chan/scraping/scraping_manga_chan.dart';
import 'package:manga_library/app/extensions/model_extension.dart';

import '../../models/home_page_model.dart';
import '../../models/manga_info_offline_model.dart';
import '../../models/search_model.dart';

class ExtensionMangaChan implements Extension {
  @override
  dynamic fetchServices;
  @override
  String nome = "Mangás Chan";
  @override
  String extensionPoster = "Manga-Chan.webp";
  @override
  int id = 10;
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
      "https://mangaschan.com/manga/$pieceOfLink/";

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
    return await compute(scrapingLeitor, id);
  }

  @override
  Future<SearchModel> search(String txt) async {
    try {
      debugPrint("SILENCE SCAN SEARCH STARTING...");
      StringBuffer buffer = StringBuffer();
      List<String> cortes = txt.split(" ");

      for (int i = 0; i < cortes.length; ++i) {
        final String str = cortes[i];
        if (i == (cortes.length - 1)) {
          buffer.write(str);
        } else {
          buffer.write('$str+');
        }
        // }
      }
      // print(buffer.toString());
      List<Map<String, String>> data = await compute(scrapingSearch, buffer.toString());

      // print('---------------------------------------------');
      // print(data);
      return SearchModel.fromJson(
          {"font": nome, "data": data, "idExtension": id});
    } catch (e) {
      debugPrint("erro no search at ExtensionUnionMangas: $e");
      return SearchModel.fromJson(
          {"font": nome, "data": [], "idExtension": id});
    }
  }
}
