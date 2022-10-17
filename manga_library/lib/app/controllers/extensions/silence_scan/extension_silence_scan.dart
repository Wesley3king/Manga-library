import 'package:flutter/rendering.dart';
import 'package:manga_library/app/controllers/extensions/silence_scan/scraping/scraping_silence_scan.dart';
import 'package:manga_library/app/controllers/extensions/model_extension.dart';

import '../../../models/home_page_model.dart';
import '../../../models/manga_info_offline_model.dart';
import '../../../models/search_model.dart';

class ExtensionSilenceScan implements Extension {
  @override
  dynamic fetchServices;
  @override
  String nome = "Silence Scan";
  @override
  int id = 9;
  @override
  bool isTwoRequests = false;
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
  String getLink(String pieceOfLink) =>
      "https://silencescan.com.br/manga/$pieceOfLink/";

  @override
  Future<Capitulos> getPages(String id, List<Capitulos> listChapters) async {
    Capitulos result = Capitulos(
        capitulo: "",
        id: "",
        description: "",
        disponivel: false,
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
  Future<List<String>> getPagesForDownload(String id) async {
    return await scrapingLeitor(id);
  }

  @override
  Future<SearchModel> search(String txt) async {
    try {
      debugPrint("SILENCE SCAN SEARCH STARTING...");
      StringBuffer buffer = StringBuffer();
      List<String> cortes = txt.split(" ");

      for (int i = 0; i < cortes.length; ++i) {
        final String str = cortes[i];
        // caso seja a primeira vez não modifica o texto
        // if (i == 0) {
        //   buffer.write(str);
        // } else {
          // caso tenha caracteres maisculos
          // if (str.contains(RegExp(r'^[A-Z]'))) {
          //   debugPrint("tem maiuscula");
          //   buffer.write('+$str');
          // } else {
          //   debugPrint("não tem maiuscula");
          //   buffer.write('%20$str');
          // }
          if (i == (cortes.length - 1)) {
            buffer.write(str);
          } else {
            buffer.write('$str+');
          }
        // }
      }
      // print(buffer.toString());
      List<Map<String, String>> data = await scrapingSearch(buffer.toString());
      
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
