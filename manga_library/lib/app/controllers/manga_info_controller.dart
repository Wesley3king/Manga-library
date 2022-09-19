import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/controllers/off_line/manga_info_off_line.dart';
import 'package:manga_library/app/models/client_data_model.dart';
import 'package:manga_library/app/models/globais.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';
import 'package:manga_library/repositories/yabu/yabu_fetch_services.dart';

import '../models/leitor_model.dart';
import '../models/libraries_model.dart';
import 'extensions/extension_manga_yabu.dart';
import 'home_page_controller.dart';

class MangaInfoController {
  final mangaYabu = ExtensionMangaYabu();
  final MangaInfoOffLineController _mangaInfoOffLineController =
      MangaInfoOffLineController();
  final YabuFetchServices yabuFetchServices = YabuFetchServices();
  final ChaptersController _chaptersController = ChaptersController();

  MangaInfoOffLineModel data = MangaInfoOffLineModel(
    name: "",
    description: "",
    img: "",
    link: "",
    genres: [],
    alternativeName: false,
    chapters: 0,
    capitulos: [],
  );
  List<ModelLeitor>? capitulosDisponiveis = [];
  static bool isAnOffLineBook = false;
  ValueNotifier<MangaInfoStates> state =
      ValueNotifier<MangaInfoStates>(MangaInfoStates.start);

  Future start(String url) async {
    state.value = MangaInfoStates.loading;
    try {
      // operação OffLine
      MangaInfoOffLineModel? localData =
          await _mangaInfoOffLineController.verifyDatabase(url);
      if (localData != null) {
        print("existe na base de dados! / l= $url");

        data = localData;
        capitulosDisponiveis =
            _mangaInfoOffLineController.buildModelLeitor(localData);
        log("at offline start: ${capitulosDisponiveis!.length}");
        GlobalData.capitulosDisponiveis =
            List.unmodifiable(capitulosDisponiveis ?? []);
        isAnOffLineBook = true;
        // await _chaptersController.correlacionarCapitulos(
        //     capitulosDisponiveis ?? [], data.capitulos, url);
        state.value = MangaInfoStates.sucess2;
      } else {
        // operação OnLine
        print("iniciando o fetch! / l= $url");

        final MangaInfoOffLineModel? _dados = await mangaYabu.mangaInfo(url);
        if (_dados != null) {
          data = _dados;
          state.value = MangaInfoStates.sucess1;
        } else {
          state.value = MangaInfoStates.error;
        }
        capitulosDisponiveis = await yabuFetchServices.fetchCapitulos(url);
        log("at online start: ${capitulosDisponiveis!.length}");
        GlobalData.capitulosDisponiveis =
            List.unmodifiable(capitulosDisponiveis ?? []);
        // await _chaptersController.correlacionarCapitulos(
        //     capitulosDisponiveis ?? [], data.capitulos, url);
        // print(_capitulosDisponiveis);
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

  Future updateBook(String url, ChaptersController chaptersController) async {
    try {
      print("atualizando... / l= $url");

      final MangaInfoOffLineModel? dados = await mangaYabu.mangaInfo(url);
      if (dados != null) {
        data = dados;
      } else {
        state.value = MangaInfoStates.error;
      }
      capitulosDisponiveis = await yabuFetchServices.fetchCapitulos(url);
      log("at updatebook: ${capitulosDisponiveis!.length}");
      GlobalData.capitulosDisponiveis =
          List.unmodifiable(capitulosDisponiveis ?? []);

      if (isAnOffLineBook) {
        // is an off line book
        List<Capitulos> capitulosFromOriginalServer =
            dados == null ? [] : dados.capitulos;
        if (dados == null) {
          print("dd off-line true");
          capitulosFromOriginalServer = [];
        } else {
          print("dd off-line false");
          capitulosFromOriginalServer = dados.capitulos;
        }
        await chaptersController.update(
            capitulosDisponiveis, capitulosFromOriginalServer, url);
        final MangaInfoOffLineController mangaInfoOffLineController =
            MangaInfoOffLineController();
        await mangaInfoOffLineController.updateBook(
            model: data,
            capitulos: ChaptersController.capitulosCorrelacionados);
      } else {
        // isn't an off ine book
        print("is null? = ${dados == null}");
        List<Capitulos> capitulosFromOriginalServer =
            dados == null ? [] : dados.capitulos;
        if (dados == null) {
          print("dd true");
          capitulosFromOriginalServer = [];
        } else {
          print("dd false");
          capitulosFromOriginalServer = dados.capitulos;
        }
        await chaptersController.update(
            capitulosDisponiveis, capitulosFromOriginalServer, url);
      }
      state.value = MangaInfoStates.sucess1;
      // caso falhe pode ser aqui
      state.value = MangaInfoStates.sucess2;
    } catch (e) {
      print("erro no update book at mangaInfoController: $e");
      state.value = MangaInfoStates.error;
    }
  }

  addOrUpadteBook({required String name, required String link}) async {
    await yabuFetchServices.addOrUpdateBook({"name": name, "link": link});
  }
}

enum MangaInfoStates { start, loading, sucess1, sucess2, error }

class ChaptersController {
  final HiveController _hiveController = HiveController();

  ValueNotifier<ChaptersStates> state =
      ValueNotifier<ChaptersStates>(ChaptersStates.start);
  static List<Capitulos> capitulosCorrelacionados = [];

  start(List<ModelLeitor>? listaCapitulosDisponiveis,
      List<Capitulos> listaCapitulos, String link) async {
    state.value = ChaptersStates.loading;
    // GlobalData.capitulosDisponiveis;
    try {
      print('start // link: $link');
      print("chapter offline: ${MangaInfoController.isAnOffLineBook}");
      if (MangaInfoController.isAnOffLineBook) {
        capitulosCorrelacionados = listaCapitulos;
        await updateChapters(listaCapitulosDisponiveis, listaCapitulos, link);
      } else {
        await correlacionarCapitulos(
            listaCapitulosDisponiveis ?? [], listaCapitulos, link);
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

  Future<bool> update(List<ModelLeitor>? listaCapitulosDisponiveis,
      List<Capitulos> listaCapitulos, String link) async {
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
      await correlacionarCapitulos(
            listaCapitulosDisponiveis ?? [], listaCapitulos, link);
      state.value = ChaptersStates.loading;
      log("atualizando a view!");
      // print(capitulosCorrelacionados);
      state.value = ChaptersStates.sucess;
      return true;
    } catch (e) {
      HomePageController.errorMessage =
          'erro no update at ChapterController: $e';
      print('erro no update ChapterController');
      print(e);
      state.value = ChaptersStates.error;
      return false;
    }
  }

  updateChapters(
    List<ModelLeitor>? listaCapitulosDisponiveis,
    List<Capitulos> listaCapitulos,
    String link,
  ) async {
    state.value = ChaptersStates.loading;
    try {
      print('restart');
      // conseguir os dados
      ClientDataModel clientData = await _hiveController.getClientData();
      // achar os capitulos lidos do manga pelo link
      List<dynamic> capitulosLidos = [];
      RegExp regex = RegExp('https://mangayabu.top/manga/$link',
          dotAll: true, caseSensitive: false);

      for (int i = 0; i < clientData.capitulosLidos.length; ++i) {
        if (clientData.capitulosLidos[i]['link'].contains(regex)) {
          capitulosLidos = clientData.capitulosLidos[i]['capitulos'];
        }
      }
      print(capitulosLidos);
      // await correlacionarCapitulos(
      //     listaCapitulosDisponiveis ?? [], listaCapitulos, link);
      // faz o recorrelacionamento
      //  if (capitulosLidos.isNotEmpty) {
      // print('inicio = ${capitulosCorrelacionados.length}');
      List<Capitulos> listaCapitulosCorrelacionadosLidos = [];

      for (int i = 0; i < capitulosCorrelacionados.length; ++i) {
        var item = capitulosCorrelacionados[i];
        // print(
        //     "item: ${item.capitulo} / ${item.disponivel ? "true" : "false"} / ${item.readed ? "lido" : "não lido"}");
        bool adicionado = false;
        for (int cap = 0; cap < capitulosLidos.length; ++cap) {
          if ((capitulosCorrelacionados[i].id).toString() ==
              capitulosLidos[cap]) {
            log("lido! - ${listaCapitulos[i].capitulo} / i = $i / d = ${listaCapitulos[i].disponivel ? "true" : "false"}");
            listaCapitulosCorrelacionadosLidos.add(Capitulos(
              id: capitulosCorrelacionados[i].id,
              capitulo: capitulosCorrelacionados[i].capitulo,
              download: false,
              readed: true,
              disponivel: capitulosCorrelacionados[i].disponivel,
              downloadPages: [],
              pages: [],
            ));
            adicionado = true;
          }
        }
        if (!adicionado) {
          listaCapitulosCorrelacionadosLidos.add(Capitulos(
            id: capitulosCorrelacionados[i].id,
            capitulo: capitulosCorrelacionados[i].capitulo,
            download: false,
            readed: false,
            disponivel: capitulosCorrelacionados[i].disponivel,
            downloadPages: [],
            pages: [],
          ));
          adicionado = true;
        }
      }
      capitulosCorrelacionados = listaCapitulosCorrelacionadosLidos;
      // }
      print('- restart - end');
      state.value = ChaptersStates.sucess;
    } catch (e) {
      print('erro no Restart BottomSheetController at update');
      print(e);
      state.value = ChaptersStates.error;
    }
  }

  marcarDesmarcar(
      String id, String link, Map<String, String> nameAndImage) async {
    ClientDataModel clientData = await _hiveController.getClientData();
    print(clientData.capitulosLidos);

    // achar o manga pelo link
    // List<dynamic> capitulosLidos = [];
    RegExp regex = RegExp('https://mangayabu.top/manga/$link',
        dotAll: true, caseSensitive: false);
    bool existe = false;
    for (int i = 0; i < clientData.capitulosLidos.length; ++i) {
      if (clientData.capitulosLidos[i]['link'].contains(regex)) {
        existe = true;
        List<dynamic> capitulosLidos =
            clientData.capitulosLidos[i]['capitulos'];
        if (capitulosLidos.contains(id)) {
          print('temos o capitulo. removendo...');
          capitulosLidos.removeWhere((element) => element == id);
          clientData.capitulosLidos[i]['capitulos'] = capitulosLidos;

          await _hiveController.updateClientData(clientData);
        } else {
          print('não temos o capitulo. adicionado...');
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
        "link": 'https://mangayabu.top/manga/$link',
        "capitulos": [id],
      });
      print('não existe! adicionado...');
      await _hiveController.updateClientData(clientData);
    }
    print('marcar desmarcar concluido!');
  }

  Future<void> correlacionarCapitulos(
      List<ModelLeitor> listaCapitulosDisponiveis,
      List<Capitulos> listaCapitulos,
      String link, {bool isAnUpdate = false}) async {
    ClientDataModel clientData = await _hiveController.getClientData();
    // for (Capitulos element in listaCapitulos) {
    //   print("model cap: ${element.capitulo} / ${element.pages.length}");
    // }
    log("disponiveis: ${listaCapitulosDisponiveis.length}, todos ${listaCapitulos.length}");

    /// if it is an offline book, it will not do the correlation, it will only return the [ Capitulos ] model
    if (MangaInfoController.isAnOffLineBook && !isAnUpdate) {
      capitulosCorrelacionados = listaCapitulos;
      print("is off line!");
      return;
    }
    // aqui verificamos se podemos exibir o botão de atualizar/adicionar no servidor
    GlobalData.showAdiminAtualizationBanner = clientData.isAdimin;

    // achar os capitulos lidos do manga pelo link
    List<dynamic> capitulosLidos = [];
    RegExp regex = RegExp('https://mangayabu.top/manga/$link',
        dotAll: true, caseSensitive: false);

    for (int i = 0; i < clientData.capitulosLidos.length; ++i) {
      if (clientData.capitulosLidos[i]['link'].contains(regex)) {
        capitulosLidos = clientData.capitulosLidos[i]['capitulos'];
      }
    }

    print('iniciando a parte pessada do correlacionamento!!!');
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
    List<ModelLeitor> fakeListDisponiveis = listaCapitulosDisponiveis;
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
          alreadyIndice < fakeListDisponiveis.length;
          ++alreadyIndice) {
        RegExp idCapituloDisponivel =
            RegExp(fakeListDisponiveis[alreadyIndice].id, caseSensitive: false);
        if (listaCapitulos[indice].id.contains(idCapituloDisponivel)) {
          // print("capitulo correlacionado!: ${listaCapitulos[indice].capitulo}");
          capitulosCorrelacionados.add(Capitulos(
            id: listaCapitulos[indice].id,
            capitulo: listaCapitulos[indice].capitulo,
            download: listaCapitulos[indice].download,
            readed: false,
            disponivel: true,
            downloadPages: listaCapitulos[indice].downloadPages,
            pages: fakeListDisponiveis[alreadyIndice]
                .pages
                .map<String>((dynamic page) => page.toString())
                .toList(),
          ));
          adicionado = true;
          // print(fakeListDisponiveis[alreadyIndice]
          //     .pages
          //     .map<String>((dynamic page) => page.toString())
          //     .toList());
          fakeListDisponiveis.removeAt(alreadyIndice);
          break;
        }
      }
      if (!adicionado) {
        // print(
        //     "capitulo correlacionado como indisponivel!: ${listaCapitulos[indice].capitulo}");
        capitulosCorrelacionados.add(Capitulos(
          id: listaCapitulos[indice].id,
          capitulo: listaCapitulos[indice].capitulo,
          download: false,
          readed: false,
          disponivel: false,
          downloadPages: [],
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
        for (int cap = 0; cap < capitulosLidos.length; ++cap) {
          if (capitulosCorrelacionados[i].id == capitulosLidos[cap]) {
            //log("lido! - ${listaCapitulos[i].capitulo} / i = $i / d = ${listaCapitulos[i].disponivel ? "true" : "false"}");
            listaCapitulosCorrelacionadosLidos.add(Capitulos(
              id: capitulosCorrelacionados[i].id,
              capitulo: capitulosCorrelacionados[i].capitulo,
              download: false,
              readed: true,
              disponivel: capitulosCorrelacionados[i].disponivel,
              downloadPages: [],
              pages: [],
            ));
            adicionado = true;
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
  List<CheckboxListTile> addToLibraryCheckboxes = [];
  ValueNotifier<DialogStates> state =
      ValueNotifier<DialogStates>(DialogStates.start);

  Future<bool> start() async {
    state.value = DialogStates.loading;
    try {
      dataLibrary = await hiveController.getLibraries();
      //generateValues(dataLibrary);
      return true;
    } catch (e, s) {
      state.value = DialogStates.error;
      print(e);
      print(s);
      return false;
    }
  }

  // adicionar e remover da library
  Future<bool> addOrRemoveFromLibrary(List<Map> lista, Map<String, String> book,
      {required String link,
      required MangaInfoOffLineModel model,
      required List<ModelLeitor> capitulos}) async {
    print('inicio do processo de atualização da library');
    bool haveError = false;
    dataLibrary = await hiveController.getLibraries();
    bool offLine = false;
    bool removerDB = true;

    for (int i = 0; i < lista.length; ++i) {
      bool existe = false;
      bool executed = false;
      for (int iBook = 0; iBook < dataLibrary[i].books.length; ++iBook) {
        if (dataLibrary[i].library == lista[i]['library'] &&
            dataLibrary[i].books[iBook].link == book['link']) {
          print("achei o manga na library");
          offLine = true;
          if (!lista[i]['selected']) {
            print('remover da library');
            dataLibrary[i]
                .books
                .removeWhere((element) => element.link == book['link']);
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
        print('adicionar a library');
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
      await _removeOffLineManga(link: link)
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
  // disponibilizar um manga OffLine
  Future<bool> _removeOffLineManga({
    required String link,
  }) async {
    final MangaInfoOffLineController mangaInfoOffLineController =
        MangaInfoOffLineController();
    try {
      mangaInfoOffLineController.deleteBook(link: link);
      return true;
    } catch (e) {
      print("erro no _removeOffLineManga at DialogController: $e");
      return false;
    }
  }
}

enum DialogStates { start, loading, sucess, error }
