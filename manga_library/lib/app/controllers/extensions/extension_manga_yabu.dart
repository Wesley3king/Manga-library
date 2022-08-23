import 'dart:convert';
import 'dart:developer';

import 'package:chaleno/chaleno.dart';
import 'package:manga_library/app/models/manga_info_model.dart';

class ExtensionMangaYabu {
  homePage() async {
    const String url = 'https://mangayabu.top/';
    const String indentify = '.manga-card';
    try {
      var parser = await Chaleno().load(url);

      var result = parser?.querySelectorAll(indentify);
      // retirar as scans
      for (int i = 0; i < 20; ++i) {
        result?.removeLast();
      }

      // aqui será feito o tratamento das informações
      var resultadoFinal = [];
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
            final List<String> corteNome =
                corteLinkAndNnome2[1].split('</a>'); // nome [0]

            resultadoFinal.add({
              "name": corteNome[0],
              "url": corteLinkAndNnome2[0],
              "img": imagem,
            });
          }
        }
      }

      return resultadoFinal;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Future<ModelMangaInfo?> mangaInfo(String link) async {
    try {
        var parser = await Chaleno().load('https://mangayabu.top/manga/$link/');

        var dados = parser?.querySelector('script#manga-info').html.toString();

        if (dados != null) {
          // estes recortam a parte em html
          List<String> corteHtml1 = dados.split('type="application/json">');
          List<String> corteHtml2 = corteHtml1[1].split('</script>');

          // faz um decode para json e processa os capitulos
          var decoded = json.decode(corteHtml2[0]);
          List capitulos = decoded['allposts'];
          List<Allposts> capitulosAllposts = capitulos
              .map(
                (element) => Allposts.fromJson(element),
              )
              .toList();

          return ModelMangaInfo(
            chapterName: decoded['chapter_name'],
            chapters: decoded['chapters'],
            description: decoded['description'],
            cover: decoded['cover'],
            genres: decoded['genres'],
            chapterList: decoded['chapter_list'],
            alternativeName: decoded['alternative_name'],
            allposts: capitulosAllposts,
          );
        }
      } catch (e) {
        print(e);
        return null;
      }
  }
}
