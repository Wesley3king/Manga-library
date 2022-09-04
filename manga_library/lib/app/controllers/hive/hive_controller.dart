import 'package:hive/hive.dart';
import 'package:manga_library/app/adapters/client_data_model_adapter.dart';
import 'package:manga_library/app/models/client_data_model.dart';
import 'package:manga_library/app/models/libraries_model.dart';

class HiveController {
  static Box? clientData;
  static Box? libraries;

  Future<void> start() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ClientDataModelHiveAdapter());
    }
    clientData = await Hive.openBox('clientData');
    libraries = await Hive.openBox('libraries');
  }

  void end() {
    clientData?.close();
  }

  Future<dynamic> getClientData() async {
    try {
      ClientDataModel? data = await clientData?.get('clientAllData');
      if (data == null) {
        writeClientData();
        return ClientDataModel(
          id: 1,
          name: 'King of Shadows',
          mail: 'king@mail.com',
          password: 'teste32#f',
          isAdimin: true,
          favoritos: [],
          capitulosLidos: [],
        );
      } else {
        return data;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  void writeClientData() {
    final ClientDataModel model = ClientDataModel(
      id: 1,
      name: 'King of Shadows',
      mail: 'king@mail.com',
      password: 'teste32#f',
      isAdimin: true,
      favoritos: [],
      capitulosLidos: [],
    );

    clientData?.put('clientAllData', model);
  }

  Future<bool> updateClientData(ClientDataModel data) async {
    try {
      await clientData?.put('clientAllData', data);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // library
  Future<List<LibraryModel>> writeLibraryData() async {
    final LibraryModel model = LibraryModel.fromJson({
      "library": "favoritos",
      "books": [
        {
          "name": "Kawaii Dake ja Nai Shikimori-san",
          "link":
              "https://mangayabu.top/manga/kawaii-dake-ja-nai-shikimori-san/",
          "img":
              "https://mangayabu.top/wp-content/uploads/2022/07/f0037b59a279112676b9.jpg"
        },
        {
          "name": "Boku no Hero Academia",
          "link": "https://mangayabu.top/manga/boku-no-hero-academia/",
          "img":
              "https://mangayabu.top/wp-content/uploads/2022/06/0cb2e604c5c9900bacb7.jpg"
        },
        {
          "name": "Mushoku Tensei: Isekai Ittara Honki Dasu",
          "link":
              "https://mangayabu.top/manga/mushoku-tensei-isekai-ittara-honki-dasu/",
          "img":
              "https://mangayabu.top/wp-content/uploads/2022/07/97cf1278675bc2fd52b3.jpg"
        },
      ]
    });
    libraries?.put('libraries', [model.toJson()]);
    return [model];
  }

  Future<List<LibraryModel>> getLibraries() async {
    List<dynamic>? data = await libraries?.get('libraries');
    print(data);
    if (data != null) {
      print('entrou na converção');
      List<LibraryModel> librariesModels = [];
      try {
        librariesModels = data.map((e) {
          Map<String, dynamic> map = {
            "library": e['library'],
            "books": e['books'],
          };
          return LibraryModel.fromJson(map);
        }).toList();
      } catch (e, s) {
        print(e);
        print(s);
      }
      print('saiu da converção');

      return librariesModels;
    } else {
      print('não é uma lista \n em HiveController - getLibraries');
      print(data.runtimeType);
      return writeLibraryData();
    }
  }

  Future<bool> updateLibraries(List<LibraryModel> listModel) async {
    try {
      List<Map<String, dynamic>> data =
          listModel.map((model) => model.toJson()).toList();
      await libraries?.put('libraries', data);
      return true;
    } catch (e) {
      print('erro no updateLibraries: $e');
      return false;
    }
  }
}
