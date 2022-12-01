import 'package:chaleno/chaleno.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';

import '../../../models/home_page_model.dart';
import '../../../models/manga_info_offline_model.dart';

Future<List<ModelHomePage>> scrapingHomePage(int computeIndice) async {
  const String url = 'https://prismascans.net/';
  List<ModelHomePage> models = [];
  try {
    var parser = await Chaleno().load(url);

    // ==================================================================
    //          -- ULTIMAS ATUALIZAÇÕES --
    List<Result>? lancamentos = parser?.querySelectorAll(
        "div#loop-content > div.page-listing-item > div.row > div.col-6 > div.page-item-detail");
    // List<Result>? lancametosItens =
    //     lancamentos?.querySelectorAll("div.item-summary > div.post-title > h3.h5 > a");
    List<Map<String, String>> books = [];
    for (Result html in lancamentos!) {
      // name
      String? name = html
          .querySelector("div.item-summary > div.post-title > h3.h5 > a")!
          .text;
      // debugPrint("name: $name");
      // img
      String? img = html.querySelector("div.item-thumb > a > img")!.src;
      // debugPrint("img: $img");
      // link
      String? link = html.querySelector("div.item-thumb > a")!.href;
      // debugPrint("link: $link");
      List<String> linkCorte1 = link!.split("manga/");

      books.add({
        "name": name!,
        "url": linkCorte1[1].replaceAll("/", ""),
        "img": img ?? ""
      });
    }
    // print(books);
    // monat model destaques
    debugPrint("montando o model Ultimas Atualizações");
    Map<String, dynamic> destaques = {
      "idExtension": 13,
      "title": "Prisma Scan Ultimas Atualizações",
      "books": books
    };
    models.add(ModelHomePage.fromJson(destaques));
    //================ POPULARES =======================
    List<Result>? maisLidosItens =
        parser?.querySelectorAll("div.slider__item > div.item__wrap");
    // print("data: $result3 / li: $maisLidosItens");
    books = [];

    for (Result html in maisLidosItens!) {
      // name
      String? name = html
          .querySelector(
              "div.slider__content > div.slider__content_item > div.post-title > h4 > a")!
          .text;
      // debugPrint("name: $name");
      // img
      String? img = html
          .querySelector(
              "div.slider__thumb > div.slider__thumb_item > a > img")!
          .src;
      // debugPrint("img: $img");
      // link
      String? link = html
          .querySelector("div.slider__thumb > div.slider__thumb_item > a")!
          .href;
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
      debugPrint("montando o model Mais lidos da semana");
      Map<String, dynamic> maislidos = {
        "idExtension": 13,
        "title": "Prisma scans Populares",
        "books": books
      };
      models.add(ModelHomePage.fromJson(maislidos));
    }
    return models;
  } catch (e) {
    debugPrint("erro no scrapingHomePage at ExtensionMangaChan: $e");
    return [];
  }
}

// manga Detail
Future<MangaInfoOffLineModel?> scrapingMangaDetail(String link) async {
  final Dio dio = Dio();
  //const String indentify = "";

  try {
    var parser = await Chaleno().load("https://prismascans.net/manga/$link/");

    String? name;
    String? description;
    String? img;
    String? authors;
    String? status;
    List<String> genres = [];
    List<Capitulos> chapters = [];
    if (parser != null) {
      // name
      name = parser.querySelector("div.post-title > h1").text;
      // debugPrint("name: $name");
      // description
      description = parser
          .querySelector("div.post-content > div.manga-excerpt > p > span")
          .text;
      // debugPrint("description: $description");
      // img
      img = parser.querySelector("div.summary_image > a > img").src;
      // debugPrint("img: $img");
      // authors
      List<Result>? listaInfo =
          parser.querySelectorAll("div.post-content > div.post-content_item");
      StringBuffer buffer = StringBuffer();
      for (Result info in listaInfo) {
        try {
          final String txt =
              info.querySelector("div.summary-heading > h5")!.text!;
          if (txt.contains("Autor")) {
            final String value =
                info.querySelector("div.summary-content > div > a")!.text!;
            buffer.write(value);
          } else if (txt.contains("Artista")) {
            final String value =
                info.querySelector("div.summary-content > div > a")!.text!;
            buffer.write(
                ' ,$value'); // {info.text?.replaceFirst("Artista", "").trim()}
          } else if (txt.contains("Gênero")) {
            // genres
            List<Result>? genresResult = parser.querySelectorAll(
                "div.summary-content > div.genres-content > a");
            // print(genresResult);
            for (int i = 0; i < genresResult.length; ++i) {
              genres.add("${genresResult[i].text}");
            }
          }
        } catch (e) {
          debugPrint("não encontrado o elemento: $e");
        }
      }

      authors = buffer.toString();
      // debugPrint("authors: $authors");
      // debugPrint("genres: $genres");
      final List<Result> stateResult = parser.querySelectorAll(
          "div.post-content > div.post-status > div.post-content_item");
      for (Result stateResultado in stateResult) {
        final String txt =
            stateResultado.querySelector("div.summary-heading > h5")!.text!;
        if (txt.contains("Status")) {
          final String? isInHiato = parser
              .querySelector("div.post-title > span.manga-title-badges")
              .text;
          final String value =
              stateResultado.querySelector("div.summary-content")!.text!;
          status = "${value.trim()}${isInHiato == null ? "" : ", $isInHiato"}";
        }
      }
      // debugPrint("state: $status");
      // chapters
      final Response response =
          await dio.post("https://prismascans.net/manga/$link/ajax/chapters/");
      final Parser chaptersParser = Parser(response.data);
      List<Result> chaptersResult =
          chaptersParser.querySelectorAll("ul.main > li.wp-manga-chapter");

      for (Result result in chaptersResult) {
        // debugPrint("inice: $indice / cap: ${chaptersResult.length}");
        // indice++;
        // link
        String? link = result.querySelector("a")!.href;

        List<String> corteLink1 = link!.split("manga/");
        String replacedLink = corteLink1[1].replaceAll("/", "__");
        // debugPrint("replaced link: $replacedLink");

        // name cap
        String? capName = result.querySelector("a")!.text;
        // String chapter = capName!.replaceAll("Capítulo ", "");
        // debugPrint("chapter name : $capName");
        // description
        String? capDescription =
            result.querySelector("span.chapter-release-date > i")!.text;

        chapters.add(Capitulos(
          id: replacedLink,
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
      // debugPrint("length de cap> ${chapters.length}");

      return MangaInfoOffLineModel(
        name: name?.trim() ?? "erro",
        description: description ?? "erro",
        img: img ?? "erro",
        authors: authors,
        state: status ?? "Estado desconhecido",
        link: "https://prismascans.net/manga/$link/",
        idExtension: 13,
        genres: genres,
        alternativeName: false,
        chapters: chapters.length,
        capitulos: chapters,
      );
    }
    return null;
  } catch (e) {
    debugPrint("erro no scrapingMangaDetail at ExtensionMangaChan: $e");
    return null;
  }
}

// ============================================================================
//     ---------------- get pages for leitor ------------------------
// ============================================================================

Future<List<String>> scrapingLeitor(String id) async {
  try {
    var parser = await Chaleno()
        .load("https://prismascans.net/manga/${id.replaceAll("__", "/")}");

    final List<Result>? resultHtml =
        parser?.querySelectorAll("div.reading-content > div.page-break > img");

    List<String> resultPages = [];
    if (resultHtml != null) {
      for (Result image in resultHtml) {
        List<String> cortePage1 = image.html!.split('src="');
        List<String> cortePage2 = cortePage1[1].split('" class');
        resultPages.add(cortePage2[0].trim());
      }
    }

    return resultPages;
  } catch (e, s) {
    debugPrint("erro no scrapingLeitor at EXtensionMangaChan: $e");
    debugPrint("$s");
    return [];
  }
}
// ============================================================================
//           ---------------- search ------------------------
// ============================================================================

Future<List<Map<String, dynamic>>> scrapingSearch(String txt) async {
  try {
    var parser = await Chaleno().load("https://prismascans.net/?s=$txt&post_type=wp-manga&op=&author=&artist=&release=&adult=");

    var resultHtml = parser?.querySelector("div.search-wrap > div.tab-content-wrap > div.c-tabs-item");
    List<Map<String, dynamic>> books = [];
    if (resultHtml != null) {
      // projeto
      var projetoData = resultHtml.querySelectorAll("div.row");
      if (projetoData != null) {
        List<Map<String, dynamic>> projetoBooks =
            projetoData.map((Result data) {
          // name
          String? name = data.querySelector("div.col-8 > div.tab-summary > div.post-title > h3.h4 > a")!.text;
          // debugPrint("name: $name");
          // img
          String? img = data.querySelector("div.col-4 > div.tab-thumb > a > img")!.src;
          // debugPrint("img: $img");
          // link
          String? link = data.querySelector("div.col-8 > div.tab-summary > div.post-title > h3.h4 > a")!.href;
          // debugPrint("link: $link");
          List<String> corteLink = link!.split("manga/");
          // print(data.html);
          return {
            "name": name?.trim() ?? "error",
            "link": corteLink[1].replaceAll("/", ""),
            "img": img ?? "",
            "idExtension": 13
          };
        }).toList();

        books.addAll(projetoBooks);
      }
    }
    debugPrint("sucesso no scraping");
    return books;
  } catch (e, s) {
    debugPrint("erro no scrapingLeitor at ExtensionMangaChan: $e");
    debugPrint('$s');
    //return SearchModel(font: "", books: [], idExtension: 3);
    return [];
  }
}
