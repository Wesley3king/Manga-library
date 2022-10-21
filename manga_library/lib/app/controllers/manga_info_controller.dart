import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/extensions/extensions.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/controllers/off_line/manga_info_off_line.dart';
import 'package:manga_library/app/models/client_data_model.dart';
import 'package:manga_library/app/models/globais.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';
// import 'package:manga_library/repositories/yabu/yabu_fetch_services.dart';

// import '../models/leitor_pages.dart';
import '../models/libraries_model.dart';
// import 'extensions/extension_manga_yabu.dart';
// import 'extensions/manga_yabu/extension_yabu.dart';
import 'home_page_controller.dart';

class MangaInfoController {
  // final mangaYabu = ExtensionMangaYabu();
  final MangaInfoOffLineController _mangaInfoOffLineController =
      MangaInfoOffLineController();
  // final YabuFetchServices yabuFetchServices = YabuFetchServices();
  static ChaptersController? chaptersController;
  // final ChaptersController _chaptersController = ChaptersController();

  MangaInfoOffLineModel data = MangaInfoOffLineModel(
    name: "",
    authors: "",
    state: "",
    description: "",
    img: "",
    link: "",
    idExtension: 0,
    genres: [],
    alternativeName: false,
    chapters: 0,
    capitulos: [],
  );
  List<Capitulos>? capitulosDisponiveis = [];
  static bool isAnOffLineBook = false;
  static bool isTwoRequests = false;
  ValueNotifier<MangaInfoStates> state =
      ValueNotifier<MangaInfoStates>(MangaInfoStates.start);

  Future start(String url, int idExtension) async {
    state.value = MangaInfoStates.loading;
    try {
      // operação OffLine
      MangaInfoOffLineModel? localData =
          await _mangaInfoOffLineController.verifyDatabase(url, idExtension);
      if (localData != null) {
        print("existe na base de dados! / l= $url");
        // testa para definir isTwoRequests
        isTwoRequests = mapOfExtensions[idExtension]!.isTwoRequests;

        data = localData;
        capitulosDisponiveis = localData.capitulos;

        log("at offline start length: ${capitulosDisponiveis!.length}");
        GlobalData.capitulosDisponiveis =
            List.unmodifiable(capitulosDisponiveis ?? []);
        isAnOffLineBook = true;
        // await _chaptersController.correlacionarCapitulos(
        //     capitulosDisponiveis ?? [], data.capitulos, url
        // );
        state.value = MangaInfoStates.sucess2;
      } else {
        // operação OnLine
        print("iniciando o fetch! / l= $url");

        // identificar se a extensão trabalha em duas requisições
        final MangaInfoOffLineModel? dados;
        isTwoRequests = mapOfExtensions[idExtension]!.isTwoRequests;
        if (isTwoRequests) {
          dados = await mapOfExtensions[idExtension]!.mangaDetail(url);
          if (dados != null) {
            data = dados;
            state.value = MangaInfoStates.sucess1;
          } else {
            state.value = MangaInfoStates.error;
          }
          capitulosDisponiveis =
              await fetchServiceExtensions[idExtension].fetchChapters(url);
          //log("at online start: ${capitulosDisponiveis!.length}");
        } else {
          dados = await mapOfExtensions[idExtension]!.mangaDetail(url);
          if (dados != null) {
            data = dados;
            capitulosDisponiveis = data.capitulos;
            state.value = MangaInfoStates.sucess1;
          } else {
            state.value = MangaInfoStates.error;
          }
        }

        // log("at online start: ${capitulosDisponiveis!.length}");
        GlobalData.capitulosDisponiveis =
            List.unmodifiable(capitulosDisponiveis ?? []);

        isAnOffLineBook = false;
        if (state.value != MangaInfoStates.error) {
          state.value = MangaInfoStates.sucess2;
        } else {
          HomePageController.errorMessage = 'erro no null 2';
          state.value = MangaInfoStates.error;
        }
      }
    } catch (e) {
      print(e);
      HomePageController.errorMessage = 'erro no MangaInfo: $e';
      state.value = MangaInfoStates.error;
    }
  }

  Future updateBook(String url, int idExtension) async {
    try {
      print("l= $url  - atualizando...");

      final MangaInfoOffLineModel? dados =
          await mapOfExtensions[idExtension]!.mangaDetail(url);

      if (dados != null) {
        data = dados;
      } else {
        state.value = MangaInfoStates.error;
      }

      if (isAnOffLineBook) {
        // is an off line book
        if (mapOfExtensions[idExtension]!.isTwoRequests) {
          /// isTwoRequests
          capitulosDisponiveis =
              await fetchServiceExtensions[idExtension].fetchChapters(url);
        } else {
          /// isn't TwoRequests
          capitulosDisponiveis = dados?.capitulos ?? [];
          debugPrint("nao é twoRequests: $capitulosDisponiveis");
        }

        List<Capitulos> capitulosFromOriginalServer =
            dados == null ? [] : dados.capitulos;
        if (dados == null) {
          print("dd off-line true");
          capitulosFromOriginalServer = [];
        } else {
          print("dd off-line false");
          capitulosFromOriginalServer = dados.capitulos;
        }
        // mapOfExtensions[idExtension].isTwoRequests;
        await chaptersController?.update(capitulosDisponiveis,
            capitulosFromOriginalServer, url, idExtension);

        final MangaInfoOffLineController mangaInfoOffLineController =
            MangaInfoOffLineController();
        debugPrint("inserindo na base de dados!");
        await mangaInfoOffLineController.updateBook(
            model: data,
            capitulos: ChaptersController.capitulosCorrelacionados);
        debugPrint("inserindo com SUCESSO na base de dados!");
      } else {
        // isn't an off ine book
        if (mapOfExtensions[idExtension]!.isTwoRequests) {
          /// isTwoRequests
          capitulosDisponiveis =
              await fetchServiceExtensions[idExtension].fetchChapters(url);
        } else {
          /// isn't TwoRequests
          capitulosDisponiveis = dados?.capitulos ?? [];
          debugPrint("nao é twoRequests: $capitulosDisponiveis");
        }

        List<Capitulos> capitulosFromOriginalServer =
            dados == null ? [] : dados.capitulos;
        if (dados == null) {
          print("dd true");
          capitulosFromOriginalServer = [];
        } else {
          print("dd false");
          capitulosFromOriginalServer = dados.capitulos;
        }

        await chaptersController?.update(capitulosDisponiveis,
            capitulosFromOriginalServer, url, idExtension);
      }
      state.value = MangaInfoStates.sucess1;
      // aqui deve atualizar a view totalmente
      state.value = MangaInfoStates.sucess2;
    } catch (e) {
      print("erro no update book at mangaInfoController: $e");
      state.value = MangaInfoStates.error;
    }
  }

  void updateChaptersAfterDownload(String url, int idExtension) async {
    try {
      MangaInfoOffLineModel? localData =
          await _mangaInfoOffLineController.verifyDatabase(url, idExtension);
      if (localData != null) {
        //print("existe na base de dados! / l= $url");
        data = localData;
        capitulosDisponiveis = localData.capitulos;
        GlobalData.capitulosDisponiveis =
            List.unmodifiable(capitulosDisponiveis ?? []);
        await chaptersController?.updateChapters(capitulosDisponiveis, url, idExtension);
      }
    } catch (e) {
      debugPrint(
          "erro no updateChaptersAfterDownload at MangaInfoController: $e");
    }
  }

  /// função de adicionar ou atualizar para adiministradores
  addOrUpdateBook(
      {required String name,
      required String link,
      required int idExtension}) async {
    try {
      //await mapOfExtensions[idExtension].addOrUpdateBook({"name": name, "link": link});
    } catch (e) {
      debugPrint("erro no addOrUpdateBook at MangaDetail: $e");
    }
  }
}

enum MangaInfoStates { start, loading, sucess1, sucess2, error }

/// controller dos capitulos
class ChaptersController {
  final HiveController _hiveController = HiveController();

  ValueNotifier<ChaptersStates> state =
      ValueNotifier<ChaptersStates>(ChaptersStates.start);
  static List<Capitulos> capitulosCorrelacionados = [];

  start(List<Capitulos>? listaCapitulosDisponiveis,
      List<Capitulos> listaCapitulos, String link, int idExtension) async {
    state.value = ChaptersStates.loading;
    // GlobalData.capitulosDisponiveis;
    try {
      print(
          'start // link: $link // ${listaCapitulosDisponiveis?.length} // ${listaCapitulos.length}');
      print("chapter offline: ${MangaInfoController.isAnOffLineBook}");
      if (MangaInfoController.isAnOffLineBook) {
        capitulosCorrelacionados = listaCapitulos;
        await updateChapters(
            listaCapitulosDisponiveis, link, idExtension); // , listaCapitulos

      } else {
        if (MangaInfoController.isTwoRequests) {
          await correlacionarCapitulos(
              listaCapitulosDisponiveis ?? [], listaCapitulos, link,
              idExtension: idExtension);
        } else {
          print("isn't twoRequests");
          capitulosCorrelacionados = listaCapitulos;
          await updateChapters(listaCapitulosDisponiveis, link, idExtension);
        }
      }
      // disponibilizar os capitulos correlacionados

      // MangaInfoController.capitulosCorrelacionados = capitulosCorrelacionados;
      // GlobalData.capitulosDisponiveis;
      // print("");
      state.value = ChaptersStates.sucess;
    } catch (e) {
      HomePageController.errorMessage = 'erro no catch ChapterController: $e';
      print('erro no start ChapterController');
      print(e);
      state.value = ChaptersStates.error;
    }
  }

  Future<bool> update(List<Capitulos>? listaCapitulosDisponiveis,
      List<Capitulos> listaCapitulos, String link, int idExtension) async {
    try {
      // print("chapter offline: ${MangaInfoController.isAnOffLineBook}");
      // if (MangaInfoController.isAnOffLineBook) {
      //   print("preparando para iniciar o correlacionamento!!!");
      //   await correlacionarCapitulos(
      //       listaCapitulosDisponiveis ?? [], listaCapitulos, link);
      // } else {
      //   await correlacionarCapitulos(
      //       listaCapitulosDisponiveis ?? [], listaCapitulos, link);
      // }
      log("update is two: ${MangaInfoController.isTwoRequests}");
      if (MangaInfoController.isTwoRequests) {
        // passar os downloads aos novos capitulos
        for (Capitulos capCorrelacionados in capitulosCorrelacionados) {
          if (capCorrelacionados.download) {
            for (int i = 0; i < listaCapitulosDisponiveis!.length; ++i) {
              if (listaCapitulosDisponiveis[i].id == capCorrelacionados.id) {
                debugPrint("capitulo com download disponivel!");
                listaCapitulosDisponiveis[i].download = true;
                listaCapitulosDisponiveis[i].downloadPages =
                    capCorrelacionados.downloadPages;
                // ok
                break;
              }
            }
          }
        }
        log("off line twoRequests ok pt1");
        await correlacionarCapitulos(
            listaCapitulosDisponiveis ?? [], listaCapitulos, link,
            isAnUpdate: true, idExtension: idExtension);
        log("off line twoRequests ok pt2");
      } else {
        for (Capitulos capCorrelacionados in capitulosCorrelacionados) {
          if (capCorrelacionados.download) {
            for (int i = 0; i < listaCapitulosDisponiveis!.length; ++i) {
              if (listaCapitulosDisponiveis[i].id == capCorrelacionados.id) {
                debugPrint("capitulo com download disponivel!");
                listaCapitulosDisponiveis[i].download = true;
                listaCapitulosDisponiveis[i].downloadPages =
                    capCorrelacionados.downloadPages;
                // ok
                break;
              }
            }
          }
        }
        capitulosCorrelacionados = listaCapitulosDisponiveis ?? [];
        await updateChapters(listaCapitulosDisponiveis, link, idExtension);
      }
      state.value = ChaptersStates.loading;
      log("atualizando a view!");
      // print(capitulosCorrelacionados);
      state.value = ChaptersStates.sucess;
      return true;
    } catch (e) {
      // HomePageController.errorMessage =
      //     'erro no update at ChapterController: $e';
      debugPrint('erro no update ChapterController');
      debugPrint('$e');
      state.value = ChaptersStates.error;
      return false;
    }
  }

  updateChapters(
    List<Capitulos>? listaCapitulosDisponiveis,
    //List<Capitulos> listaCapitulos,
    String link,
    int idExtension
  ) async {
    state.value = ChaptersStates.loading;
    try {
      debugPrint('update chapters');
      // conseguir os dados
      ClientDataModel clientData = await _hiveController.getClientData();
      // achar os capitulos lidos do manga pelo link
      List<dynamic> capitulosLidos = [];
      String completUrl = mapOfExtensions[idExtension]!.getLink(link);
      RegExp regex = RegExp(completUrl, dotAll: true, caseSensitive: false);

      for (int i = 0; i < clientData.capitulosLidos.length; ++i) {
        if (clientData.capitulosLidos[i]['link'].contains(regex)) {
          capitulosLidos = clientData.capitulosLidos[i]['capitulos'];
        }
      }
      debugPrint('$capitulosLidos');
      // await correlacionarCapitulos(
      //     listaCapitulosDisponiveis ?? [], listaCapitulos, link);
      // faz o recorrelacionamento
      //  if (capitulosLidos.isNotEmpty) {
      // print('inicio = ${capitulosCorrelacionados.length}');
      List<Capitulos> listaCapitulosCorrelacionadosLidos = [];
      // debugPrint("caplist: ${listaCapitulosDisponiveis?.length}");

      if (capitulosLidos.isNotEmpty) {
        for (int i = 0; i < capitulosCorrelacionados.length; ++i) {
          // var item = capitulosCorrelacionados[i];
          // print(
          //     "item: ${item.capitulo} / ${item.disponivel ? "true" : "false"} / ${item.readed ? "lido" : "não lido"}");
          bool adicionado = false;
          for (int cap = 0; cap < capitulosLidos.length; ++cap) {
            if ((capitulosCorrelacionados[i].id).toString() ==
                capitulosLidos[cap]) {
              //log("lido! - ${listaCapitulos[i].capitulo} / i = $i / d = ${listaCapitulos[i].disponivel ? "true" : "false"}");
              listaCapitulosCorrelacionadosLidos.add(Capitulos(
                id: capitulosCorrelacionados[i].id,
                capitulo: capitulosCorrelacionados[i].capitulo,
                description: capitulosCorrelacionados[i].description,
                download: capitulosCorrelacionados[i].download,
                readed: true,
                disponivel: capitulosCorrelacionados[i].disponivel,
                downloadPages: capitulosCorrelacionados[i].downloadPages,
                pages: capitulosCorrelacionados[i].pages,
              ));
              adicionado = true;
            }
          }
          if (!adicionado) {
            listaCapitulosCorrelacionadosLidos.add(Capitulos(
              id: capitulosCorrelacionados[i].id,
              capitulo: capitulosCorrelacionados[i].capitulo,
              description: capitulosCorrelacionados[i].description,
              download: capitulosCorrelacionados[i].download,
              readed: false,
              disponivel: capitulosCorrelacionados[i].disponivel,
              downloadPages: capitulosCorrelacionados[i].downloadPages,
              pages: capitulosCorrelacionados[i].pages,
            ));
            adicionado = true;
          }
        }
        debugPrint("---------- listaCapitulosCorrelacionados");
        debugPrint('$listaCapitulosCorrelacionadosLidos');
        capitulosCorrelacionados = listaCapitulosCorrelacionadosLidos;
      }
      debugPrint('- updateChapters - end');
      state.value = ChaptersStates.sucess;
    } catch (e) {
      debugPrint('erro no updateChapters at ChaptersController: $e');
      state.value = ChaptersStates.error;
    }
  }

  marcarDesmarcar(String id, String link, Map<String, String> nameAndImage,
      int idExtension) async {
    ClientDataModel clientData = await _hiveController.getClientData();
    debugPrint('${clientData.capitulosLidos}');

    // achar o manga pelo link
    // List<dynamic> capitulosLidos = [];
    String completUrl = mapOfExtensions[idExtension]!.getLink(link);
    RegExp regex = RegExp(completUrl, dotAll: true, caseSensitive: false);
    bool existe = false;
    for (int i = 0; i < clientData.capitulosLidos.length; ++i) {
      if (clientData.capitulosLidos[i]['link'].contains(regex)) {
        existe = true;
        List<dynamic> capitulosLidos =
            clientData.capitulosLidos[i]['capitulos'];
        if (capitulosLidos.contains(id)) {
          debugPrint('temos o capitulo. removendo...');
          capitulosLidos.removeWhere((element) => element == id);
          clientData.capitulosLidos[i]['capitulos'] = capitulosLidos;

          await _hiveController.updateClientData(clientData);
        } else {
          debugPrint('não temos o capitulo. adicionado...');
          capitulosLidos.add(id);
          clientData.capitulosLidos[i]['capitulos'] = capitulosLidos;
          await _hiveController.updateClientData(clientData);
        }
      }
    }
    if (!existe) {
      clientData.capitulosLidos.add({
        "name": nameAndImage["name"],
        "img": nameAndImage["img"],
        "link": completUrl,
        "capitulos": [id],
      });
      debugPrint('não existe! adicionado...');
      await _hiveController.updateClientData(clientData);
    }
    debugPrint('marcar desmarcar concluido!');
  }

  Future<void> correlacionarCapitulos(List<Capitulos> listaCapitulosDisponiveis,
      List<Capitulos> listaCapitulos, String link,
      {bool isAnUpdate = false, required int idExtension}) async {
    ClientDataModel clientData = await _hiveController.getClientData();
    // for (Capitulos element in listaCapitulos) {
    //   print("model cap: ${element.capitulo} / ${element.pages.length}");
    // }
    //log("disponiveis: ${listaCapitulosDisponiveis.length}, todos ${listaCapitulos.length}");

    /// if it is an offline book, it will not do the correlation, it will only return the [ Capitulos ] model
    if (MangaInfoController.isAnOffLineBook && !isAnUpdate) {
      capitulosCorrelacionados = listaCapitulos;
      debugPrint("is off line!, returning...");
      return;
    }
    debugPrint("NÃO RETORNOU!!!");

    /// aqui verificamos se podemos exibir o botão de [ atualizar/adicionar ] no servidor
    GlobalData.showAdiminAtualizationBanner = clientData.isAdimin;

    // achar os capitulos lidos do manga pelo link
    List<dynamic> capitulosLidos = [];
    String completUrl = mapOfExtensions[idExtension]!.getLink(link);
    RegExp regex = RegExp(completUrl, dotAll: true, caseSensitive: false);

    for (int i = 0; i < clientData.capitulosLidos.length; ++i) {
      if (clientData.capitulosLidos[i]['link'].contains(regex)) {
        capitulosLidos = clientData.capitulosLidos[i]['capitulos'];
      }
    }

    debugPrint('iniciando a parte pessada do correlacionamento!!!');
    capitulosCorrelacionados = [];
    //print("disponivel = ${listaCapitulosDisponiveis[indice]}");
    // CAPITULOS
    // late final dynamic id;
    // late final String capitulo;
    // late final bool download;
    // late final bool readed;
    // late final bool disponivel;
    // late final List<String> downloadPages;
    // late final List<String> pages;

    // List<ModelLeitor> allDisponibleChapters =
    //     List.unmodifiable(GlobalData.capitulosDisponiveis);
    // log("disponiveis: ${listaCapitulosDisponiveis.length}, todos ${listaCapitulos.length}");
    // List<Capitulos> fakeListDisponiveis = listaCapitulosDisponiveis;
    // for (ModelLeitor element in fakeListDisponiveis) {
    //   print("leitor model cap: ${element.capitulo} / ${element.pages.length}");
    // }

    for (int indice = 0; indice < listaCapitulos.length; ++indice) {
      bool adicionado = false;
      // if (<int>[40, 120, 300, 600].contains(indice)) {
      //   GlobalData.capitulosDisponiveis;
      //   print("parada!");
      // }
      for (int alreadyIndice = 0;
          alreadyIndice < listaCapitulosDisponiveis.length;
          ++alreadyIndice) {
        RegExp idCapituloDisponivel = RegExp(
            listaCapitulosDisponiveis[alreadyIndice].id,
            caseSensitive: false);
        if (listaCapitulos[indice].id.contains(idCapituloDisponivel)) {
          // print("capitulo correlacionado!: ${listaCapitulos[indice].capitulo}");
          capitulosCorrelacionados.add(Capitulos(
            id: listaCapitulos[indice].id,
            capitulo: listaCapitulos[indice].capitulo,
            description: listaCapitulos[indice].description,
            download: listaCapitulosDisponiveis[alreadyIndice].download,
            readed: false,
            disponivel: true,
            downloadPages:
                listaCapitulosDisponiveis[alreadyIndice].downloadPages,
            pages: listaCapitulosDisponiveis[alreadyIndice]
                .pages
                .map<String>((dynamic page) => page.toString())
                .toList(),
          ));
          adicionado = true;
          listaCapitulosDisponiveis.removeAt(alreadyIndice);
          break;
        }
      }
      if (!adicionado) {
        capitulosCorrelacionados.add(Capitulos(
          id: listaCapitulos[indice].id,
          capitulo: listaCapitulos[indice].capitulo,
          description: listaCapitulos[indice].description,
          download: false, // listaCapitulosDisponiveis[indice].download
          readed: false,
          disponivel: false,
          downloadPages: [], // listaCapitulosDisponiveis[indice].downloadPages
          pages: [],
        ));
      }
    }

    // GlobalData.capitulosDisponiveis = allDisponibleChapters;

    // for (Capitulos model in capitulosCorrelacionados) {
    //   log("correlacionados: ${model.capitulo} - ${model.pages.length}");
    // }

    // correlacionar os capitulos lidos
    // GlobalData.capitulosDisponiveis;
    print(capitulosLidos);
    // print(" ----  capitulos correlacionados ----");
    // print(capitulosCorrelacionados);
    if (capitulosLidos.isNotEmpty) {
      print("há capitulos lidos");
      List<Capitulos> listaCapitulosCorrelacionadosLidos = [];

      for (int i = 0; i < capitulosCorrelacionados.length; ++i) {
        var item = capitulosCorrelacionados[i];
        bool adicionado = false;
        if (capitulosLidos.contains(item.id)) {
          for (int cap = 0; cap < capitulosLidos.length; ++cap) {
            if (capitulosCorrelacionados[i].id == capitulosLidos[cap]) {
              //log("lido! - ${listaCapitulos[i].capitulo} / i = $i / d = ${listaCapitulos[i].disponivel ? "true" : "false"}");
              listaCapitulosCorrelacionadosLidos.add(Capitulos(
                id: capitulosCorrelacionados[i].id,
                capitulo: capitulosCorrelacionados[i].capitulo,
                description: capitulosCorrelacionados[i].description,
                download: false,
                readed: true,
                disponivel: capitulosCorrelacionados[i].disponivel,
                downloadPages: [],
                pages: [],
              ));
              adicionado = true;
            }
          }
        }
        if (!adicionado) {
          listaCapitulosCorrelacionadosLidos.add(item);
          adicionado = true;
        }
      }
      capitulosCorrelacionados = listaCapitulosCorrelacionadosLidos;
      // print('-- final = ${capitulosCorrelacionados.length}');
    }
  }
}

enum ChaptersStates { start, loading, sucess, error }

class DialogController {
  final HiveController hiveController = HiveController();
  List<LibraryModel> dataLibrary = [];
  List<LibraryModel> dataOcultLibrary = [];
  List<CheckboxListTile> addToLibraryCheckboxes = [];
  // ValueNotifier<DialogStates> state =
  //     ValueNotifier<DialogStates>(DialogStates.start);

  Future<bool> start() async {
    // state.value = DialogStates.loading;
    try {
      dataLibrary = await hiveController.getLibraries();
      //generateValues(dataLibrary);
      return true;
    } catch (e, s) {
      // state.value = DialogStates.error;
      debugPrint('erro no start at DialogController: $e');
      debugPrint('$s');
      return false;
    }
  }

  Future<bool> startOcultLibrary() async {
    // state.value = DialogStates.loading;
    try {
      dataOcultLibrary = await hiveController.getOcultLibraries();
      //generateValues(dataLibrary);
      return true;
    } catch (e, s) {
      // state.value = DialogStates.error;
      debugPrint('erro no start at DialogController: $e');
      debugPrint('$s');
      return false;
    }
  }

  /// adicionar ou remover da library (biblioteca)
  Future<bool> addOrRemoveFromLibrary(
      List<Map> lista, Map<String, dynamic> book,
      {required String link,
      required MangaInfoOffLineModel model,
      required List<Capitulos> capitulos}) async {
    debugPrint('inicio do processo de atualização da library');

    bool haveError = false;
    dataLibrary = await hiveController.getLibraries();
    bool offLine = false;
    bool removerDB = true;

    for (int i = 0; i < lista.length; ++i) {
      bool existe = false;
      bool executed = false;
      for (int iBook = 0; iBook < dataLibrary[i].books.length; ++iBook) {
        // print(
        //     "i = $iBook / ${dataLibrary[i].books.length} -- tst: ${(dataLibrary[i].library == lista[i]['library']) && (dataLibrary[i].books[iBook].link == book['link']) && (dataLibrary[i].books[iBook].idExtension == book['idExtension'])} \n ${dataLibrary[i].library} == ${lista[i]['library']} && ${dataLibrary[i].books[iBook].link} == ${book['link']} ee ${dataLibrary[i].books[iBook].idExtension} == ${book['idExtension']}");
        if ((dataLibrary[i].library == lista[i]['library']) &&
            (dataLibrary[i].books[iBook].link == book['link']) &&
            (dataLibrary[i].books[iBook].idExtension == book['idExtension'])) {
          debugPrint("achei o manga na library");
          offLine = true;
          if (!lista[i]['selected']) {
            debugPrint('remover da library');
            dataLibrary[i].books.removeWhere((element) =>
                (element.link == book['link']) &&
                element.idExtension == book['idExtension']);
            await hiveController.updateLibraries(dataLibrary)
                ? haveError = false
                : haveError = true;
            executed = true;
            break;
          } else {
            removerDB = false;
            existe = true;
          }
        }
      }
      if (!existe && !executed && lista[i]['selected']) {
        debugPrint('adicionar a library');
        dataLibrary[i].books.add(Books.fromJson(book));
        await hiveController.updateLibraries(dataLibrary)
            ? haveError = false
            : haveError = true;
      }
    }
    if (!offLine) {
      // for (Capitulos element in model.capitulos) {
      //   print("capitulo ${element.capitulo} / ${element.disponivel}");
      // }
      await _addOffLineManga(
        link: link,
        model: model,
      )
          ? haveError = false
          : haveError = true;
    } else if (removerDB) {
      await _removeOffLineManga(link: link, idExtension: book['idExtension'])
          ? haveError = false
          : haveError = true;
    }
    return !haveError;
  }

  /// adicionar ou remover da ocultLibrary (biblioteca oculta)
  Future<bool> addOrRemoveFromOcultLibrary(
      List<Map> lista, Map<String, dynamic> book,
      {required String link,
      required MangaInfoOffLineModel model,
      required List<Capitulos> capitulos}) async {
    debugPrint('inicio do processo de atualização da Ocult library');

    bool haveError = false;
    dataOcultLibrary = await hiveController.getOcultLibraries();
    bool offLine = false;
    bool removerDB = true;

    for (int i = 0; i < lista.length; ++i) {
      bool existe = false;
      bool executed = false;
      for (int iBook = 0; iBook < dataOcultLibrary[i].books.length; ++iBook) {
        // print(
        //     "i = $iBook / ${dataLibrary[i].books.length} -- tst: ${(dataLibrary[i].library == lista[i]['library']) && (dataLibrary[i].books[iBook].link == book['link']) && (dataLibrary[i].books[iBook].idExtension == book['idExtension'])} \n ${dataLibrary[i].library} == ${lista[i]['library']} && ${dataLibrary[i].books[iBook].link} == ${book['link']} ee ${dataLibrary[i].books[iBook].idExtension} == ${book['idExtension']}");
        if ((dataOcultLibrary[i].library == lista[i]['library']) &&
            (dataOcultLibrary[i].books[iBook].link == book['link']) &&
            (dataOcultLibrary[i].books[iBook].idExtension == book['idExtension'])) {
          debugPrint("achei o manga na OCULT library");
          offLine = true;
          if (!lista[i]['selected']) {
            debugPrint('remover da OCULT library');
            dataOcultLibrary[i].books.removeWhere((element) =>
                (element.link == book['link']) &&
                element.idExtension == book['idExtension']);
            await hiveController.updateOcultLibraries(dataOcultLibrary)
                ? haveError = false
                : haveError = true;
            executed = true;
            break;
          } else {
            removerDB = false;
            existe = true;
          }
        }
      }
      if (!existe && !executed && lista[i]['selected']) {
        debugPrint('adicionar a OCULT library');
        dataOcultLibrary[i].books.add(Books.fromJson(book));
        await hiveController.updateOcultLibraries(dataOcultLibrary)
            ? haveError = false
            : haveError = true;
      }
    }
    if (!offLine) {
      await _addOffLineManga(
        link: link,
        model: model,
      )
          ? haveError = false
          : haveError = true;
    } else if (removerDB) {
      await _removeOffLineManga(link: link, idExtension: book['idExtension'])
          ? haveError = false
          : haveError = true;
    }
    return !haveError;
  }

  // disponibilizar um manga OffLine
  Future<bool> _addOffLineManga(
      {required String link, required MangaInfoOffLineModel model}) async {
    final MangaInfoOffLineController mangaInfoOffLineController =
        MangaInfoOffLineController();

    return await mangaInfoOffLineController.addBook(
        model: model, capitulos: ChaptersController.capitulosCorrelacionados);
  }

  // remove um manga OffLine
  Future<bool> _removeOffLineManga({
    required int idExtension,
    required String link,
  }) async {
    final MangaInfoOffLineController mangaInfoOffLineController =
        MangaInfoOffLineController();
    try {
      mangaInfoOffLineController.deleteBook(
          link: link, idExtension: idExtension);
      return true;
    } catch (e) {
      debugPrint("erro no _removeOffLineManga at DialogController: $e");
      return false;
    }
  }
}

// enum DialogStates { start, loading, sucess, error }
