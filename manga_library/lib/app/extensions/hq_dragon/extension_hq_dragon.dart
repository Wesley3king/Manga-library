import 'package:flutter/foundation.dart';
import 'package:manga_library/app/extensions/hq_dragon/scraping/extension_hq_dragon_scraping.dart';
import 'package:manga_library/app/extensions/model_extension.dart';
import 'package:manga_library/app/extensions/union_mangas/repositories/fetch_services.dart';

import '../../models/home_page_model.dart';
import '../../models/libraries_model.dart';
import '../../models/manga_info_offline_model.dart';

class ExtensionHqDragon implements Extension {
  @override
  dynamic fetchServices;
  @override
  String nome = "Hq Dragon";
  @override
  String extensionPoster = "Union-Mangas.png";
  @override
  int id = 18;
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
      "https://unionleitor.top/pagina-manga/$pieceOfLink";

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
  Future<List<Books>> search(String txt) async {
    try {
      debugPrint("UNION SEARCH STARTING...");
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
      dynamic data = await searchService(buffer.toString().toLowerCase());
      // print("test: ${data is String ? "true":"false"}");
      // print(data.keys);
      List<Map> books = [];
      for (int i = 0; i < data['items'].length; ++i) {
        Map book = data['items'][i];

        books.add({
          "name": book["titulo"],
          "img": book['imagem'],
          "link": book['url'],
          "idExtension": id
        });
      }
      // print('---------------------------------------------');
      // print(books);
      return data.map<Books>((json) => Books.fromJson(json)).toList();
    } catch (e) {
      debugPrint("erro no search at ExtensionUnionMangas: $e");
      return [];
    }
  }
}
