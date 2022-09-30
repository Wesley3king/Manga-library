import '../../models/download_model.dart';
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

  String getLink(String pieceOfLink) => "";

  // retorna uma lista com as paginas
  Future<Capitulos> getPages(String url, List<Capitulos> listChapters) async {
    return Capitulos(
        capitulo: "",
        disponivel: false,
        download: false,
        downloadPages: [],
        id: 0,
        pages: [],
        readed: false);
  }

  // paginas para o download
  Future<List<String>> getPagesForDownload(String url) async {
    return [];
  }

  // retorna um SearchModel com os mangas pesquisados
  Future<SearchModel> search(String txt) async {
    Map<String, dynamic> data = await fetchServices.search(txt);
    return SearchModel.fromJson(data);
  }

  // implementa os downloads
  // Future<void> download(DownloadActions actionType,
  //     {DownloadModel? model, Capitulos? chapter, required int idExtension}) async {
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

// enum DownloadActions { start, download, cancel, delete }
