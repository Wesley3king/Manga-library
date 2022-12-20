import 'package:chaleno/chaleno.dart';
import 'package:flutter/rendering.dart';

import '../../../models/home_page_model.dart';
import '../../../models/manga_info_offline_model.dart';

Future<List<ModelHomePage>> scrapingHomePage(int computeIndice) async {
  const String url = 'https://mangaschan.com/';
  List<ModelHomePage> models = [];
  try {
    var parser = await Chaleno().load(url);
    List<Map<String, String>> books = [];
    // ==============================================
    // -----------------  destaques  ----------------
    List<Result> destaquesItens = parser!.querySelectorAll("div.bixbox > div.listupd > div.bs > div.bsx > a");
    books = [];

    for (Result html in destaquesItens) {
      // name
      String? name = html.querySelector("div.bigor > div.tt")!.text;

      // debugPrint("name: $name");
      // img
      String? img = html.querySelector("div.limit > img")!.src;
      // debugPrint("img: $img");
      // link
      String? link = html.href;
      // debugPrint("link: $link");
      List<String> linkCorte1 = link!.split("manga/");
      // debugPrint("link cortado: ${linkCorte1[1]}");

      books.add({
        "name": name?.trim() ?? "erro",
        "url": linkCorte1[1].replaceAll("/", ""),
        "img": img ?? ""
      });
      // debugPrint("book adicionado!!!");
    }
    // print(books);
    // monat model destaques
    if (books.isNotEmpty) {
      debugPrint("montando o model destaques");
      Map<String, dynamic> maislidos = {
        "idExtension": 10,
        "title": "Mangás Chan Destaques",
        "books": books
      };
      models.add(ModelHomePage.fromJson(maislidos));
    }
    // ==================================================================
    //          -- ULTIMAS ATUALIZAÇÕES --
    books = [];
    List<Result>? lancametosItens =
        parser.querySelectorAll("div.bixbox > div.listupd > div.utao");
    for (Result html in lancametosItens) {
      // name
      String? name = html.querySelector("div.uta > div.luf > a > h4")!.text;
      // debugPrint("name: $name");
      // img
      String? img = html.querySelector("div.imgu > a > img")!.src;
      // debugPrint("img: $img");
      // link
      String? link = html.querySelector("div.uta > div.luf > a")!.href;
      // debugPrint("link: $link");
      List<String> linkCorte1 = link!.split("manga/");

      books.add({
        "name": name!.trim(),
        "url": linkCorte1[1].replaceAll("/", ""),
        "img": img ?? ""
      });
    }
    // print(books);
    // monat model destaques
    debugPrint("montando o model Ultimas Atualizações");
    Map<String, dynamic> destaques = {
      "idExtension": 10,
      "title": "Mangás Chan Ultimas Atualizações",
      "books": books
    };
    models.add(ModelHomePage.fromJson(destaques));
    // mais lidos
    Result? result3 = parser.querySelector("div.section > div#wpop-items > div.serieslist > ul");
    List<Result>? maisLidosItens = result3.querySelectorAll("li");
    // print(result3?.html);
    // print("data: $result3 / li: $maisLidosItens");
    books = [];

    for (Result html in maisLidosItens!) {
      // name
      String? name = html.querySelector("div.leftseries > h2")!.text;

      // debugPrint("name: $name");
      // img
      String? img = html.querySelector("div.imgseries > a > img")!.src;
      // debugPrint("img: $img");
      // link
      String? link = html.querySelector("div.imgseries > a")!.href;
      // debugPrint("link: $link");
      List<String> linkCorte1 = link!.split("manga/");
      // debugPrint("link cortado: ${linkCorte1[1]}");

      books.add({
        "name": name?.trim() ?? "erro",
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
        "idExtension": 10,
        "title": "Mangás Chan mais lidos da semana",
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
  //const String indentify = "";

  try {
    var parser = await Chaleno().load("https://mangaschan.com/manga/$link/");

    String? name;
    String? description;
    String? img;
    String? authors;
    String? status;
    List<String> genres = [];
    List<Capitulos> chapters = [];
    if (parser != null) {
      // debugPrint("html: ${parser.html}");
      // name
      name = parser.querySelector("div#titlemove > h1.entry-title").text;
      // debugPrint("name: $name");
      // description
      description = parser
          .querySelector("div.wd-full > div.entry-content-single > p")
          .text;
      // debugPrint("description: $description");
      // img
      img = parser.querySelector("div.thumb > img").src;
      // debugPrint("img: $img");
      // authors
      List<Result>? listaInfo =
          parser.querySelectorAll("div.tsinfo > div.imptdt");
      StringBuffer buffer = StringBuffer();
      for (Result info in listaInfo) {
        if (info.text!.contains("Autor")) {
          buffer.write('${info.text?.replaceFirst("Autor", "").trim()}');
        } else if (info.text!.contains("Artista")) {
          buffer.write(', ${info.text?.replaceFirst("Artista", "").trim()}');
        }
      }

      authors = buffer.toString();
      // debugPrint("authors: $authors");
      // status
      status = listaInfo[0].text?.replaceFirst("Status", "").trim();
      // debugPrint("state: $status");
      // genres
      List<Result>? genresResult =
          parser.querySelectorAll("div.wd-full > span.mgen > a");
      // print(genresResult);

      for (int i = 0; i < genresResult.length; ++i) {
        genres.add("${genresResult[i].text}");
      }
      // debugPrint("genres: $genres");
      // chapters
      List<Result> chaptersResult =
          parser.querySelectorAll("div#chapterlist > ul > li");
      // debugPrint("length de cap: ${chaptersResult.length}");
      // int indice = 0;

      for (Result result in chaptersResult) {
        // debugPrint("inice: $indice / cap: ${chaptersResult.length}");
        // indice++;
        // link
        String? link = result.querySelector("div > div.eph-num > a")!.href;

        List<String> corteLink1 = link!.split("com/");
        String replacedLink = corteLink1[1].replaceFirst("/", "");
        // debugPrint("replaced link: $replacedLink");

        // name cap
        String? capName = result
            .querySelector("div > div.eph-num > a > span.chapternum")!
            .text;
        String chapter = capName!.replaceAll("Capítulo ", "");
        // debugPrint("chapetr name : $capName");
        // description
        String? capDescription = result
            .querySelector("div > div.eph-num > a > span.chapterdate")!
            .text;

        chapters.add(Capitulos(
          id: replacedLink,
          capitulo: 'Capítulo $chapter',
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
        name: name ?? "erro",
        description: description ?? "erro",
        img: img ?? "erro",
        authors: authors,
        state: status ?? "Estado desconhecido",
        link: "https://mangaschan.com/manga/$link/",
        idExtension: 10,
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
    var parser = await Chaleno().load("https://mangaschan.com/$id/");

    Result? area = parser?.querySelector("div#readerarea > noscript");
    debugPrint("area: ${area?.html}");

    List<String>? resultHtml = area?.html?.split('" alt=');
    // debugPrint('result: $resultHtml');

    List<String> resultPages = [];
    if (resultHtml != null) {
      for (String image in resultHtml) {
        if (image.contains('src="http')) {
          List<String>? page = image.split('src="'); // image on index 1
          // debugPrint("img: $page");
          resultPages.add(page[1]);
        }
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
    var parser = await Chaleno().load("https://mangaschan.com/?s=$txt");

    var resultHtml = parser?.querySelector("div.bixbox > div.listupd");
    List<Map<String, dynamic>> books = [];
    if (resultHtml != null) {
      // projeto
      var projetoData = resultHtml.querySelectorAll("div.bs > div.bsx");
      // print(projetoData);
      if (projetoData != null) {
        // for (Result result in projetoData) {

        // }
        List<Map<String, dynamic>> projetoBooks =
            projetoData.map((Result data) {
          // name
          String? name = data.querySelector("a div.tt")!.text;
          // debugPrint("name: $name");
          // img
          String? img = data.querySelector("a > div.limit > img")!.src;
          // debugPrint("img: $img");
          // link
          String? link = data.querySelector("a")!.href;
          // debugPrint("link: $link");
          List<String> corteLink = link!.split("manga/");
          // print(data.html);
          return {
            "name": name?.trim() ?? "error",
            "link": corteLink[1].replaceAll("/", ""),
            "img": img ?? "",
            "idExtension": 10
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
