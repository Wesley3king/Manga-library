import 'package:flutter/foundation.dart';
import 'package:manga_library/app/extensions/gekkou_scans/repositories/gekkou_scans_repositories.dart';
import 'package:manga_library/app/extensions/gekkou_scans/scraping/scraping_gekkou_scans.dart';
import 'package:manga_library/app/extensions/model_extension.dart';

import '../../models/home_page_model.dart';
import '../../models/manga_info_offline_model.dart';
import '../../models/search_model.dart';

class ExtensionGekkouScans implements Extension {
  @override
  dynamic fetchServices;
  @override
  String nome = "Gekkou Scans";
  @override
  String extensionPoster = "Gekkou-scans.png";
  @override
  int id = 11;
  @override
  bool isTwoRequests = false;
  @override
  bool enable = true;
  @override
  bool nsfw = false;

  @override
  Future<List<ModelHomePage>> homePage() async {
    return await compute(scrapingHomePage, 0);
  }

  @override
  Future<MangaInfoOffLineModel?> mangaDetail(String link) async {
    return await scrapingMangaDetail(link);
  }

  @override
  String getLink(String pieceOfLink) => "https://gekkou.com.br/manga/$pieceOfLink";

  @override
  Future<Capitulos> getPages(String id, List<Capitulos> listChapters) async {
    Capitulos result = Capitulos(
        capitulo: "",
        id: "",
        description: "",
        mark: false,
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
        result.pages = await scrapingLeitor(id);
      } catch (e) {
        debugPrint("erro - não foi possivel obter as paginas on-line: $e");
      }
    }
    return result;
  }

  @override
  Future<List<String>> getPagesForDownload(String url) async {
    return await scrapingLeitor(url);
  }

  @override
  Future<SearchModel> search(String txt) async {
    try {
      debugPrint("GEKKOU SCANS SEARCH STARTING...");
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
      List<Map<String, String>> data = await searchService(buffer.toString().toLowerCase());

      return SearchModel.fromJson(
          {"font": nome, "data": data, "idExtension": id});
    } catch (e) {
      debugPrint("erro no search at ExtensionUnionMangas: $e");
      return SearchModel.fromJson(
          {"font": nome, "data": [], "idExtension": id});
    }
  }
}
