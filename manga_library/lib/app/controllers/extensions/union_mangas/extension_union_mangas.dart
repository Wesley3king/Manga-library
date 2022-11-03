import 'package:flutter/foundation.dart';
import 'package:manga_library/app/controllers/extensions/model_extension.dart';
import 'package:manga_library/app/controllers/extensions/union_mangas/repositories/fetch_services.dart';
import 'package:manga_library/app/controllers/extensions/union_mangas/scraping/union_scraping.dart';

import '../../../models/home_page_model.dart';
import '../../../models/manga_info_offline_model.dart';
import '../../../models/search_model.dart';

class ExtensionUnionMangas implements Extension {
  @override
  dynamic fetchServices;
  @override
  String nome = "Union Mangas";
  @override
  String extensionPoster = "Union-Mangas.png";
  @override
  int id = 4;
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
    return await scrapingMangaDetail(link);
  }

  @override
  String getLink(String pieceOfLink) => "https://unionleitor.top/pagina-manga/$pieceOfLink";

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
  Future<List<String>> getPagesForDownload(String url) async {
    return await scrapingLeitor(url);
  }

  @override
  Future<SearchModel> search(String txt) async {
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
          "link": book['url']
        });
      }
      // print('---------------------------------------------');
      // print(books);
      return SearchModel.fromJson(
          {"font": nome, "data": books, "idExtension": id});
    } catch (e) {
      debugPrint("erro no search at ExtensionUnionMangas: $e");
      return SearchModel.fromJson(
          {"font": nome, "data": [], "idExtension": id});
    }
  }
}
