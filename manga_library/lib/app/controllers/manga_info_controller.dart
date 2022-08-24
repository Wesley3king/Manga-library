import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/models/client_data_model.dart';
import 'package:manga_library/app/models/manga_info_model.dart';
import 'package:manga_library/repositories/yabu/yabu_fetch_services.dart';

import '../models/leitor_model.dart';
import 'extensions/extension_manga_yabu.dart';

class MangaInfoController {
  final mangaYabu = ExtensionMangaYabu();
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

  ValueNotifier state = ValueNotifier<MangaInfoStates>(MangaInfoStates.start);

  Future start(String url) async {
    state.value = MangaInfoStates.loading;
    try {
      print('------------');
      final ModelMangaInfo? _dados = await mangaYabu.mangaInfo(url);
      if (_dados != null) {
        data = _dados;
        state.value = MangaInfoStates.sucess1;
      } else {
        state.value = MangaInfoStates.error;
      }
      capitulosDisponiveis = await yabuFetchServices.fetchCapitulos(url);
      // print(_capitulosDisponiveis);

      if (state.value != MangaInfoStates.error) {
        state.value = MangaInfoStates.sucess2;
      } else {
        state.value = MangaInfoStates.error;
      }
    } catch (e) {
      print(e);
      state.value = MangaInfoStates.error;
    }
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
      print('------- end');
      print(capitulosCorrelacionados);
      state.value = BottomSheetStates.sucess;
    } catch (e) {
      print('erro no start BottomSheetController');
      print(e);
      state.value = BottomSheetStates.error;
    }
  }

  marcarDesmarcar(String id, String link) async {
    ClientDataModel clientData = await _hiveController.getClientData();

    // achar o manga pelo link
    // List<dynamic> capitulosLidos = [];
    RegExp regex = RegExp('https://mangayabu.top/manga/$link',
        dotAll: true, caseSensitive: false);
    for (int i = 0; i < clientData.capitulosLidos.length; ++i) {
      if (clientData.capitulosLidos[i]['link'].contains(regex)) {
        List<dynamic> capitulosLidos =
            clientData.capitulosLidos[i]['capitulos'];
        if (capitulosLidos.contains(id)) {
          print('temos o capitulo. removendo...');
          capitulosLidos.removeWhere((element) => element == id);
          clientData.capitulosLidos[i] = capitulosLidos;
          _hiveController.updateClientData(clientData);
        } else {
          print('não temos o capitulo. adicionado...');
          capitulosLidos.add(id);
          clientData.capitulosLidos[i] = capitulosLidos;
          _hiveController.updateClientData(clientData);
        }
      }
    }
  }

  correlacionarCapitulos(List<ModelLeitor> listaCapitulosDisponiveis,
      List<Allposts> listaCapitulos, String link) async {
    print('parte 0 erro');
    ClientDataModel clientData = await _hiveController.getClientData();
    print('parte 0.1 erro');

    // achar o manga pelo link
    
    List<dynamic> capitulosLidos = [];
    RegExp regex = RegExp('https://mangayabu.top/manga/$link',
        dotAll: true, caseSensitive: false);
    for (int i = 0; i < clientData.capitulosLidos.length; ++i) {
      try {
      clientData.capitulosLidos[i]['link'].contains(regex);
    } catch (e) {
      print('aqui esta ele!');
    }
      if (clientData.capitulosLidos[i]['link'].contains(regex)) {
        capitulosLidos = clientData.capitulosLidos[i]['capitulos'];
      }
    }

    print('parte 1 erro');

    for (int indice = 0; indice < listaCapitulos.length; ++indice) {
      bool adicionado = false;
      for (int alreadyIndice = 0;
          alreadyIndice < listaCapitulosDisponiveis.length;
          ++alreadyIndice) {
        int idCapituloDisponivel = listaCapitulosDisponiveis[alreadyIndice].id;
        if (listaCapitulos[indice].id == idCapituloDisponivel) {
          capitulosCorrelacionados.add(ModelCapitulosCorrelacionados(
            id: idCapituloDisponivel,
            capitulo: listaCapitulosDisponiveis[alreadyIndice].capitulo,
            disponivel: true,
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
    // correlacionar os capitulos lidos
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

      capitulosCorrelacionados = listaCapitulosCorrelacionadosLidos;
      print('final = ${capitulosCorrelacionados.length}');
    }
  }
}

enum BottomSheetStates { start, loading, sucess, error }
