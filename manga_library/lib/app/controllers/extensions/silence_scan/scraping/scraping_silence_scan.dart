import 'package:chaleno/chaleno.dart';
import 'package:flutter/rendering.dart';

import '../../../../models/home_page_model.dart';
import '../../../../models/manga_info_offline_model.dart';

Future<List<ModelHomePage>> scrapingHomePage() async {
  const String url = 'https://silencescan.com.br/';
  List<ModelHomePage> models = [];
  try {
    var parser = await Chaleno().load(url);
    // ==================================================================
    //          -- LANCAMENTOS --
    Result? lancamentos =
        parser?.querySelector("div.postbody > div.bixbox > div.listupd");
    List<Result>? lancametosItens =
        lancamentos?.querySelectorAll("div > div.bsx");
    List<Map<String, String>> books = [];
    for (Result html in lancametosItens!) {
      // name
      String? name = html.querySelector("div.bigor > div.tt > a")!.text;
      // name!.replaceAll("...", "");
      // name.replaceAll(" - ...", "");
      // debugPrint("name: $name");
      // img
      String? img = html.querySelector("a > div.limit > img")!.src;
      // debugPrint("img: $img");
      // link
      String? link = html.querySelector("a")!.href;
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
      "idExtension": 9,
      "title": "Silence Scan Lançamentos",
      "books": books
    };
    models.add(ModelHomePage.fromJson(destaques));
    // novos
    Result? result2 = parser?.querySelector(
        "div.section > span.ts-ajax-cache > div.serieslist > ul");
    List<Result>? novosItens = result2?.querySelectorAll("li");
    books = [];

    for (Result html in novosItens!) {
      // name
      // List<Result>? nameList = html.querySelectorAll(".link-titulo");
      // print(nameList);
      // nameList!.forEach((element) =>
      //     print("${element.html} \n --------------------------------"));
      String? name = html.querySelector("div.leftseries > h2")!.text;
      // name!.replaceAll("...", "");
      // name.replaceAll(" - ...", "");
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
        "name": name ?? "erro",
        "url": linkCorte1[1].replaceAll("/", ""),
        "img": img ?? ""
      });
      debugPrint("book adicionado!!!");
    }
    // print(books);
    // monat model destaques
    if (books.isNotEmpty) {
      debugPrint("montando o model Novos");
      Map<String, dynamic> novos = {
        "idExtension": 9,
        "title": "Silence Scan Novos",
        "books": books
      };
      models.add(ModelHomePage.fromJson(novos));
    }
    // novos
    Result? result3 =
        parser?.querySelector("div#wpop-items > div.serieslist > ul");
    List<Result>? maisLidosItens = result3?.querySelectorAll("li");
    books = [];

    for (Result html in maisLidosItens!) {
      // name
      // List<Result>? nameList = html.querySelectorAll(".link-titulo");
      // print(nameList);
      // nameList!.forEach((element) =>
      //     print("${element.html} \n --------------------------------"));
      String? name = html.querySelector("div.leftseries > h2")!.text;
      // name!.replaceAll("...", "");
      // name.replaceAll(" - ...", "");
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
        "idExtension": 9,
        "title": "Silence Scan mais lidos da semana",
        "books": books
      };
      models.add(ModelHomePage.fromJson(maislidos));
    }
    return models;
  } catch (e) {
    debugPrint("erro no scrapingHomePage at ExtensionSilenceScan: $e");
    return [];
  }
}

// manga Detail
Future<MangaInfoOffLineModel?> scrapingMangaDetail(String link) async {
  //const String indentify = "";

  try {
    var parser =
        await Chaleno().load("https://silencescan.com.br/manga/$link/");

    String? name;
    String? description;
    String? img;
    String? state;
    String? authors;
    List<String> genres = [];
    List<Capitulos> chapters = [];
    if (parser != null) {
      // name
      name = parser.querySelector("div#titlemove h1.entry-title").text;
      // debugPrint("name: $name");
      // description
      description =
          parser.querySelector("div.wd-full > div.entry-content > p").text;
      // debugPrint("description: $description");
      // img
      img = parser.querySelector("div.thumb > img").src;
      // debugPrint("img: $img");
      // authors
      List<Result>? info = parser.querySelectorAll("div.tsinfo > div");
      authors = '${info[3].querySelector("i")!.text}, ${info[4].querySelector("i")!.text}';

      // state
      state = info[0].querySelector("i")!.text;
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

      for (int i = 0; i < chaptersResult.length; ++i) {
        // link
        String? link =
            chaptersResult[i].querySelector("div > div.eph-num > a")!.href;
        // pula para o próximo em caso de já existir
        //print(link);
        //if (!link!.contains("leitor/")) continue;

        List<String> corteLink1 = link!.split("br/");
        String replacedLink = corteLink1[1].replaceFirst("/", "");
        // debugPrint("replced link: $replacedLink");

        // name cap
        String? capName = chaptersResult[i]
            .querySelector("div > div.eph-num > a > span.chapternum")!
            .text;
        String chapter = capName!.replaceAll("Capítulo ", "");
        // debugPrint("chapetr name : $capName");
        // description
        String? date = chaptersResult[i]
            .querySelector("div > div.eph-num > a > span.chapterdate")!
            .text;

        chapters.add(Capitulos(
          id: replacedLink,
          capitulo: chapter,
          description: date ?? "",
          download: false,
          readed: false,
          disponivel: true,
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
        authors: authors,
        link: "https://silencescan.com.br/manga/$link/",
        idExtension: 9,
        genres: genres,
        alternativeName: false,
        chapters: chapters.length,
        capitulos: chapters,
      );
    }
  } catch (e) {
    debugPrint("erro no scrapingMangaDetail at ExtensionSilenceScan: $e");
    return null;
  }
}

// ============================================================================
//     ---------------- get pages for leitor ------------------------
// ============================================================================

Future<List<String>> scrapingLeitor(String id) async {
  try {
    var parser = await Chaleno().load("https://silencescan.com.br/$id/");

    Result? area = parser?.querySelector("div#readerarea > noscript");
    // debugPrint("area: ${area?.html}");

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
    debugPrint("erro no scrapingLeitor at ExtensionSilenceScan: $e");
    debugPrint("$s");
    return [];
  }
}

// ============================================================================
//           ---------------- search ------------------------
// ============================================================================

Future<List<Map<String, String>>> scrapingSearch(String txt) async {
  try {
    var parser = await Chaleno().load("https://silencescan.com.br/?s=$txt");

    var resultHtml = parser?.querySelector("div.listupd");
    List<Map<String, String>> books = [];
    if (resultHtml != null) {
      // projeto
      var projetoData = resultHtml.querySelectorAll("div.bs > div.bsx");
      // print(projetoData);
      if (projetoData != null) {
        // for (Result result in projetoData) {

        // }
        List<Map<String, String>> projetoBooks = projetoData.map((Result data) {
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
            "name": name ?? "error",
            "link": corteLink[1].replaceAll("/", ""),
            "img": img ?? ""
          };
        }).toList();

        books.addAll(projetoBooks);
      }
    }
    debugPrint("sucesso no scraping");
    return books;
  } catch (e, s) {
    debugPrint("erro no scrapingLeitor at EXtensionSilenceScan: $e");
    debugPrint('$s');
    //return SearchModel(font: "", books: [], idExtension: 3);
    return [];
  }
}
