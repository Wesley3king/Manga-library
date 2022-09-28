
import 'package:manga_library/app/controllers/extensions/model_extension.dart';
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
  int id = 4;
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
    Capitulos result = Capitulos(
        capitulo: "error",
        id: "error",
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
    result.pages = await scrapingLeitor(id);
    return result;
  }

  @override
  Future<SearchModel> search(String txt) async {
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
    List<Map<String, String>> data = await scrapingSearch(buffer.toString().toLowerCase());
    print(data);
    return SearchModel.fromJson(
        {"font": nome, "data": data, "idExtension": id});
  }
}