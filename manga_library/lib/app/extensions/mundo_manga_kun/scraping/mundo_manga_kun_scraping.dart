import 'package:chaleno/chaleno.dart';
import 'package:flutter/rendering.dart';

import '../../../models/home_page_model.dart';
import '../../../models/manga_info_offline_model.dart';

Future<List<ModelHomePage>> scrapingHomePage(int computeInd) async {
  const String url = 'https://mundomangakun.com.br/';
  List<ModelHomePage> models = [];
  try {
    var parser = await Chaleno().load(url);
    // ==================================================================
    //          -- LANCAMENTOS --
    Result? lancamentos =
        parser?.querySelector("div.postbody > div.bixbox > div.listupd");
    List<Result>? lancametosItens =
        lancamentos?.querySelectorAll("div > div.bsx > a");
    List<Map<String, String>> books = [];
    for (Result html in lancametosItens!) {
      // name
      String? name = html.querySelector("div.bigor > div.tt")!.text;
      // name!.replaceAll("...", "");
      // name.replaceAll(" - ...", "");
      debugPrint("name: $name");
      // img
      String? img = html.querySelector("div.limit > img")!.src;
      debugPrint("img: $img");
      // link
      String? link = html.querySelector("a")!.href;
      debugPrint("link: $link");
      List<String> linkCorte1 = link!.split("com.br/");
      List<String> linkCorte2 = linkCorte1[1].split("-capitulo");

      books.add({
        "name": name!,
        "url": linkCorte2[0].replaceAll("/", ""),
        "img": img ?? ""
      });
    }
    // print(books);
    // monat model destaques
    debugPrint("montando o model Lançamentos");
    Map<String, dynamic> destaques = {
      "idExtension": 3,
      "title": "Mundo Manga Kun Lançamentos",
      "books": books
    };
    models.add(ModelHomePage.fromJson(destaques));
    // ============================================================
    // ======================== novos =============================
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
        "idExtension": 3,
        "title": "Mundo Manga Kun Novos",
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
        "idExtension": 3,
        "title": "Silence Scan mais lidos da semana",
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
    debugPrint("erro no scrapingHomePage at ExtensionMundoMangaKun: $e");
    return [];
  }
}

// manga Detail
Future<MangaInfoOffLineModel?> scrapingMangaDetail(String link) async {
  //const String indentify = "";

  try {
    var parser =
        await Chaleno().load("https://mundomangakun.com.br/manga/$link/");

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
      authors =
          '${info[3].querySelector("i")!.text}, ${info[4].querySelector("i")!.text}';

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
          capitulo: 'Capítulo $chapter',
          description: date ?? "",
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
        authors: authors,
        link: "https://mundomangakun.com.br/manga/$link/",
        idExtension: 3,
        genres: genres,
        alternativeName: false,
        chapters: chapters.length,
        capitulos: chapters,
      );
    }
  } catch (e) {
    debugPrint("erro no scrapingMangaDetail at ExtensionMundoMangaKun: $e");
    return null;
  }
}

// ============================================================================
//     ---------------- get pages for leitor ------------------------
// ============================================================================

Future<List<String>> scrapingLeitor(String id) async {
  // shounen-no-abyss_cap-tulo-01 https://mundomangakun.com.br/shounen-no-abyss-capitulo-114/
  try {
    var parser = await Chaleno().load("https://mundomangakun.com.br/$id/");

    List<Result>? area = parser?.querySelectorAll("div.wrapper > script");
    // area?.forEach((element) {
    //   debugPrint("area: ${element.html}");
    // });

    List<String> corteForDecode1 = area![0].html!.split('"images":["');
    List<String> corteForDecode2 = corteForDecode1[1].split('"]}]');
    // debugPrint('result: $resultHtml');

    List<String> bruteResultPages = corteForDecode2[0].split('","');
    List<String> resultPages = bruteResultPages.map((img) => img.replaceAll('\\', '')).toList();

    return resultPages;
  } catch (e, s) {
    debugPrint("erro no scrapingLeitor at EXtensionMundoMangaKun: $e");
    debugPrint("$s");
    return [];
  }
}
// ============================================================================
//           ---------------- search ------------------------
// ============================================================================

Future<List<Map<String, dynamic>>> scrapingSearch(String txt) async {
  try {
    var parser = await Chaleno().load("https://mundomangakun.com.br/?s=$txt");

    var resultHtml = parser?.querySelector("div.bixbox > div.listupd");
    List<Map<String, dynamic>> books = [];
    if (resultHtml != null) {
      // projeto
      var projetoData = resultHtml.querySelectorAll("div.bs > div.bsx");
      // print(projetoData);
      if (projetoData != null) {
        List<Map<String, dynamic>> projetoBooks = projetoData.map((Result data) {
          // name
          String? name = data.querySelector("a > div.bigor > div.tt")!.text;
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
            "idExtension": 3
          };
        }).toList();

        books.addAll(projetoBooks);
      }
    }
    debugPrint("sucesso no scraping");
    return books;
  } catch (e, s) {
    debugPrint("erro no scrapingLeitor at EXtensionMundoMangaKun: $e");
    debugPrint('$s');
    //return SearchModel(font: "", books: [], idExtension: 3);
    return [];
  }
}
