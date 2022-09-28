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
    debugPrint("erro no scrapingHomePage at ExtensionMundoMangaKun: $e");
    return [];
  }
}

// manga Detail
Future<MangaInfoOffLineModel?> scrapingMangaDetail(String link) async {
  //const String indentify = "";

  try {
    var parser =
        await Chaleno().load("https://unionleitor.top/pagina-manga/$link/");

    String? name;
    String? description;
    String? img;
    List<String> genres = [];
    List<Capitulos> chapters = [];
    if (parser != null) {
      // name
      var listOfName = parser.querySelectorAll("div.col-md-8 div div");
      print(listOfName[0].html);
      name = "";
      print("name: $name");
      // description
      description = parser.querySelector("div.col-md-8 div div").text;
      print("description: $description");
      // img
      img = parser.querySelector(".img-thumbnail").src;
      debugPrint("img: $img");
      // genres
      Result? genresResult = parser.querySelector(".subtit-manga");
      print(genresResult!.html);

      // for (int i = 0; i < genresResult.length; ++i) {
      //   if (genresResult[i] != null) {
      //     genres.add("${genresResult[i]!.text}");
      //   }
      // }
      // chapters
      List<Result?> chaptersResult = parser.querySelectorAll(".link_capitulo");

      for (int i = 0; i < chaptersResult.length; ++i) {
        if (chaptersResult[i] != null) {
          String? html = chaptersResult[i]!.html;
          // link
          List<String> corteLink1 = html!.split("','");
          List<String> corteLink2 =
              corteLink1[0].split("{'"); // posição 1 link iteiro
          List<String> corteLink3 = corteLink2[1].split("/");
          // print(corteLink3);
          // List<String> corteLink4 = corteLink3[1].split("\/");
          // capitulo
          var corteCapitulo1 = html.split("</a>");
          var corteCapitulo2 = corteCapitulo1[0].split("lo "); // posição 1
          // print(html);
          // print("link: ${corteLink2[1]}");
          // print("cap: ${corteCapitulo2[1]}");
          // print("------------------------ here");
          // print(corteLink4);
          // print("${corteLink3[5]}_${corteLink3[6]}".replaceAll("\\", ""));

          chapters.add(Capitulos(
            id: "${corteLink3[5]}_${corteLink3[6]}".replaceAll("\\", ""),
            capitulo: corteCapitulo2[1],
            download: false,
            readed: false,
            disponivel: true,
            downloadPages: [],
            pages: [],
          ));
        }
      }

      return MangaInfoOffLineModel(
        name: name ?? "erro",
        description: description ?? "erro",
        img: img ?? "erro",
        link: 'https://mundomangakun.com.br/projeto/$link/',
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
  // shounen-no-abyss_cap-tulo-01
  try {
    List<String> mangaAndChapter = id.split("_");
    var parser = await Chaleno().load(
        "https://mundomangakun.com.br/leitor-online/projeto/${mangaAndChapter[0]}/${mangaAndChapter[1]}/");

    var resultHtml = parser?.querySelector("#leitor_pagina_projeto").innerHTML;

    List<String> resultPages = [];
    if (resultHtml != null) {
      print(resultHtml);
      List<String> htmlItens = resultHtml.split("</option>");
      print(htmlItens);
      List<List<String>> cortePage1 =
          htmlItens.map((String str) => str.split('">')).toList();

      List<List<String>> cortePage2 = cortePage1
          .map((List<String> list) => list[0].split('value="'))
          .toList();
      print(cortePage2);
      cortePage2.removeLast();
      resultPages = cortePage2
          .map<String>((List<String> list) => list[1].replaceAll("amp;", ""))
          .toList();
    }

    return resultPages;
  } catch (e, s) {
    debugPrint("erro no scrapingLeitor at EXtensionMundoMangaKun: $e");
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
