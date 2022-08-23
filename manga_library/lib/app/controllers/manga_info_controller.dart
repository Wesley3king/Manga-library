import 'package:flutter/material.dart';
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
  List<ModelCapitulosCorrelacionados> capitulosCorrelacionados = [];

  ValueNotifier<BottomSheetStates> state =
      ValueNotifier<BottomSheetStates>(BottomSheetStates.start);

  start(List<ModelLeitor>? listaCapitulosDisponiveis,
      List<Allposts> listaCapitulos) {
    state.value = BottomSheetStates.loading;
    try {
      print('start');
      correlacionarCapitulos(listaCapitulosDisponiveis ?? [], listaCapitulos);
      print('------- end');
      print(capitulosCorrelacionados);
      state.value = BottomSheetStates.sucess;
    } catch (e) {
      print(e);
      state.value = BottomSheetStates.error;
    }
  }

  correlacionarCapitulos(List<ModelLeitor> listaCapitulosDisponiveis,
      List<Allposts> listaCapitulos) {
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
  }
}

enum BottomSheetStates { start, loading, sucess, error }
