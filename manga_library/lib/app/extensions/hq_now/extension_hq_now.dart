import 'package:flutter/foundation.dart';
import 'package:manga_library/app/extensions/hq_now/repositories/extension_hq_now_repositories.dart';
import 'package:manga_library/app/extensions/neox_scans/scraping/extension_neox_scans_scraping.dart';

import '../../models/home_page_model.dart';
import '../../models/libraries_model.dart';
import '../../models/manga_info_offline_model.dart';
import '../model_extension.dart';

class ExtensionHqNow implements Extension {
  @override
  dynamic fetchServices = HqNowRepositories();
  @override
  String nome = "Hq Now";
  @override
  String extensionPoster = "Hq-Now.png";
  @override
  int id = 17;
  @override
  bool nsfw = false;

  @override
  Future<List<ModelHomePage>> homePage() async {
    return await compute(fetchServices.homePage, 1);
  }

  @override
  Future<MangaInfoOffLineModel?> mangaDetail(String link) async {
    return await compute(fetchServices.getMangaDetail, link);
  }

  @override
  String getLink(String pieceOfLink) => "https://www.hq-now.com/hq/$pieceOfLink/";

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
        result.pages = await compute(fetchServices.getPages, id);
      } catch (e) {
        debugPrint("erro - não foi possivel obter as paginas on-line: $e");
      }
    }
    return result;
  }

  @override
  Future<List<String>> getPagesForDownload(String id) async {
    return await compute(fetchServices.getPages, id);
  }

  @override
  Future<List<Books>> search(String txt) async {
    debugPrint("HQ NOW SEARCH STARTING...");
    try {
      List<Map<String, dynamic>> data =
          await compute(fetchServices.search, txt);
      debugPrint('$data');
      return data.map<Books>((json) => Books.fromJson(json)).toList();
    } catch (e) {
      debugPrint("erro no search at ExtensionHqNow: $e");
      return [];
    }
  }
}
