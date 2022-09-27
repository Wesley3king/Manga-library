import 'dart:developer';

import 'package:manga_library/app/controllers/extensions/mundo_manga_kun/scraping/mundo_manga_kun_scraping.dart';
// import 'package:manga_library/app/models/extension_model.dart';

import '../../../models/home_page_model.dart';
import '../../../models/manga_info_offline_model.dart';
import '../../../models/search_model.dart';
import '../model_extension.dart';

class ExtensionMundoMangaKun implements Extension {
  @override
  dynamic fetchServices = "";
  @override
  String nome = "Mundo Manga Kun";
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
    return await scrapingHomePage();
  }

  @override
  Future<MangaInfoOffLineModel?> mangaDetail(String link) async {
    return await scrapingMangaDetail(link);
  }

  @override
  Future<Capitulos> getPages(String id, List<Capitulos> listChapters) async {
    List<Capitulos> result = [];
    for (int i = 0; i < listChapters.length; ++i) {
      // print(
      //     "teste: num cap: ${listChapters[i].id} $id, id: $id / ${int.parse(listChapters[i].id) == int.parse(id)}");
      if (listChapters[i].id == id) {
        result.add(listChapters[i]);
        break;
      }
    }
    result[0].pages = await scrapingLeitor(id);
    return result[0];
  }

  @override
  Future<SearchModel> search(String txt) async {
    Map<String, dynamic> data = await fetchServices.search(txt);
    log("data: $data");
    return SearchModel.fromJson(data);
  }
}
