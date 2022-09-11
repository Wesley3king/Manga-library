import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/controllers/off_line/manga_info_off_line.dart';
import 'package:manga_library/app/models/client_data_model.dart';
import 'package:manga_library/app/models/globais.dart';
import 'package:manga_library/app/models/manga_info_model.dart';
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
  ModelMangaInfo data = ModelMangaInfo(
    chapterName: '',
    chapters: 0,
    description: '',
    cover: '',
    genres: [],
    chapterList: '',
    alternativeName: false,
    allposts: [],
  );
  List<ModelLeitor>? capitulosDisponiveis = [];
  static List<ModelCapitulosCorrelacionados> capitulosCorrelacionados = [];

  ValueNotifier state = ValueNotifier<MangaInfoStates>(MangaInfoStates.start);

  Future start(String url) async {
    state.value = MangaInfoStates.loading;
    try {
      // operação OffLine
      MangaInfoOffLineModel? localData =
          await _mangaInfoOffLineController.verifyDatabase(url);
      if (localData != null) {
        print("existe na base de dados!");
        data = _mangaInfoOffLineController.buildMangaInfoModel(localData);
        capitulosDisponiveis =
            _mangaInfoOffLineController.buildModelLeitor(localData);
        GlobalData.capitulosDisponiveis = capitulosDisponiveis ?? [];
        state.value = MangaInfoStates.sucess2;
      } else {
        // operação OnLine
        print("iniciando o fetch!");
        final ModelMangaInfo? _dados = await mangaYabu.mangaInfo(url);
        if (_dados != null) {
          data = _dados;
          state.value = MangaInfoStates.sucess1;
        } else {
          state.value = MangaInfoStates.error;
        }
        capitulosDisponiveis = await yabuFetchServices.fetchCapitulos(url);
        GlobalData.capitulosDisponiveis = capitulosDisponiveis ?? [];
        // print(_capitulosDisponiveis);

        if (state.value != MangaInfoStates.error) {
          state.value = MangaInfoStates.sucess2;
        } else {
          HomePageController.errorMessage = 'erro no null 2';
          state.value = MangaInfoStates.error;
        }
      }
    } catch (e) {
      print(e);
      HomePageController.errorMessage = 'erro no catch do MangaInfo: $e';
      state.value = MangaInfoStates.error;
    }
  }

  addOrUpadteBook({required String name, required String link}) async {
    await yabuFetchServices.addOrUpdateBook({"name": name, "link": link});
  }
}

enum MangaInfoStates { start, loading, sucess1, sucess2, error }

class BottomSheetController {
  final HiveController _hiveController = HiveController();
  List<ModelCapitulosCorrelacionados> capitulosCorrelacionados = [];

  ValueNotifier<BottomSheetStates> state =
      ValueNotifier<BottomSheetStates>(BottomSheetStates.start);

  start(List<ModelLeitor>? listaCapitulosDisponiveis,
      List<Allposts> listaCapitulos, String link) async {
    state.value = BottomSheetStates.loading;
    try {
      print('start');
      await correlacionarCapitulos(
          listaCapitulosDisponiveis ?? [], listaCapitulos, link);
      // disponibilizar os capitulos correlacionados
      MangaInfoController.capitulosCorrelacionados = capitulosCorrelacionados;
      state.value = BottomSheetStates.sucess;
    } catch (e) {
      HomePageController.errorMessage =
          'erro no catch BottomSheetController: $e';
      print('erro no start BottomSheetController');
      print(e);
      state.value = BottomSheetStates.error;
    }
  }

  update(List<ModelLeitor>? listaCapitulosDisponiveis,
      List<Allposts> listaCapitulos, String link) async {
    state.value = BottomSheetStates.loading;
    try {
      print('restart');
      await correlacionarCapitulos(
          listaCapitulosDisponiveis ?? [], listaCapitulos, link);
      print('- restart - end');
      state.value = BottomSheetStates.sucess;
    } catch (e) {
      print('erro no Restart BottomSheetController at update');
      print(e);
      state.value = BottomSheetStates.error;
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

  correlacionarCapitulos(List<ModelLeitor> listaCapitulosDisponiveis,
      List<Allposts> listaCapitulos, String link) async {
    print('parte 0 erro');
    ClientDataModel clientData = await _hiveController.getClientData();
    print('parte 0.1 erro');
    // aqui verificamos se podemos exibir o botão de atualizar/adicionar no servidor
    // print(
    //     'old: ${GlobalData.showAdiminAtualizationBanner ? "T" : "F"} / ${clientData.isAdimin ? "T" : "F"}');
    GlobalData.showAdiminAtualizationBanner = clientData.isAdimin;
    // achar o manga pelo link

    List<dynamic> capitulosLidos = [];
    RegExp regex = RegExp('https://mangayabu.top/manga/$link',
        dotAll: true, caseSensitive: false);
    // print(clientData.capitulosLidos);
    // print(clientData.capitulosLidos.length);

    for (int i = 0; i < clientData.capitulosLidos.length; ++i) {
      if (clientData.capitulosLidos[i]['link'].contains(regex)) {
        capitulosLidos = clientData.capitulosLidos[i]['capitulos'];
      }
    }

    print('parte 1 erro');
    capitulosCorrelacionados = [];

    for (int indice = 0; indice < listaCapitulos.length; ++indice) {
      //print("disponivel = ${listaCapitulosDisponiveis[indice]}");
      bool adicionado = false;
      for (int alreadyIndice = 0;
          alreadyIndice < listaCapitulosDisponiveis.length;
          ++alreadyIndice) {
        int idCapituloDisponivel = listaCapitulosDisponiveis[alreadyIndice].id;
        if (listaCapitulos[indice].id == idCapituloDisponivel) {
          capitulosCorrelacionados.add(ModelCapitulosCorrelacionados(
            id: idCapituloDisponivel,
            capitulo: listaCapitulosDisponiveis[alreadyIndice].capitulo,
            disponivel: listaCapitulos[indice].disponivel,
            readed: false,
          ));
          adicionado = true;
          break;
        }
      }
      if (!adicionado) {
        capitulosCorrelacionados.add(ModelCapitulosCorrelacionados(
          id: listaCapitulos[indice].id,
          capitulo: listaCapitulos[indice].num,
          disponivel: false,
          readed: false,
        ));
      }
    }
    // print('--- teste reload 1 --- ');
    // for (int i = 0; i < 2; ++i) {
    //   print(capitulosCorrelacionados[i].readed);
    // }
    // correlacionar os capitulos lidos
    print(capitulosLidos);
    if (capitulosLidos.isNotEmpty) {
      print('inicio = ${capitulosCorrelacionados.length}');
      List<ModelCapitulosCorrelacionados> listaCapitulosCorrelacionadosLidos =
          [];
      for (int i = 0; i < capitulosCorrelacionados.length; ++i) {
        var item = capitulosCorrelacionados[i];
        bool adicionado = false;
        for (int cap = 0; cap < capitulosLidos.length; ++cap) {
          if ((capitulosCorrelacionados[i].id).toString() ==
              capitulosLidos[cap]) {
            listaCapitulosCorrelacionadosLidos
                .add(ModelCapitulosCorrelacionados(
              id: item.id,
              capitulo: item.capitulo,
              disponivel: item.disponivel,
              readed: true,
            ));
            adicionado = true;
          }
        }
        if (!adicionado) {
          listaCapitulosCorrelacionadosLidos.add(item);
          adicionado = true;
        }
      }
      // print('--- teste reload 2 --- ');
      // for (int i = 0; i < 2; ++i) {
      //   print(listaCapitulosCorrelacionadosLidos[i].readed);
      // }
      capitulosCorrelacionados = listaCapitulosCorrelacionadosLidos;
      print('-- final = ${capitulosCorrelacionados.length}');
    }
  }
}

enum BottomSheetStates { start, loading, sucess, error }

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
      required ModelMangaInfo model,
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
      await _addOffLineManga(
              link: link,
              model: model,
              capitulos: capitulos,
              capitulosCorrelacionados:
                  MangaInfoController.capitulosCorrelacionados)
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
      {required String link,
      required ModelMangaInfo model,
      required List<ModelLeitor> capitulos,
      required List<ModelCapitulosCorrelacionados>
          capitulosCorrelacionados}) async {
    final MangaInfoOffLineController mangaInfoOffLineController =
        MangaInfoOffLineController();
    return await mangaInfoOffLineController.addBook(
        model: model,
        link: link,
        capitulos: capitulos,
        capitulosCorrelacionados: capitulosCorrelacionados);
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
