import 'dart:convert';
// import 'dart:developer';

import 'package:chaleno/chaleno.dart';
import 'package:flutter/rendering.dart';

import '../../../models/home_page_model.dart';
import '../../../models/manga_info_offline_model.dart';
import '../../../controllers/home_page_controller.dart';

Future<List<ModelHomePage>> scrapingHomePage(int indiceCompute) async {
  const String url = 'https://yabutoons.com/';
  const String indentify = 'div.row > div.col > div.card';
  try {
    var parser = await Chaleno().load(url);
    var result = parser?.querySelectorAll(indentify);

    var lancamentos = [];
    try {
      if (result != null) {
        for (Result element in result) {
          // name
          String? name = element.querySelector("div.card-content > h4")!.text;
          debugPrint("name: $name");
          // img
          String? img =
              element.querySelector("div.card-image > a > div > img")!.src;
          debugPrint("img: $img");
          // link
          String? link = element.querySelector('div.card-image > a')!.href;
          //link e nome
          final List<String> corteLink = link!.split('toon/');
          final List<String> corteLink2 = corteLink[1].split('-capitulo');
          debugPrint("link: ${corteLink2[0]}");

          lancamentos.add({
            "name": name ?? "erro",
            "url": corteLink2[0],
            "img": img ?? "erro",
          });
        }
      }
    } catch (e) {
      HomePageController.errorMessage = 'sesão de corte- ${e.toString()}';
      debugPrint("erro nos lançamentos: $e");
      // throw Error();
    }

    /// ultimas atualizações
    List<Map> maisLidos = [];
    List<Result>? maisLidosResults =
        parser?.querySelectorAll("div.index > div.col > div.card");
    try {
      if (maisLidosResults != null) {
        for (Result element in maisLidosResults) {
          // img
          String? img =
              element.querySelector("a > div.card-image > img")!.src;
          debugPrint("img: $img");
          // link
          String? link = element.querySelector('a')!.href;
          //link e nome
          final List<String> corteLink = link!.split('toon/');
          debugPrint("link: ${corteLink[1]}");

          maisLidos.add({
            "name": corteLink[1].replaceFirst('/', ''),
            "url": corteLink[1].replaceFirst('/', ''),
            "img": img ?? "erro",
          });
        }
      }
    } catch (e) {
      HomePageController.errorMessage = 'sesão de corte- ${e.toString()}';
      debugPrint("erro nos lançamentos: $e");
      // throw Error();
    }

    /// montagem de models
    List<ModelHomePage> models = [];
    List<Map> lancamentosBooks = [];
    List<Map> ultimosBooks = [];
    for (int i = 0; i < lancamentos.length; ++i) {
      if (i < 18) {
        lancamentosBooks.add(lancamentos[i]);
      } else {
        ultimosBooks.add(lancamentos[i]);
      }
    }

    /// repartir os mangas

    // montar os models
    Map<String, dynamic> lancamentosData = {
      "idExtension": 12,
      "title": "Yabutoon Lançamentos",
      "books": lancamentosBooks
    };
    Map<String, dynamic> ultimosAtualizadosData = {
      "idExtension": 12,
      "title": "Yabutoon Ultimos atualizados",
      "books": ultimosBooks
    };
    Map<String, dynamic> maisLidosData = {
      "idExtension": 12,
      "title": "Yabutoon Mais lidos",
      "books": maisLidos
    };
    models.add(ModelHomePage.fromJson(lancamentosData));
    models.add(ModelHomePage.fromJson(ultimosAtualizadosData));
    models.add(ModelHomePage.fromJson(maisLidosData));

    return models;
  } catch (e) {
    debugPrint("erro em scrapingHomePage : $e");
    HomePageController.errorMessage = e.toString();
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
      late List<Capitulos> listCapitulos;

      // realiza a construção dos capitulos na nova ou antiga interface
      try {
        listCapitulos = capitulos.map((element) {
          List<String> corteId = element['chapters'][0]['id'].split("ler/");
          return Capitulos(
            id: corteId[1].replaceFirst("/", ""),
            capitulo: 'Capítulo ${element['num']}',
            description: element['chapters'][0]['date'],
            download: false,
            readed: false,
            mark: false,
            downloadPages: [],
            pages: [],
          );
        }).toList();
      } catch (e) {
        debugPrint("interface antiga!");
        listCapitulos = capitulos.map((element) {
          List<String> corteId = element['id'].split("ler/"); // id posição 1
          return Capitulos(
            id: corteId[1].replaceFirst("/", ""),
            capitulo: 'Capítulo ${element['num']}',
            description: element['date'],
            download: false,
            readed: false,
            mark: false,
            downloadPages: [],
            pages: [],
          );
        }).toList();
      }

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
