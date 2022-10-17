// import 'dart:developer';

import 'package:chaleno/chaleno.dart';
import 'package:flutter/rendering.dart';
// import 'package:manga_library/app/models/libraries_model.dart';

import '../../../../models/home_page_model.dart';
import '../../../../models/manga_info_offline_model.dart';
// import '../../../../models/search_model.dart';

Future<List<ModelHomePage>> scrapingHomePage() async {
  const String url = 'https://unionleitor.top/';
  const String indentify = 'div.col-md-2';
  List<ModelHomePage> models = [];
  try {
    var parser = await Chaleno().load(url);

    var result = parser?.querySelectorAll(indentify);
    // debugPrint("lrngth: ${result?.length}");
    List<Map<String, String>> books = [];
    for (Result html in result!) {
      // name
      String? name = html.querySelector("span a")!.text;
      name!.replaceAll("...", "");
      name.replaceAll(" - ...", "");
      // debugPrint(name);
      // img
      String? img = html.querySelector(".img-thumbnail")!.src;
      // debugPrint("img: $img");
      // link
      String? link = html.querySelector(".link-titulo")!.href;
      // debugPrint("link: $link");
      List<String> linkCorte1 = link!.split("manga/");

      books.add({"name": name, "url": linkCorte1[1], "img": img ?? ""});
    }
    // print(books);
    // monat model destaques
    debugPrint("montando o model Destaques");
    Map<String, dynamic> destaques = {
      "idExtension": 4,
      "title": "Union Mangas Destaques",
      "books": books
    };
    models.add(ModelHomePage.fromJson(destaques));
    // hoje
    var result2 = parser?.querySelectorAll(".col-md-12");
    books = [];
    // remover falhas de corte
    for (int i = 0; i < 9; ++i) {
      result2?.removeAt(0);
    }

    for (Result html in result2!) {
      try {
        // name
        // print(html.html);
        List<Result>? nameList = html.querySelectorAll(".link-titulo");
        // print(nameList);
        // nameList!.forEach((element) =>
        //     print("${element.html} \n --------------------------------"));
        String? name = nameList![1].text;
        // name!.replaceAll("...", "");
        // name.replaceAll(" - ...", "");
        // debugPrint(name);
        // img
        String? img = html.querySelector(".link-titulo img")!.src;
        // debugPrint("img: $img");
        // link
        String? link = html.querySelector(".link-titulo")!.href;
        // debugPrint("link: $link");
        List<String> linkCorte1 = link!.split("manga/");
        // debugPrint("link cortado: ${linkCorte1[1]}");

        books.add(
            {"name": name ?? "erro", "url": linkCorte1[1], "img": img ?? ""});
        debugPrint("book adicionado!!!");
      } catch (e) {
        debugPrint("não é um manga! at hoje: $e");
      }
    }
    // print(books);
    // monat model destaques
    if (books.isNotEmpty) {
      debugPrint("montando o model Atualizações");
      Map<String, dynamic> today = {
        "idExtension": 4,
        "title": "Union Mangas Atualizações",
        "books": books
      };
      models.add(ModelHomePage.fromJson(today));
    }
    // print(result!.length);
    // result.forEach((element) =>
    //     print("${element.html} \n --------------------------------"));
    return models;
  } catch (e) {
    debugPrint("erro no scrapingHomePage at ExtensionUnionMangas: $e");
    return [];
  }
}

// manga Detail
Future<MangaInfoOffLineModel?> scrapingMangaDetail(String link) async {
  //const String indentify = "";

  try {
    var parser =
        await Chaleno().load("https://unionleitor.top/pagina-manga/$link");

    String? name;
    String? description;
    String? img;
    String? authors;
    String? state;
    List<String> genres = [];
    List<Capitulos> chapters = [];
    if (parser != null) {
      // name
      name = parser.querySelector("div.col-md-12 h2").text;
      // List<String> corteName = htmlName!.split(
      //     '<div class="col-md-12">'); // <div class="row"><div class="col-md-8 perfil-manga"><div class="row"> <h2>
      // print(corteName);
      // name = "";
      // print("name: $name");
      // description
      description = parser.querySelector(".panel-body").text;
      // print("description: $description");
      // img
      img = parser.querySelector(".img-thumbnail").src;
      // debugPrint("img: $img");
      // authors
      List<Result>? infoResult =
          parser.querySelectorAll("div.col-md-8 h4 label");
      authors = '${infoResult[3].text}, ${infoResult[4].text}';
      // state
      state = parser.querySelector("div.col-md-8 h4 span").text;
      // state = infoResult[5].text;

      // genres
      List<Result>? genresResult = parser.querySelectorAll("div.col-md-8 h4 a");
      // print(genresResult);

      for (int i = 0; i < genresResult.length; ++i) {
        genres.add("${genresResult[i].text}");
      }
      // print(genres);
      // chapters
      List<Result> chaptersResult = parser.querySelectorAll("div.col-xs-6");
      debugPrint("length de cap: ${chaptersResult.length}");

      for (int i = 0; i < chaptersResult.length; ++i) {
        String? html = chaptersResult[i].html;
        // print(html);
        // link
        String? link = chaptersResult[i].querySelector("a")!.href;
        // pula para o próximo em caso de já existir
        //print(link);
        if (!link!.contains("leitor/")) continue;

        List<String> corteLink1 = link.split("leitor/");
        String replacedLink = corteLink1[1].replaceFirst("/", "--");
        // print("replced link: $replacedLink");

        // name cap
        String? capName = chaptersResult[i].querySelector("a")!.text;
        capName?.replaceFirst("Cap. ", "");
        // print("chapetr name : $capName");
        // description date
        List<Result>? listDate = chaptersResult[i].querySelectorAll("span");
        String? date = listDate?[1].text;
        date?.replaceAll("(", "");
        date?.replaceAll(")", "");
        // description scan
        String? scan = chaptersResult[i].querySelector("div.col-xs-6 > a")?.text;

        chapters.add(Capitulos(
          id: replacedLink,
          capitulo: capName ?? "erro",
          description: '$date - $scan',
          download: false,
          readed: false,
          disponivel: true,
          downloadPages: [],
          pages: [],
        ));
        debugPrint("capitulo adicionado! $capName");
      }

      return MangaInfoOffLineModel(
        name: name ?? "erro",
        description: description ?? "erro",
        authors: authors,
        state: state ?? "EStado desconhecido",
        img: img ?? "erro",
        link: "https://unionleitor.top/pagina-manga/$link",
        idExtension: 4,
        genres: genres,
        alternativeName: false,
        chapters: chapters.length,
        capitulos: chapters,
      );
    }
    return null;
  } catch (e) {
    debugPrint("erro no scrapingMangaDetail at ExtensionUnionMangas: $e");
    return null;
  }
}

// ============================================================================
//     ---------------- get pages for leitor ------------------------
// ============================================================================

Future<List<String>> scrapingLeitor(String id) async {
  // shounen-no-abyss_cap-tulo-01
  try {
    List<String> mangaAndChapter = id.split("--");
    var parser = await Chaleno().load(
        "https://unionleitor.top/leitor/${mangaAndChapter[0]}/${mangaAndChapter[1]}");

    var resultHtml = parser?.querySelectorAll(".img-responsive");

    List<String> resultPages = [];
    if (resultHtml != null) {
      for (int i = 0; i < 2; ++i) {
        resultHtml.removeAt(0);
      }
      for (Result image in resultHtml) {
        String? page = image.src;
        debugPrint("img: $page");
        if (page != null) {
          resultPages.add(page);
        }
      }
    }

    return resultPages;
  } catch (e, s) {
    debugPrint("erro no scrapingLeitor at EXtensionUnionMangas: $e");
    print(s);
    return [];
  }
}
// ============================================================================
//           ---------------- search ------------------------
// ============================================================================

Future<List<Map<String, String>>> scrapingSearch(String txt) async {
  try {
    var parser = await Chaleno().load("https://mundomangakun.com.br/?s=$txt");

    var resultHtml = parser?.querySelector(".main_container");
    List<Map<String, String>> books = [];
    if (resultHtml != null) {
      // projeto
      var projetoData = resultHtml.querySelectorAll(".post_projeto");
      // print(projetoData);
      if (projetoData != null) {
        List<Map<String, String>> projetoBooks = projetoData.map((Result data) {
          // name
          String? name = data.querySelector(".post_projeto_titulo")!.text;
          // img
          String? img = data.querySelector(".post_projeto_thumbnail_img")!.src;
          // link
          String? link = data.querySelector(".btn_large_primary")!.href;
          List<String> corteLink = link!.split("projeto/");
          // print(data.html);
          return {
            "nome": name ?? "error",
            "link": corteLink[1].replaceAll("/", ""),
            "capa1": img ?? ""
          };
        }).toList();

        books.addAll(projetoBooks);
      }
      // post normal
      var normalData = resultHtml.querySelectorAll(".post_normal");
      List<Map<String, String>> normalBooks = [];
      if (normalData != null) {
        for (Result data in normalData) {
          try {
            // name
            // print("pt1");
            String? name = data.querySelector(".post_title")!.text;
            // print("pt2 ${data.html}");
            // img
            String? img = data.querySelector(".post_head_thumbnail")?.src;
            // print("pt3 img;$img");
            // link
            String? link = data.querySelector(".post_head_comment_tags")!.html;
            // print("pt4");
            List<String> corteLink1 = link!.split("tags/");
            corteLink1 = corteLink1.reversed.toList();
            List<String> corteLink2 = corteLink1[0].split('/" rel=');
            // print(corteLink2);
            if (img != null && img.contains("http")) {
              bool alreadyExists = false;
              for (Map book in normalBooks) {
                if (book['link'] == corteLink2[0]) {
                  alreadyExists = true;
                  break;
                }
              }
              if (alreadyExists) continue;
              // caso não tenha ele adicionara
              normalBooks.add({
                "nome": name ?? "error",
                "link": corteLink2[0],
                "capa1": img
              });
            }
          } catch (e) {
            debugPrint("não é um manga; $e");
          }
        }
        print(normalBooks);
        books.addAll(normalBooks);
      }
    }

    // return SearchModel(font: "", books: [], idExtension: 3);
    debugPrint("sucesso no scraping");
    return books;
  } catch (e, s) {
    debugPrint("erro no scrapingLeitor at EXtensionMundoMangaKun: $e");
    print(s);
    //return SearchModel(font: "", books: [], idExtension: 3);
    return [];
  }
}
