import 'package:flutter/foundation.dart';
import 'package:manga_library/app/extensions/see_mangas/repositories/extension_see_mangas_repositories.dart';
import 'package:manga_library/app/extensions/see_mangas/scraping/extension_see_mangas_scraping.dart';


import '../../models/home_page_model.dart';
import '../../models/libraries_model.dart';
import '../../models/manga_info_offline_model.dart';
import '../model_extension.dart';

class ExtensionSeeMangas implements Extension {
  @override
  dynamic fetchServices = "";
  @override
  String nome = "See Mangás";
  @override
  String extensionPoster = "See-Mangas.png";
  @override
  int id = 16;
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
  String getLink(String pieceOfLink) =>"https://seemangas.com/manga/$pieceOfLink";

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
      if (listChapters[i].id == id) {
        result = listChapters[i];
        break;
      }
    }
    if (!result.download) {
      try {
        result.pages = await compute(getImagesForLeitor, id);
      } catch (e) {
        debugPrint("erro - não foi possivel obter as paginas on-line: $e");
      }
    }
    return result;
  }

  @override
  Future<List<String>> getPagesForDownload(String id) async {
    return await compute(getImagesForLeitor, id);
  }

  @override
  Future<List<Books>> search(String txt) async {
    debugPrint("SEE MANGAS SEARCH STARTING...");
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
      List<Map<String, dynamic>> data =
          await compute(searchMangas, buffer.toString().toLowerCase());
      debugPrint('$data');
      return data.map<Books>((json) => Books.fromJson(json)).toList();
    } catch (e) {
      debugPrint("erro no search at ExtensionMundoMangaKun: $e");
      return [];
    }
  }
}
