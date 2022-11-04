
import 'package:flutter/foundation.dart';
import 'package:manga_library/app/extensions/mundo_manga_kun/scraping/mundo_manga_kun_scraping.dart';
// import 'package:manga_library/app/models/extension_model.dart';

import '../../models/home_page_model.dart';
import '../../models/manga_info_offline_model.dart';
import '../../models/search_model.dart';
import '../model_extension.dart';

class ExtensionMundoMangaKun implements Extension {
  @override
  dynamic fetchServices = "";
  @override
  String nome = "Mundo Manga Kun";
  @override
  String extensionPoster = "Mundo-Manga-Kun.png";
  @override
  int id = 3;
  @override
  bool isTwoRequests = false;
  @override
  bool enable = true;
  @override
  bool nsfw = true;

  @override
  Future<List<ModelHomePage>> homePage() async {
    return await compute(scrapingHomePage, 1);
  }

  @override
  Future<MangaInfoOffLineModel?> mangaDetail(String link) async {
    return await compute(scrapingMangaDetail, link);
  }

  @override
  String getLink(String pieceOfLink) => 'https://mundomangakun.com.br/projeto/$pieceOfLink/';

  @override
  Future<Capitulos> getPages(String id, List<Capitulos> listChapters) async {
    Capitulos result = Capitulos(
        capitulo: "",
        id: "",
        disponivel: false,
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
  Future<SearchModel> search(String txt) async {
    debugPrint("MUNDO MANGA KUN SEARCH STARTING...");
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
      List<Map<String, String>> data = await compute(scrapingSearch, buffer.toString().toLowerCase());
      debugPrint('$data');
      return SearchModel.fromJson(
          {"font": nome, "data": data, "idExtension": id});
    } catch (e) {
      debugPrint("erro no search at ExtensionMundoMangaKun: $e");
      return SearchModel(
        font: "MangaYabu",
        idExtension: 1,
        books: [],
      );
    }
  }

  // downloads
  // @override
  // Future<void> download(DownloadActions actionType, {DownloadModel? model, Capitulos? chapter, required int idExtension}) async {
  //   switch (actionType) {
  //     case DownloadActions.start:
  //       break;
  //     case DownloadActions.download:
  //       break;
  //     case DownloadActions.cancel:
  //       break;
  //     case DownloadActions.delete:
  //       break;
  //   }
  // }
}
