import 'dart:convert';
// import 'dart:developer';

import 'package:chaleno/chaleno.dart';
import 'package:flutter/rendering.dart';

import '../../../../models/home_page_model.dart';
import '../../../../models/manga_info_offline_model.dart';
import '../../../home_page_controller.dart';

Future<List<ModelHomePage>> scrapingHomePage() async {
  const String url = 'https://mangayabu.top/';
  const String indentify = '.manga-card';
  try {
    var parser = await Chaleno().load(url);
    HomePageController.errorMessage += '${parser?.html} ----\n';
    var result = parser?.querySelectorAll(indentify);
    // retirar as scans
    HomePageController.errorMessage += 'length = ${result?.length} $result';
    if (result == null) {
      HomePageController.errorMessage += ' || null || ';
    }
    try {
      for (int i = 0; i < 20; ++i) {
        result?.removeLast();
      }
    } catch (e) {
      HomePageController.errorMessage += 'sesão de remoção- ${e.toString()}';
      throw Error();
    }

    // aqui será feito o tratamento das informações
    var resultadoFinal = [];
    try {
      if (result != null) {
        for (Result element in result) {
          String? html = element.html;

          if (html != null) {
            // capas
            final List<String> corteImagem1 = html.split('src="');
            final List<String> corteImagem2 =
                corteImagem1[1].split('" data-'); // imagem [0]
            final List<String> corteImagem3 =
                corteImagem1[1].split('">'); // imagem [0]
            late final String imagem;

            if (corteImagem2[0].contains('.jpg">') ||
                corteImagem2[0].contains('.jpeg">') ||
                corteImagem2[0].contains('.webp">') ||
                corteImagem2[0].contains('.png">')) {
              imagem = corteImagem3[0];
            } else {
              imagem = corteImagem2[0];
            }

            //link e nome
            final List<String> corteLinkAndNnome =
                html.split('" href="').reversed.toList();
            final List<String> corteLinkAndNnome2 =
                corteLinkAndNnome[0].split('">'); // link [0]
            // print("link: ${corteLinkAndNnome2[0]}");

            final List<String> corteNome =
                corteLinkAndNnome2[1].split('</a>'); // nome [0]

            List<String> corteUrl1 =
                corteLinkAndNnome2[0].split('manga/'); // posicao 1
            resultadoFinal.add({
              "name": corteNome[0],
              "url": corteUrl1[1].replaceFirst("/", ""),
              "img": imagem,
            });
          }
        }
      }
    } catch (e) {
      HomePageController.errorMessage = 'sesão de corte- ${e.toString()}';
      throw Error();
    }
    // print(resultadoFinal);
    // processar os dados para model
    List<Map> books1 = [];
    List<Map> books2 = [];
    List<Map> books3 = [];
    List<ModelHomePage> models = [];

    for (int i = 0; i < resultadoFinal.length; ++i) {
      if (i < 8) {
        books1.add(resultadoFinal[i]);
      } else if (i < 16) {
        books2.add(resultadoFinal[i]);
        //models.add(ModelHomePage.fromJson(map));
      } else {
        books3.add(resultadoFinal[i]);
        //models.add(ModelHomePage.fromJson(map));
      }
    }
    // montar os models
    Map<String, dynamic> lancamentos = {
      "idExtension": 1,
      "title": "Manga Yabu Lançamentos",
      "books": books1
    };
    Map<String, dynamic> populares = {
      "idExtension": 1,
      "title": "Manga Yabu Populares",
      "books": books2
    };
    Map<String, dynamic> atualizados = {
      "idExtension": 1,
      "title": "Manga Yabu Ultimos Atualizados",
      "books": books3
    };
    models.add(ModelHomePage.fromJson(lancamentos));
    models.add(ModelHomePage.fromJson(populares));
    models.add(ModelHomePage.fromJson(atualizados));

    return models;
  } catch (e) {
    debugPrint("erro em scrapingHomePage : $e");
    //HomePageController.errorMessage = e.toString();
    return [];
  }
}

Future<MangaInfoOffLineModel?> scrapingMangaDetail(String link) async {
  try {
    var parser = await Chaleno().load('https://mangayabu.top/manga/$link/');

    var dados = parser?.querySelector('script#manga-info').html.toString();

    String? state;
    if (dados != null) {
      // state - last update
      state = parser!.querySelector("span.last-updated").text;
      // estes recortam a parte em html
      List<String> corteHtml1 = dados.split('type="application/json">');
      List<String> corteHtml2 = corteHtml1[1].split('</script>');

      // faz um decode para json e processa os capitulos
      var decoded = json.decode(corteHtml2[0]);
      List capitulos = decoded['allposts'];
      // print("passou pelo model pt 1!");
      // print("------ capitulos -------------");
      // print(capitulos);
      List<Capitulos> listCapitulos = capitulos.map((element) {
        List<String> corteId = element['id'].split("ler/"); // id posição 1
        return Capitulos(
          id: corteId[1].replaceFirst("/", ""),
          capitulo: element['num'],
          description: element['date'],
          download: false,
          readed: false,
          disponivel: false,
          downloadPages: [],
          pages: [],
        );
      }).toList();
      // for (Capitulos cap in listCapitulos) {
      //   print(cap.id);
      // }
      debugPrint("passou pelo model!");
      return MangaInfoOffLineModel(
          name: decoded['chapter_name'],
          description: decoded['description'],
          img: decoded['cover'],
          authors: "Autor desconhecido",
          state: state ?? "Estado desconhecido",
          link: 'https://mangayabu.top/manga/$link/',
          idExtension: 1,
          genres: decoded['genres']
              .map<String>((dynamic genre) => genre.toString())
              .toList(),
          alternativeName: decoded['alternative_name'],
          chapters: decoded['chapters'],
          capitulos: listCapitulos);
    } else {
      debugPrint(
          "deu null no scrapingMangaDetail at extension/manga_yabu/scraping");
      return null;
    }
  } catch (e) {
    debugPrint("erro no scrapingMangaDetail at MangaYabu Extension: $e");
    return null;
  }
}

// ==========================================================================
//      ------------- SCRAPING LEITOR ---------------------
// ==========================================================================

Future<List<String>> scrapingLeitor(String id) async {
  try {
    Parser? parser = await Chaleno().load('https://mangayabu.top/ler/$id/');
    List<String> pages = [];
    if (parser != null) {
      List<Result>? itens =
          parser.querySelectorAll("div.table-of-contents > img");
      for (Result result in itens) {
        String? page = result.src;
        pages.add(page ??
            "https://cdn.hugocalixto.com.br/wp-content/uploads/sites/22/2020/07/error-404-1.png");
      }
    }
    return pages;
  } catch (e) {
    debugPrint("erro no scrapingLeitor at MangaYabu Extension: $e");
    return [];
  }
}
