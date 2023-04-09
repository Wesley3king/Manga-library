import 'package:chaleno/chaleno.dart';
import 'package:chaleno/chaleno.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';

import '../../../models/home_page_model.dart';
import '../../../models/manga_info_offline_model.dart';

Future<List<ModelHomePage>> scrapingHomePage(int computeInd) async {
  const String url = 'https://leitorizakaya.net/';
  List<ModelHomePage> models = [];
  try {
    var parser = await Chaleno().load(url);
    // ==================================================================
    //          -- LANCAMENTOS --
    List<Result>? lancametosItens = parser?.querySelectorAll(
        "div.page-listing-item > div.row > div.col-6 > div.page-item-detail");
    List<Map<String, String>> books = [];
    for (Result html in lancametosItens!) {
      // name
      String? name = html
          .querySelector("div.item-summary > div.post-title > h3 > a")!
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
    debugPrint("montando o model Lançamentos");
    Map<String, dynamic> destaques = {
      "idExtension": 21,
      "title": "Izakaya",
      "books": books
    };
    models.add(ModelHomePage.fromJson(destaques));
    return models;
  } catch (e) {
    debugPrint("erro no scrapingHomePage at ExtensionIzakaya: $e");
    return [];
  }
}

// manga Detail
Future<MangaInfoOffLineModel?> scrapingMangaDetail(String link) async {
  try {
    var parser = await Chaleno().load("https://leitorizakaya.net/manga/$link/");
    String? name;
    String? description;
    String? img;
    String? state;
    String? authors;
    List<String> genres = [];
    List<Capitulos> chapters = [];
    if (parser != null) {
      // name
      name = parser.querySelector("div.post-title > h1").text;

      // debugPrint("name: $name");
      // description
      description = parser.querySelector("div.manga-excerpt").text;
      debugPrint("description: $description");
      // img
      img = parser.querySelector("div.summary_image > a > img").src;
      // debugPrint("img: $img");
      // authors
      List<Result>? listaInfo =
          parser.querySelectorAll("div.post-content > div.post-content_item");
      for (Result info in listaInfo) {
        try {
          final String txt =
              info.querySelector("div.summary-heading > h5")!.text!;
          if (txt.contains("Autor") || txt.contains("Estudio")) {
            final String value =
                info.querySelector("div.summary-content > div > a")!.text!;
            authors = value;
          } else if (txt.contains("Gênero")) {
            final String? genre = parser
                .querySelector("div.post-title > span.manga-title-badges")
                .text;
            if (genre != null) {
              genres.add(genre);
            }
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
      // debugPrint("authors: $authors");
      // debugPrint("genres: $genres");
      final List<Result> stateResult = parser.querySelectorAll(
          "div.post-content > div.post-status > div.post-content_item");
      for (Result stateResultado in stateResult) {
        final String txt =
            stateResultado.querySelector("div.summary-heading > h5")!.text!;
        if (txt.contains("Estado")) {
          final String value =
              stateResultado.querySelector("div.summary-content")!.text!;
          state = value.trim();
        }
      }
      // debugPrint("genres: $genres");
      // chapters
      Response responseChapters = await Dio()
          .post("https://leitorizakaya.net/manga/$link/ajax/chapters/");
      Parser chaptersParser = Parser(responseChapters.data);
      List<Result> chaptersResult =
          chaptersParser.querySelectorAll("ul.main > li.wp-manga-chapter");

      for (Result result in chaptersResult) {
        // link
        String? link = result.querySelector("a")!.href;

        List<String> corteLink1 = link!.split("manga/");
        String replacedLink = corteLink1[1].replaceAll("/", "__");
        // debugPrint("replaced link: $replacedLink");

        // name cap
        String? capName = result.querySelector("a")!.text;
        // String chapter = capName!.replaceAll("Capítulo ", "");
        // debugPrint("chapter name : ${capName?.trim()}");
        // description
        String? capDescription =
            result.querySelector("span.chapter-release-date > i")?.text;
        // debugPrint("chapter description : $capName");

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

      return MangaInfoOffLineModel(
        name: name?.trim() ?? "erro",
        description: description?.trim() ?? "erro",
        img: img ?? "erro",
        state: state ?? "Estado desconhecido",
        authors: authors ?? "Autor desconhecido",
        link: "https://leitorizakaya.net/manga/$link/",
        idExtension: 21,
        genres: genres,
        alternativeName: false,
        chapters: chapters.length,
        capitulos: chapters,
      );
    }
    return null;
  } catch (e) {
    debugPrint("erro no scrapingMangaDetail at ExtensionIzakaya: $e");
    return null;
  }
}

// ============================================================================
//     ---------------- get pages for leitor ------------------------
// ============================================================================

Future<List<String>> scrapingLeitor(String id) async {
  try {
    List<String> resultPages = [];
    var parser = await Chaleno()
        .load("https://leitorizakaya.net/manga/${id.replaceAll("__", "/")}");
    final Result? novelParser =
        parser?.querySelector("div.reading-content > div.text-left");
    if (novelParser?.html == null) {
      final List<Result>? resultHtml = parser
          ?.querySelectorAll("div.reading-content > div.page-break > img");
      if (resultHtml != null) {
        for (Result image in resultHtml) {
          List<String> cortePage1 = image.html!.split('src="');
          List<String> cortePage2 = cortePage1[1].split('" class');
          resultPages.add(cortePage2[0].trim());
        }
      }
    } else {
      resultPages.add("== NOVEL READER ==");
      List<Result>? lines = novelParser!.querySelectorAll("p > span");
      if (lines != null && lines.isEmpty) {
        lines = novelParser.querySelectorAll("p");
        for (Result line in lines!) {
          resultPages.add('${line.text}');
        }
      } else {
        for (Result line in lines!) {
          resultPages.add('${line.text}');
        }
      }
    }

    return resultPages;
  } catch (e, s) {
    debugPrint("erro no scrapingLeitor at ExtensionIzakaya: $e");
    debugPrint("$s");
    return [];
  }
}
// ============================================================================
//           ---------------- search ------------------------
// ============================================================================

Future<List<Map<String, dynamic>>> scrapingSearch(String txt) async {
  try {
    var parser = await Chaleno()
        .load("https://leitorizakaya.net/?s=$txt&post_type=wp-manga");

    List<Result>? resultHtml =
        parser?.querySelectorAll("div.c-tabs-item > div.c-tabs-item__content");
    List<Map<String, dynamic>> books = [];
    if (resultHtml != null) {
      List<Map<String, dynamic>> projetoBooks = resultHtml.map((Result data) {
        // name
        String? name = data
            .querySelector("div.col-8 > div.tab-summary > div.post-title > h3")!
            .text;
        // debugPrint("name: $name");
        // img
        String? img =
            data.querySelector("div.col-4 > div.tab-thumb > a > img")!.src;
        // debugPrint("img: $img");
        // link
        String? link =
            data.querySelector("div.col-4 > div.tab-thumb > a")!.href;
        // debugPrint("link: $link");
        List<String> corteLink = link!.split("manga/");
        // print(data.html);
        return {
          "name": name?.trim() ?? "error",
          "link": corteLink[1].replaceAll("/", ""),
          "img": img ?? "",
          "idExtension": 21
        };
      }).toList();

      books.addAll(projetoBooks);
    }
    debugPrint("sucesso no scraping");
    return books;
  } catch (e, s) {
    debugPrint("erro no scrapingLeitor at ExtensionIzakaya: $e");
    debugPrint('$s');
    return [];
  }
}
