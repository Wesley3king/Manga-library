import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
// import 'package:manga_library/app/models/leitor_pages.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

class YabuFetchServices {
  final Dio dio = Dio(BaseOptions(
    connectTimeout: 40000,
    sendTimeout: 40000,
  ));
  
  Future<List<Capitulos>?> fetchCapitulos(String url) async {
    try {
      var data = await dio.post('https://vast-falls-98079.herokuapp.com/manga',
          data: {"url": 'https://mangayabu.top/manga/$url'});

      var dadosManga = data.data as Map<String, dynamic>;
      List<Capitulos> listaCapitulos = dadosManga['data']['capitulos']
          .map<Capitulos>((dynamic lista) {
             List<String> corte = lista[0].split('#');
            return Capitulos(
              id: lista[1],
              capitulo: corte[1],
              pages: lista[4].map<String>((dynamic str)=> str.toString()).toList(),
              disponivel: true,
              readed: false,
              download: false,
              downloadPages: [],
            );
          })
          .toList();

      return listaCapitulos;
    } catch (e) {
      debugPrint('$e');
      return null;
    }
  }

  Future<Map<String, dynamic>> search(String txt) async {
    try {
      var data = await dio.post('https://vast-falls-98079.herokuapp.com/search',
          data: {"txt": txt});
      return {
        "font": "MangaYabu",
        "data": data.data['data'],
      };
    } catch (e, s) {
      print('error no search! $e');
      print(s);
      return {
        "font": "MangaYabu",
        "data": [],
      };
    }
  }

  Future<Map<String, dynamic>> searchNewBook(String txt) async {
    try {
      var serverLink =
          await dio.get('https://vast-falls-98079.herokuapp.com/server');
      String url = serverLink.data['url'];
      var data = await dio.post('$url/pesquisar', data: {"nome": txt});
      // formatar a imagem:
      var formatedData = data.data['dadosNovos'].map((list) {
        var corte1 = list[1].replaceFirst('")', '');
        var img = corte1.replaceFirst('url("', '');

        return {
          "nome": list[0],
          "capa1": img,
          "link": list[2],
        };
      }).toList();
      return {
        "font": "MangaYabu Undisponible",
        "data": formatedData,
      };
    } catch (e, s) {
      print('error no search! $e');
      print(s);
      return {
        "font": "MangaYabu Undisponible",
        "data": [],
      };
    }
  }

  Future<dynamic> addOrUpdateBook(Map<String, String> book) async {
    try {
      var data = await dio.get('https://vast-falls-98079.herokuapp.com/server');
      String url = data.data['url'];
      print(url);
      var response = await dio.post('$url/adicionar',
          data: {"nome": book['name'], "link": book['link']});

      return response;
    } catch (e) {
      print('erro no MangaYabu fetch services - addOrUpdate : $e');
    }
  }
}
