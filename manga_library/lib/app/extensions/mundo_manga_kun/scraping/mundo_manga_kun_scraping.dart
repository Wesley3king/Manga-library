import 'package:chaleno/chaleno.dart';
import 'package:flutter/rendering.dart';

import '../../../models/home_page_model.dart';
import '../../../models/manga_info_offline_model.dart';

Future<List<ModelHomePage>> scrapingHomePage(int computeInd) async {
  const String url = 'https://mundomangakun.com.br/';
  const String indentify = '.post-projeto';
  List<ModelHomePage> models = [];
  try {
    var parser = await Chaleno().load(url);
    var result = parser?.querySelectorAll(indentify);
    // print(result?[0].html);
    List<String> chaptersHtml = [];
    if (result != null) {
      for (Result html in result) {
        chaptersHtml.add(html.html ?? "");
      }
      // cortar o link
      // debugPrint("pt1");
      List<List<String>> corteLink1 =
          chaptersHtml.map((e) => e.split('href="')).toList();
      List<List<String>> corteLink2 = corteLink1
          .map((e) => e[1].split('/cap'))
          .toList(); // link na posição 0
      // print(corteLink2);
      // cortar a imagem
      // debugPrint("pt2");
      List<List<String>> corteImage1 =
          chaptersHtml.map((e) => e.split('url(')).toList();
      List<List<String>> corteImage2 = corteImage1
          .map((e) => e[1].split(');"'))
          .toList(); // img na posição 0
      // cortar o nome
      List<List<String>> corteNome1 =
          chaptersHtml.map((e) => e.split('<h3 class="titulo-cap">')).toList();
      List<List<String>> corteNome2 = corteNome1
          .map((e) => e[1].split('<br><small>'))
          .toList(); // nome na posição 0

      // juntar tudo
      List<Map<String, String>> mangas = [];
      for (int i = 0; i < corteNome2.length; ++i) {
        //print(corteLink2[i][0]);
        List<String> corteLink1Home = corteLink2[i][0].split("projeto/"); // \/
        //List<String> corteLink2Home = corteLink1Home[1]
        // .split("/cap"); // .replaceFirst("leitor-online/", "")
        mangas.add({
          "name": corteNome2[i][0].trim(),
          "img": corteImage2[i][0],
          "url": corteLink1Home[1]
        });
      }
      // montar o model
      // debugPrint("$mangas");
      Map<String, dynamic> lancamentos = {
        "idExtension": 3,
        "title": "Mundo Mangá Kun Lançamentos",
        "books": mangas
      };
      models.add(ModelHomePage.fromJson(lancamentos));
    }

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
        await Chaleno().load("https://mundomangakun.com.br/projeto/$link/");

    String? name;
    String? description;
    String? img;
    String? authors;
    String? status;
    List<String> genres = [];
    List<Capitulos> chapters = [];
    if (parser != null) {
      // name
      name = parser.querySelector(".titulo_projeto").text;
      // description
      description = parser.querySelector("div.conteudo_projeto p").text;
      debugPrint(description);
      // img
      img = parser.querySelector(".imagens_projeto_container > img").src;
      // authors
      List<Result>? listaTabela =
          parser.querySelectorAll("table.tabela_info_projeto > tbody > tr");
      String? listaArtista = listaTabela[0].text?.replaceFirst("Arte", "").trim();
      String? listaAutor = listaTabela[1].text?.replaceFirst("Roteiro", "").trim();

      authors = '$listaAutor, $listaArtista';
      // status
      // List<Result>? listaStatus = .querySelectorAll("td > strong");
      status = listaTabela[4].text?.replaceFirst("Status no país de origem", "").trim();
      // genres
      List<Result?> genresResult = parser.querySelectorAll(".link_genero");

      for (int i = 0; i < genresResult.length; ++i) {
        if (genresResult[i] != null) {
          genres.add("${genresResult[i]!.text}");
        }
      }
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
            capitulo:'Capítulo ${corteCapitulo2[1]}',
            description: "",
            download: false,
            readed: false,
            mark: false,
            downloadPages: [],
            pages: [],
          ));
        }
      }

      return MangaInfoOffLineModel(
        name: name ?? "erro",
        description: description ?? "erro",
        authors: authors,
        state: status ?? "Estado desconhecido",
        img: img ?? "erro",
        link: 'https://mundomangakun.com.br/projeto/$link/',
        idExtension: 3,
        genres: genres,
        alternativeName: false,
        chapters: chapters.length,
        capitulos: chapters.reversed.toList(),
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
            "name": name ?? "error",
            "link": corteLink[1].replaceAll("/", ""),
            "img": img ?? ""
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
                "name": name ?? "error",
                "link": corteLink2[0],
                "img": img
              });
            }
          } catch (e) {
            debugPrint("não é um manga; $e");
          }
        }
        debugPrint('$normalBooks');
        books.addAll(normalBooks);
      }
    }

    // return SearchModel(font: "", books: [], idExtension: 3);
    debugPrint("sucesso no scraping");
    return books;
  } catch (e, s) {
    debugPrint("erro no scrapingLeitor at EXtensionMundoMangaKun: $e");
    debugPrint('$s');
    //return SearchModel(font: "", books: [], idExtension: 3);
    return [];
  }
}
