import '../../models/home_page_model.dart';
import '../../models/manga_info_offline_model.dart';
import '../../models/search_model.dart';

abstract class Extension {
  late final dynamic fetchServices;
  late final String nome;
  late final int id;
  late final bool enable;
  late final bool isTwoRequests;
  late final bool nsfw;

  // retorna uma lista para o home page
  Future<List<ModelHomePage>> homePage() async {
    return [];
  }
  // detalhes dos mangas
  Future<MangaInfoOffLineModel?> mangaDetail(String link) async {
    return null;
  }
  // retorna um SearchModel com os mangas pesquisados
  Future<SearchModel> search(String txt) async {
    Map<String, dynamic> data = await fetchServices.search(txt);
    return SearchModel.fromJson(data);
  }
}
