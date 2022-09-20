import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/models/leitor_pages.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';
import 'package:manga_library/repositories/yabu/yabu_fetch_services.dart';

void main() async {
  var yabuFtechServices = YabuFetchServices();
  
  test('deve retornar uma lista de capitulos', () async {
    final List<Capitulos>? response =
        await yabuFtechServices.fetchCapitulos('solo-leveling');

    if (response != null) {
      print(response[0].capitulo);
    }
    //expect(response != null, true);
  });

  // testa a função de pesquisa
  test("deve retornar um map com os dados do manga", () async {
    Map<String, dynamic> valor = await yabuFtechServices.search("one");
    print("resultado: ");
    print(valor);
    print("fim valor ---------");
    expect(valor['data'].length != 0, true);
  });

  test('deve setornar true para adicionar/atualizar o manga', () async {
    var data = await yabuFtechServices.addOrUpdateBook(
        {"name": "Eleceed", "link": "https://mangayabu.top/manga/eleceed/"});
    print(data);
  });

  test('deve retornar um map com os mangas disponiveis', () async {
    var response = await yabuFtechServices.searchNewBook('tail');
    print(response['data'][0]);
  });
}
