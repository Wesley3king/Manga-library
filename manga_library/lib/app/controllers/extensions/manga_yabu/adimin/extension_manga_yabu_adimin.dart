

import '../../../../../repositories/yabu/yabu_fetch_services.dart';
import '../../../../models/search_model.dart';

class ExtensionMangaYabuAdimin {
  final YabuFetchServices yabuFetchServices = YabuFetchServices();

  // Future<MangaInfoOffLineModel?> mangaDetail(String link) async {
  //   return await scrapingMangaDetail(link);
  // }

  Future<SearchModel> search(String txt) async {
    Map<String, dynamic> data = await yabuFetchServices.searchNewBook(txt);
    return SearchModel.fromJson(data);
  }
}