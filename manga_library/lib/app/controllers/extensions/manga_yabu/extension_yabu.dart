// import 'dart:convert';
import 'dart:developer';

// import 'package:chaleno/chaleno.dart';
import 'package:flutter/rendering.dart';
import 'package:manga_library/app/controllers/extensions/manga_yabu/repositories/yabu_fetch_services.dart';
import 'package:manga_library/app/controllers/extensions/manga_yabu/scraping/scraping_yabu.dart';
import 'package:manga_library/app/controllers/extensions/model_extension.dart';
// import 'package:manga_library/app/controllers/home_page_controller.dart';
import 'package:manga_library/app/models/home_page_model.dart';
// import 'package:manga_library/app/models/manga_info_model.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';
import 'package:manga_library/app/models/search_model.dart';

class ExtensionMangaYabu implements Extension {
  @override
  dynamic fetchServices = YabuFetchServices();
  @override
  String nome = "Manga Yabu";
  @override
  int id = 1;
  @override
  bool isTwoRequests = true;
  @override
  bool enable = true;
  @override
  bool nsfw = true;

  @override
  Future<List<ModelHomePage>> homePage() async {
    return await scrapingHomePage();
  }

  @override
  Future<MangaInfoOffLineModel?> mangaDetail(String link) async {
    return await scrapingMangaDetail(link);
  }

  @override
  String getLink(String pieceOfLink) => 'https://mangayabu.top/manga/$pieceOfLink/';

  @override
  Future<Capitulos> getPages(String id, List<Capitulos> listChapters) async {
    List<Capitulos> result = [];
    bool adicionated = false;
    // print("id: $id / cap: $listChapters");
    try {
      for (int i = 0; i < listChapters.length; ++i) {
        // print(
        //     "teste: num cap: ${listChapters[i].id} $id, id: $id / ${int.parse(listChapters[i].id) == int.parse(id)}");
        if (int.parse(listChapters[i].id) == int.parse(id)) {
          result.add(listChapters[i]);
          adicionated = true;
          break;
        }
      }
    } catch (e) {
      print("não é de numero");
      RegExp regex = RegExp(id, caseSensitive: false);
      for (int i = 0; i < listChapters.length; ++i) {
        // print(
        //     "teste: cap: ${listChapters[i].capitulo} ${listChapters[i].id}, id: $id / ${listChapters[i].id.toString().contains(regex)}");
        if (listChapters[i].id.toString().contains(regex)) {
          print("achei o capitulo!");
          result.add(listChapters[i]);
          adicionated = true;
          break;
        }
      }
    }
    if (!adicionated) {
      print("não achei o capitulo");
      result.add(Capitulos(
          capitulo: "error",
          id: 0,
          pages: [],
          disponivel: false,
          download: false,
          readed: false,
          downloadPages: []));
    }
    // print("result final!!!");
    // print(result);
    return result[0];
  }

  @override
  Future<SearchModel> search(String txt) async {
    debugPrint("MANGA YABU SEARCH STARTING...");
    try {
      Map<String, dynamic> data = await fetchServices.search(txt);
      log("data: $data");
      return SearchModel.fromJson(data);
    } catch (e) {
      debugPrint("erro no search at ExtensionMangaYabu: $e");
      return SearchModel(
        font: "MangaYabu",
        idExtension: 1,
        books: [],
      );
    }
  }
}
