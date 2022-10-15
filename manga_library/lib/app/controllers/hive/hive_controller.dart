import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:manga_library/app/adapters/client_data_model_adapter.dart';
import 'package:manga_library/app/models/client_data_model.dart';
import 'package:manga_library/app/models/historic_model.dart';
import 'package:manga_library/app/models/home_page_model.dart';
import 'package:manga_library/app/models/libraries_model.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

class HiveController {
  static Box? clientData;
  static Box? libraries;
  static LazyBox? books;
  static Box? historic;

  Future<void> start() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ClientDataModelHiveAdapter());
    }
    debugPrint("hive enabled");
    clientData = await Hive.openBox('clientData');
    libraries = await Hive.openBox('libraries');
    historic = await Hive.openBox('historic');
    books = await Hive.openLazyBox('books');
  }

  // void end() {
  //   clientData?.close();
  //   libraries?.close();
  //   books?.close();
  // }

  // ---------------------------------------------------------------------------
  //      ======================= CLIENT DATA =======================
  // ---------------------------------------------------------------------------
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
      capitulosLidos: [],
    );

    clientData?.put('clientAllData', model);
  }

  Future<bool> updateClientData(ClientDataModel data) async {
    try {
      await clientData?.put('clientAllData', data);
      return true;
    } catch (e) {
      debugPrint('$e');
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  //       ======================= HOME PAGE =======================
  // ---------------------------------------------------------------------------

  Future<List<ModelHomePage>?> getHomePage() async {
    var data;
    try {
      // print("box: $clientData");
      data = await clientData?.get("homePage") as List<dynamic>;
      List<ModelHomePage> encodedData =
          data.map<ModelHomePage>((dynamic model) {
        Map<String, dynamic> map = Map<String, dynamic>.from(model);
        return ModelHomePage.fromJson(map);
      }).toList();
      return encodedData;
    } catch (e) {
      debugPrint("erro no getHomePage at HiveController: $e");
      return null;
    }
  }

  Future<bool> updateHomePage(List<ModelHomePage> models) async {
    try {
      List<Map<String, dynamic>> decodedModels =
          models.map((ModelHomePage model) => model.toJson()).toList();
      await clientData?.put("homePage", decodedModels);
      return true;
    } catch (e) {
      debugPrint("erro no updateHomePage at HiveController: $e");
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  //       ======================= LIBRARIES =======================
  // ---------------------------------------------------------------------------
  Future<List<LibraryModel>> writeLibraryData() async {
    final LibraryModel model = LibraryModel.fromJson({
      "library": "favoritos",
      "books": [
        // {
        //   "name": "Kawaii Dake ja Nai Shikimori-san",
        //   "link": "kawaii-dake-ja-nai-shikimori-san",
        //   "img":
        //       "https://mangayabu.top/wp-content/uploads/2022/07/f0037b59a279112676b9.jpg",
        //   "idExtension": 1
        // },
        // {
        //   "name": "Boku no Hero Academia",
        //   "link": "boku-no-hero-academia",
        //   "img":
        //       "https://mangayabu.top/wp-content/uploads/2022/06/0cb2e604c5c9900bacb7.jpg",
        //   "idExtension": 1
        // },
        // {
        //   "name": "Mushoku Tensei: Isekai Ittara Honki Dasu",
        //   "link": "mushoku-tensei-isekai-ittara-honki-dasu",
        //   "img":
        //       "https://mangayabu.top/wp-content/uploads/2022/07/97cf1278675bc2fd52b3.jpg",
        //   "idExtension": 1
        // },
      ]
    });
    libraries?.put('libraries', [model.toJson()]);
    return [model];
  }

  Future<List<LibraryModel>> getLibraries() async {
    List<dynamic>? data = await libraries?.get('libraries');
    debugPrint('$data');
    if (data != null) {
      debugPrint('entrou na converção');
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
        debugPrint('$e');
        debugPrint('$s');
      }
      debugPrint('saiu da converção');

      return librariesModels;
    } else {
      debugPrint('é null em HiveController - getLibraries');
      debugPrint('${data.runtimeType}');
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
      debugPrint('erro no updateLibraries: $e');
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  //       ======================= OCULT LIBRARIES =======================
  // ---------------------------------------------------------------------------
  final String ocultLibrary = "ocultLibraries";

  Future<List<LibraryModel>> writeOcultLibraryData() async {
    debugPrint("escrevendo o model inicial na DB!");
    final LibraryModel model =
        LibraryModel.fromJson({"library": "ocultos", "books": []});
    libraries?.put(ocultLibrary, [model.toJson()]);
    return [model];
  }

  Future<List<LibraryModel>> getOcultLibraries() async {
    List<dynamic>? data = await libraries?.get(ocultLibrary);
    debugPrint('data from ocult library: $data');
    if (data != null) {
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
        debugPrint("$e");
        debugPrint('$s');
      }
      debugPrint('saiu da converção');

      return librariesModels;
    } else {
      debugPrint('é null em HiveController - getOcultLibraries');
      // debugPrint('${data.runtimeType}');
      return await writeOcultLibraryData();
    }
  }

  Future<bool> updateOcultLibraries(List<LibraryModel> listModel) async {
    try {
      List<Map<String, dynamic>> data =
          listModel.map((model) => model.toJson()).toList();
      await libraries?.put(ocultLibrary, data);
      return true;
    } catch (e) {
      debugPrint('erro no updateOcultLibraries: $e');
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  //       ======================= SETTINGS =======================
  // ---------------------------------------------------------------------------
  Future<Map<String, dynamic>> writeSettings() async {
    Map<String, dynamic> model = {
      "Ordenação": "oldtonew",
      "Tamanho dos quadros": "normal",
      "Atualizar as Capas": false,
      "Tema": "auto",
      "Cor da Interface": "blue",
      "Idioma": "ptbr",
      "Rolar a Barra": true,
      "Tipo do Leitor": "vertical",
      "Cor de fundo": "black",
      "Orientação do Leitor": "auto",
      "Qualidade": "medium",
      "Tela cheia": true,
      "Local de armazenamento": "intern",
      "Autenticação": false,
      "Tipo de Autenticação": "text",
      "Senha de Autenticação": "",
      "Multiplas Pesquisas": false,
      "Conteudo NSFW": false,
      "Mostrar na Lista": true,
      "Limpar o Cache": false,
      "Restaurar": false,
    };
    clientData?.put("settings", model);
    return model;
  }

  Future<Map> getSettings() async {
    var data = await clientData?.get("settings");
    debugPrint(data is Map<String, dynamic>
        ? "é Map<String, dynamic>"
        : "não é Map<String, dynamic>");
    if (data != null && data is Map) {
      return data;
    } else {
      return await writeSettings();
    }
  }

  Future<bool> updateSettings(Map data) async {
    try {
      debugPrint('${data['Tema']}');
      await clientData?.put("settings", data);
      // var data2 = await clientData?.get("settings");
      // print(data2);
      return true;
    } catch (e) {
      debugPrint('erro no HiveController - updateSettings: $e');
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  //  ====================== OffLine database operations =======================
  // ---------------------------------------------------------------------------

  Future<bool> writeBook() async {
    try {
      await books?.put("allbooks", []);
      return true;
    } catch (e) {
      debugPrint('erro no writeBook, at HiveController: $e');
      return false;
    }
  }

  Future<bool> updateBook(List<MangaInfoOffLineModel> data) async {
    try {
      List<Map<String, dynamic>> jsonModel =
          data.map((model) => model.toJson()).toList();
      await books?.put("allbooks", jsonModel);
      return true;
    } catch (e) {
      debugPrint('erro no updateBook, at HiveController: $e');
      return false;
    }
  }

  Future<List<MangaInfoOffLineModel>?> getBooks() async {
    try {
      List<dynamic>? data = await books?.get("allbooks");
      if (data == null) {
        writeBook();
        return [];
      } else {
        debugPrint(" - dados do Hive:");
        debugPrint('$data');
        return data
            .map((book) => MangaInfoOffLineModel.fromJson(book))
            .toList();
      }
    } catch (e) {
      debugPrint('erro no getBooks, at HiveController: $e');
      return null;
    }
  }

  // ==========================================================================
  //      ---------------------- HISTORIC --------------------------------
  // ==========================================================================

  Future<bool> writeHistoric() async {
    try {
      await historic?.put('historic', []);
      return true;
    } catch (e) {
      debugPrint("erro no writeHistoric at HiveController: $e");
      return false;
    }
  }

  Future<bool> updateHistoric(List<HistoricModel> models) async {
    try {
      List<Map<String, dynamic>> data = models.map<Map<String, dynamic>>((model) => model.toJson()).toList();
      await historic?.put('historic', data);
      return true;
    } catch (e) {
      debugPrint("erro no updateHistoric at HiveController: $e");
      return false;
    }
  }

  Future<List<HistoricModel>> getHistoric() async {
    try {
      List<Map<String, dynamic>> data =await historic?.get('historic');
      return data.map((json) => HistoricModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("erro no updateHistoric at HiveController: $e");
      return [];
    }
  }
}
