import 'package:chaleno/chaleno.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';

import '../../../models/home_page_model.dart';
import '../../../models/manga_info_offline_model.dart';

Future<List<ModelHomePage>> scrapingHomePage(int computeInd) async {
  const String url = 'https://seemangas.com/';
  List<ModelHomePage> models = [];
  try {
    var parser = await Chaleno().load(url);
    // // ==================================================================
    // //          -- LANCAMENTOS --
    // List<Result>? lancametosItens = parser?.querySelectorAll(
    //     "div.lancamento > ul > li.item_news-manga");
    List<Map<String, String>> books = [];
    // for (Result html in lancametosItens!) {
    //   // name
    //   String? name = html
    //       .querySelector("div.right > div.clearfix > h3.entry-title > a")!
    //       .text;
    //   // debugPrint("name: $name");
    //   // img
    //   String? img = html.querySelector("a.manga > img")!.src;
    //   // debugPrint("img: $img");
    //   // link
    //   String? link = html.querySelector("a.manga")!.href;
    //   // debugPrint("link: $link");
    //   List<String> linkCorte1 = link!.split("manga/");

    //   books.add({
    //     "name": name!,
    //     "url": linkCorte1[1].replaceAll("/", ""),
    //     "img": img ?? ""
    //   });
    // }
    // // print(books);
    // // monat model destaques
    // debugPrint("montando o model Lançamentos");
    // Map<String, dynamic> destaques = {
    //   "idExtension": 16,
    //   "title": "See Mangas Ultimas atualizações",
    //   "books": books
    // };
    // models.add(ModelHomePage.fromJson(destaques));
    // ============================================================
    // ======================== recomendacoes =============================
    List<Result>? novosItens =
        parser?.querySelectorAll("div.slider-des > div.itemC");
    books.clear();

    for (Result html in novosItens!) {
      // name
      String? name = html.querySelector("div.dados > a > div.title > h2")!.text;
      // debugPrint("name: $name");
      // img
      String? img = html.querySelector("a > div.thumb > img")!.src;
      // debugPrint("img: $img");
      // link
      String? link = html.querySelector("a")!.href;
      // debugPrint("link: $link");
      List<String> linkCorte1 = link!.split("manga/");
      // debugPrint("link cortado: ${linkCorte1[1]}");

      books.add({
        "name": name ?? "erro",
        "url": linkCorte1[1].replaceAll("/", ""),
        "img": img ?? ""
      });
      // debugPrint("book adicionado!!!");
    }
    // print(books);
    // monat model destaques
    if (books.isNotEmpty) {
      debugPrint("montando o model Novos");
      Map<String, dynamic> novos = {
        "idExtension": 16,
        "title": "See Mangas Destaques",
        "books": books
      };
      models.add(ModelHomePage.fromJson(novos));
    }
    // ====================== Popular ==========================
    List<Result>? maisLidosItens =
        parser?.querySelectorAll("ul.sidebar-popular > li.popular-treending");
    books.clear();

    for (Result html in maisLidosItens!) {
      // name
      String? name = html.querySelector("div.data-infos > a > h4")!.text;
      // debugPrint("name: $name");
      // img
      String? img = html.querySelector("a > div.tumbl > img")!.src;
      // debugPrint("img: $img");
      // link
      String? link = html.querySelector("a")!.href;
      // debugPrint("link: $link");
      List<String> linkCorte1 = link!.split("manga/");
      // debugPrint("link cortado: ${linkCorte1[1]}");

      books.add({
        "name": name ?? "erro",
        "url": linkCorte1[1].replaceAll("/", ""),
        "img": img ?? ""
      });
      debugPrint("book adicionado!!!");
    }
    // print(books);
    // monat model destaques
    if (books.isNotEmpty) {
      debugPrint("montando o model Mais lidos da semana");
      Map<String, dynamic> maislidos = {
        "idExtension": 16,
        "title": "See Mangas Populares",
        "books": books
      };
      models.add(ModelHomePage.fromJson(maislidos));
    }
    // // montar o model
    // // debugPrint("$mangas");
    // Map<String, dynamic> lancamentos = {
    //   "idExtension": 3,
    //   "title": "Mundo Mangá Kun Lançamentos",
    //   "books": mangas
    // };
    // models.add(ModelHomePage.fromJson(lancamentos));

    return models;
  } catch (e) {
    debugPrint("erro no scrapingHomePage at ExtensionNeoxScans: $e");
    return [];
  }
}

// manga Detail
Future<MangaInfoOffLineModel?> scrapingMangaDetail(String link) async {
  final Dio dio = Dio();
  try {
    var parser = await Chaleno().load("https://seemangas.com/manga/$link");

    String? name;
    String? description;
    String? img;
    String? state;
    String? authors;
    List<String> genres = [];
    List<Capitulos> chapters = [];
    if (parser != null) {
      // name
      name = parser.querySelector("h1.kw-title").text;
      // debugPrint("name: $name");
      // description
      description = parser.querySelector("div.sinopse-page").text;
      // debugPrint("description: $description");
      // img
      img = parser.querySelector("div.mangapage > div.thumb > img").src;
      // debugPrint("img: $img");
      // authors
      authors =
          parser.querySelector("div.jVBw-infos > div.author").text?.trim();
      // state
      state = parser.querySelector("div.jVBw-infos > span.mdq").text;
      // genres
      List<Result>? genresResult =
          parser.querySelectorAll("ul.generos > li.touchcarousel-item > a");
      for (int i = 0; i < genresResult.length; ++i) {
        genres.add("${genresResult[i].text}");
      }
      // debugPrint("authors: $authors");
      // debugPrint("genres: $genres");
      // ----- chapters -------
      List<Result> chaptersResult =
          parser.querySelectorAll("ul.full-chapters-list > li");

      for (Result result in chaptersResult) {
        // link
        String? link = result.querySelector("a")!.href;

        List<String> corteLink1 = link!.split("ler/");
        // String replacedLink = corteLink1[1].replaceAll("/", "__");
        // debugPrint("replaced link: $corteLink1");

        // name cap
        String? capName = result
            .querySelector(
                "a > div.chapter-info > div.chapter-info-text > span.cap-text")!
            .text;
        // String chapter = capName!.replaceAll("Capítulo ", "");
        // debugPrint("chapter name : $capName");
        // description
        String? capDescription = result
            .querySelector("a > div.chapter-options > span.chapter-date")!
            .text;
        // debugPrint("chapter name : $capDescription");

        chapters.add(Capitulos(
          id: corteLink1[1],
          capitulo: capName!.trim(),
          description: capDescription ?? "",
          download: false,
          readed: false,
          mark: false,
          downloadPages: [],
          pages: [],
        ));
        // debugPrint("capitulo adicionado! $capName");
      }

      return MangaInfoOffLineModel(
        name: name ?? "erro",
        description: description ?? "erro",
        img: img ?? "erro",
        state: state ?? "Estado desconhecido",
        authors: authors ?? "Autor desconhecido",
        link: "https://seemangas.com/manga/$link",
        idExtension: 16,
        genres: genres,
        alternativeName: false,
        chapters: chapters.length,
        capitulos: chapters,
      );
    }
    return null;
  } catch (e) {
    debugPrint("erro no scrapingMangaDetail at ExtensionMundoMangaKun: $e");
    return null;
  }
}
