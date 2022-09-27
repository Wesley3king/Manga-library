import 'dart:developer';

import 'package:chaleno/chaleno.dart';
import 'package:flutter/rendering.dart';

import '../../../../models/home_page_model.dart';
import '../../../../models/manga_info_offline_model.dart';

Future<List<ModelHomePage>> scrapingHomePage() async {
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
      debugPrint("pt1");
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
    List<String> genres = [];
    List<Capitulos> chapters = [];
    if (parser != null) {
      // name
      name = parser.querySelector(".titulo_projeto").text;
      // description
      description = parser.querySelector("div.conteudo_projeto p").text;
      print(description);
      // img
      img = parser.querySelector(".imagens_projeto_container > img").src;
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
    print(resultHtml ?? "erro null");
    if (resultHtml != null) {
      List<String> htmlItens = resultHtml.split("</option>");
    }

    return [];
  } catch (e) {
    debugPrint("erro no scrapingLeitor at EXtensionMundoMangaKun: $e");
    return [];
  }
}
