// import 'dart:convert';
import 'dart:developer';

// import 'package:chaleno/chaleno.dart';
import 'package:flutter/foundation.dart';
import 'package:manga_library/app/extensions/manga_yabu/repositories/yabu_fetch_services.dart';
import 'package:manga_library/app/extensions/manga_yabu/scraping/scraping_yabu.dart';
import 'package:manga_library/app/extensions/model_extension.dart';
// import 'package:manga_library/app/controllers/home_page_controller.dart';
import 'package:manga_library/app/models/home_page_model.dart';
// import 'package:manga_library/app/models/manga_info_model.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

import '../../models/libraries_model.dart';

class ExtensionMangaYabu implements Extension {
  @override
  dynamic fetchServices = YabuFetchServices();
  @override
  String nome = "Manga Yabu";
  @override
  String extensionPoster = "Manga-Yabu.png";
  @override
  int id = 1;
  @override
  bool nsfw = false;
  @override
  bool isAnDeprecatedExtension = true;
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
  String getLink(String pieceOfLink) =>
      'https://mangayabu.top/manga/$pieceOfLink/';

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
    debugPrint("MANGA YABU SEARCH STARTING...");
    try {
      List<Map<String, dynamic>> data = await fetchServices.search(txt);
      log("data: $data");
      return data.map<Books>((json) => Books.fromJson(json)).toList();
    } catch (e) {
      debugPrint("erro no search at ExtensionMangaYabu: $e");
      return [];
    }
  }
}
