// import 'dart:convert';
import 'dart:developer';

// import 'package:chaleno/chaleno.dart';
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
  Future<SearchModel> search(String txt) async {
    Map<String, dynamic> data = await fetchServices.search(txt);
    log("data: $data");
    return SearchModel.fromJson(data);
  }
}
