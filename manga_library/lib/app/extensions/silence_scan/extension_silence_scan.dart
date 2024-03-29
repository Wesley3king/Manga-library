import 'package:flutter/foundation.dart';
import 'package:manga_library/app/extensions/silence_scan/scraping/scraping_silence_scan.dart';
import 'package:manga_library/app/extensions/model_extension.dart';

import '../../models/home_page_model.dart';
import '../../models/libraries_model.dart';
import '../../models/manga_info_offline_model.dart';

class ExtensionSilenceScan implements Extension {
  @override
  dynamic fetchServices;
  @override
  String nome = "Silence Scan";
  @override
  String extensionPoster = "Silence-Scan.png";
  @override
  int id = 9;
  @override
  bool nsfw = false;
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
  Future<List<Books>> search(String txt) async {
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
      List<Map<String, dynamic>> data =
          await compute(scrapingSearch, buffer.toString());

      // print('---------------------------------------------');
      // print(data);
      return data.map<Books>((json) => Books.fromJson(json)).toList();
    } catch (e) {
      debugPrint("erro no search at ExtensionUnionMangas: $e");
      return [];
    }
  }
}
