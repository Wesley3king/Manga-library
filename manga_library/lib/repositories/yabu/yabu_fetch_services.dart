import 'package:dio/dio.dart';
import 'package:manga_library/app/models/leitor_model.dart';

class YabuFetchServices {
  final Dio dio = Dio(BaseOptions(
    connectTimeout: 40000,
    sendTimeout: 40000,
  ));

  Future<List<ModelLeitor>?> fetchCapitulos(String url) async {
    try {
      var data = await dio.post('https://vast-falls-98079.herokuapp.com/manga',
          data: {"url": 'https://mangayabu.top/manga/$url/'});

      var dadosManga = data.data as Map<String, dynamic>;
      print('entrou');
      List<ModelLeitor> listaCapitulos = dadosManga['data']['capitulos']
          .map<ModelLeitor>((lista) => ModelLeitor.fromJson(lista))
          .toList();
      print('passou');


      return listaCapitulos;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
