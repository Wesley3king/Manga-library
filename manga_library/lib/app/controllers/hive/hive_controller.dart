import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:manga_library/app/adapters/client_data_model_adapter.dart';
import 'package:manga_library/app/adapters/system_settings_model_adapter.dart';
import 'package:manga_library/app/models/client_data_model.dart';
import 'package:manga_library/app/models/downloads_pages_model.dart';
import 'package:manga_library/app/models/historic_model.dart';
import 'package:manga_library/app/models/home_page_model.dart';
import 'package:manga_library/app/models/libraries_model.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';
import 'package:manga_library/app/models/mark_chapter_model.dart';
import 'package:manga_library/app/models/system_settings.dart';

class HiveController {
  static Box? clientData;
  static Box? libraries;
  static LazyBox? books;
  static Box? historic;

  Future<void> start() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ClientDataModelHiveAdapter());
      Hive.registerAdapter(SystemSettingsModelHiveAdapter());
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
          lastUpdate: "${DateTime.now()}",
          isAdimin: true,
          capitulosLidos: [],
        );
      } else {
        return data;
      }
    } catch (e) {
      debugPrint('$e');
      return null;
    }
  }

  void writeClientData() {
    final ClientDataModel model = ClientDataModel(
      id: 1,
      name: 'King of Shadows',
      mail: 'king@mail.com',
      password: 'teste32#f',
      lastUpdate: "${DateTime.now()}",
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
    dynamic data;
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
      "books": []
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
  Future<SystemSettingsModel> writeSettings() async {
    // Map<String, dynamic> model = {
    //   "Ordenação": "oldtonew",
    //   "Tamanho dos quadros": "normal",
    //   "Atualizar": "0",
    //   "Atualizar as Capas": true,
    //   "Senha da Biblioteca Oculta": "0000",
    //   "Tema": "auto",
    //   "Cor da Interface": "blue",
    //   "Idioma": "ptbr",
    //   "Rolar a Barra": true,
    //   "Tipo do Leitor": "vertical",
    //   "Cor de fundo": "black",
    //   "Orientação do Leitor": "auto",
    //   "Qualidade": "medium",
    //   "Tela cheia": true,
    //   "Manter a tela ligada": false,
    //   "ShowControls": false,
    //   "Custom Shine": false,
    //   "Custom Shine Value": 0.5,
    //   "Custom Filter": false,
    //   "R": 0,
    //   "G": 0,
    //   "B": 0,
    //   "Black and White filter": false,
    //   "Layout": "bordersLTR",
    //   "ShowLayout": true,
    //   "ScrollWebtoon": 400,
    //   "Local de armazenamento": "intern",
    //   "Autenticação": false,
    //   "Tipo de Autenticação": "text",
    //   "Senha de Autenticação": "",
    //   "Multiplas Pesquisas": false,
    //   "Conteudo NSFW": false,
    //   "Mostrar na Lista": true,
    //   "Limpar o Cache": false,
    //   "Restaurar": false,
    // };
    SystemSettingsModel model = SystemSettingsModel(
        ordination: "oldtonew",
        frameSize: "normal",
        update: "0",
        updateTheCovers: true,
        hiddenLibraryPassword: '0000',
        theme: "auto",
        interfaceColor: "blue",
        language: "ptbr",
        rollTheBar: true,
        readerType: "vertical",
        backgroundColor: "black",
        readerGuidance: "auto",
        quality: "medium",
        fullScreen: true,
        keepScreenOn: false,
        showControls: false,
        customShine: false,
        customShineValue: 0.5,
        customFilter: false,
        R: 0,
        G: 0,
        B: 0,
        blackAndWhiteFilter: false,
        layout: "bordersLTR",
        showLayout: true,
        scrollWebtoon: 400,
        storageLocation: "externocult",
        authentication: false,
        authenticationType: "text",
        authenticationPassword: "",
        multipleSearches: false,
        nSFWContent: false,
        showNSFWInList: true,
        clearCache: false,
        restore: false);
    clientData?.put("settings", model);
    return model;
  }

  Future<SystemSettingsModel> getSettings() async {
    var data = await clientData?.get("settings");
    // debugPrint(data is Map<String, dynamic>
    //     ? "é Map<String, dynamic>"
    //     : "não é Map<String, dynamic>");
    if (data != null) {
      return data;
    } else {
      return await writeSettings();
    }
  }

  Future<bool> updateSettings(SystemSettingsModel data) async {
    try {
      await clientData?.put("settings", data);

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
        // debugPrint(" - dados do Hive:");
        // debugPrint('$data');
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
      List<Map<String, dynamic>> data =
          models.map<Map<String, dynamic>>((model) => model.toJson()).toList();
      await historic?.put('historic', data);
      return true;
    } catch (e) {
      debugPrint("erro no updateHistoric at HiveController: $e");
      return false;
    }
  }

  Future<List<HistoricModel>> getHistoric() async {
    try {
      var data = await historic?.get('historic');
      if (data == null) {
        await writeHistoric();
        return [];
      }
      List<dynamic>? lista = List.from(data);
      List<Map<String, dynamic>> maps =
          lista.map((e) => Map<String, dynamic>.from(e)).toList();
      return maps.map((json) => HistoricModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("erro no getHistoric at HiveController: $e");
      return [];
    }
  }

  // ==========================================================================
  //        ------------------- DOWNLOADS -----------------------------
  // ==========================================================================

  final String downloadKey = "downloads";

  /// escreve a base dos downloads no banco
  void writeDownloads() {
    final List<Map<String, dynamic>> lista = [];
    clientData?.put(downloadKey, lista);
  }

  Future<List<DownloadPagesModel>> getDownloads() async {
    try {
      List<dynamic>? data = await clientData?.get(downloadKey);
      if (data != null) {
        List<Map<String, dynamic>> listOfMaps = List<Map<String, dynamic>>.from(
            data.map<Map<String, dynamic>>((e) => Map.from(e)).toList());
        // debugPrint('data DOWNLOADS: $listOfMaps');aaasa
        return listOfMaps
            .map((Map<String, dynamic> json) =>
                DownloadPagesModel.fromJson(json))
            .toList();
      } else {
        writeDownloads();
        return [];
      }
    } catch (e) {
      debugPrint("erro no getDownloads at HiveController: $e");
      return [];
    }
  }

  Future<bool> updateDownloads(List<DownloadPagesModel> models) async {
    try {
      List<Map<String, dynamic>> data =
          models.map<Map<String, dynamic>>((model) => model.toJson()).toList();
      await clientData?.put(downloadKey, data);
      return true;
    } catch (e) {
      debugPrint("erro no updateDownloads at HiveController: $e");
      return false;
    }
  }

  // =========================================================================
  //                ---- -- MARKS ON CHAPTERS -- ----
  // =========================================================================
  final marksKey = "marks";

  List<MarkChaptersModel> writeMarks() {
    List<MarkChaptersModel> models = [];
    try {
      clientData?.put(marksKey, models);
    } catch (e) {
      debugPrint("ERRO no writeMarks at HiveController: $e");
    }
    return models;
  }

  Future<bool> updateMarks(List<MarkChaptersModel> models) async {
    try {
      List<Map<String, dynamic>> processedModels =
          models.map<Map<String, dynamic>>((model) => model.toJson()).toList();
      await clientData?.put(marksKey, processedModels);
      return true;
    } catch (e) {
      debugPrint("erro no updateMarks at HiveController: $e");
      return false;
    }
  }

  Future<List<MarkChaptersModel>> getMarks() async {
    try {
      List<dynamic>? data = clientData?.get(marksKey);
      if (data == null) {
        return writeMarks();
      }
      return data.map<MarkChaptersModel>((e) {
        final Map<String, dynamic> model = Map<String, dynamic>.from(e);
        return MarkChaptersModel.fromJson(model);
      }).toList();
    } catch (e) {
      debugPrint("erro no getMarks at HiveController: $e");
      return [];
    }
  }
}
