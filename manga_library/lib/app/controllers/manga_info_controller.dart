import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:manga_library/app/extensions/extensions.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/controllers/off_line/manga_info_off_line.dart';
import 'package:manga_library/app/models/client_data_model.dart';
import 'package:manga_library/app/models/downloads_pages_model.dart';
import 'package:manga_library/app/models/globais.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';
import 'package:manga_library/app/models/mark_chapter_model.dart';
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
  // static bool isTwoRequests = false;
  ValueNotifier<MangaInfoStates> state =
      ValueNotifier<MangaInfoStates>(MangaInfoStates.start);

  Future start(String url, int idExtension) async {
    state.value = MangaInfoStates.loading;
    try {
      // operação OffLine
      MangaInfoOffLineModel? localData =
          await _mangaInfoOffLineController.verifyDatabase(url, idExtension);

      /// adiciona o pedaco do link para ser utilizado no histórico
      GlobalData.pieceOfLink = url;
      if (localData != null) {
        debugPrint("existe na base de dados! / l= $url");

        data = localData;
        capitulosDisponiveis = localData.capitulos;

        log("at offline start length: ${capitulosDisponiveis!.length}");
        GlobalData.mangaModel = localData;
        isAnOffLineBook = true;
        // await _chaptersController.correlacionarCapitulos(
        //     capitulosDisponiveis ?? [], data.capitulos, url
        // );
        state.value = MangaInfoStates.sucess;
      } else {
        // operação OnLine
        debugPrint("iniciando o fetch! / l= $url");

        // identificar se a extensão trabalha em duas requisições
        final MangaInfoOffLineModel? dados;
        // if (isTwoRequests) {
        //   dados = await mapOfExtensions[idExtension]!.mangaDetail(url);
        //   if (dados != null) {
        //     data = dados;
        //     state.value = MangaInfoStates.sucess1;
        //   } else {
        //     state.value = MangaInfoStates.error;
        //   }
        //   capitulosDisponiveis =
        //       await fetchServiceExtensions[idExtension].fetchChapters(url);
        //   //log("at online start: ${capitulosDisponiveis!.length}");
        // } else {
        dados = await mapOfExtensions[idExtension]!.mangaDetail(url);
        if (dados != null) {
          data = dados;
          capitulosDisponiveis = data.capitulos;
          // state.value = MangaInfoStates.sucess;
        } else {
          // state.value = MangaInfoStates.error;
        }
        // }

        // log("at online start: ${capitulosDisponiveis!.length}");
        GlobalData.mangaModel = data;

        isAnOffLineBook = false;
        if (state.value != MangaInfoStates.error) {
          state.value = MangaInfoStates.sucess;
        } else {
          HomePageController.errorMessage = 'erro no null 2';
          state.value = MangaInfoStates.error;
        }
      }
    } catch (e) {
      debugPrint('$e');
      HomePageController.errorMessage = 'erro no MangaInfo: $e';
      state.value = MangaInfoStates.error;
    }
  }

  Future<bool> updateBook(String url, int idExtension,
      {bool isAnUpdateFromCore = false, String? img}) async {
    try {
      debugPrint("l= $url  - atualizando...");

      final MangaInfoOffLineModel? dados =
          await mapOfExtensions[idExtension]!.mangaDetail(url);

      if (dados != null) {
        data = dados;
      } else {
        state.value = MangaInfoStates.error;
        return false;
      }

      MangaInfoOffLineModel? offLineBook;

      if (isAnUpdateFromCore) {
        offLineBook = await _mangaInfoOffLineController.verifyDatabase(url, idExtension);
        if (offLineBook == null) {
          /// aqui retorno true -- MAS O MANGA NÃO É ATUALIZADO, já que não existe ná memória
          return true;
        }
      }

      if (isAnOffLineBook) {
        // is an off line book
        capitulosDisponiveis = dados.capitulos;
        // debugPrint("nao é twoRequests: $capitulosDisponiveis");

        // if (dados == null) {
        //   debugPrint("dd off-line true");
        //   capitulosFromOriginalServer = [];
        // } else {
        //   debugPrint("dd off-line false");
        //   capitulosFromOriginalServer = dados.capitulos;
        // }
        // mapOfExtensions[idExtension].isTwoRequests;
        await chaptersController?.update(
            capitulosDisponiveis ?? [], url, idExtension);

        final MangaInfoOffLineController mangaInfoOffLineController =
            MangaInfoOffLineController();
        debugPrint("inserindo na base de dados!");
        await mangaInfoOffLineController.updateBook(
          model: data,
          img: img ?? offLineBook?.img,
          capitulos: data.capitulos
        );
        debugPrint("inserindo com SUCESSO na base de dados!");
      } else {
        // isn't an off ine book
        capitulosDisponiveis = dados.capitulos;
        // debugPrint("nao é twoRequests: $capitulosDisponiveis");

        await chaptersController?.update(
            capitulosDisponiveis ?? [], url, idExtension);
      }
      state.value = MangaInfoStates.loading;
      // aqui deve atualizar a view totalmente
      state.value = MangaInfoStates.sucess;
      return true;
    } catch (e) {
      debugPrint("erro no update book at mangaInfoController: $e");
      state.value = MangaInfoStates.error;
      return false;
    }
  }

  void updateChaptersAfterDownload(String url, int idExtension) async {
    try {
      await chaptersController?.correlacionarDownloads(
          link: url,
          idExtension: idExtension,
          chaptersList: capitulosDisponiveis ?? []);

      await chaptersController?.updateChapters(url, idExtension);
      // }
    } catch (e) {
      debugPrint(
          "erro no updateChaptersAfterDownload at MangaInfoController: $e");
    }
  }
}

enum MangaInfoStates { start, loading, sucess, error }

/// controller dos capitulos
class ChaptersController {
  final HiveController _hiveController = HiveController();

  ValueNotifier<ChaptersStates> state =
      ValueNotifier<ChaptersStates>(ChaptersStates.start);
  static List<Capitulos> capitulosCorrelacionados = [];

  void start(
      List<Capitulos> listaCapitulos, String link, int idExtension) async {
    state.value = ChaptersStates.loading;
    // GlobalData.capitulosDisponiveis;
    try {
      debugPrint("chapter offline: ${MangaInfoController.isAnOffLineBook}");
      if (MangaInfoController.isAnOffLineBook) {
        // capitulosCorrelacionados = listaCapitulos;

        await correlacionarDownloads(
            link: mapOfExtensions[idExtension]!.getLink(link),
            idExtension: idExtension,
            chaptersList: listaCapitulos);
        await updateChapters(link, idExtension);
        await correlacionarMarks(idExtension, link); // , listaCapitulos

      } else {
        // if (MangaInfoController.isTwoRequests) {
        //   await correlacionarCapitulos(
        //       listaCapitulosDisponiveis ?? [], listaCapitulos, link,
        //       idExtension: idExtension);
        // } else {
        //   print("isn't twoRequests");
        capitulosCorrelacionados = listaCapitulos;
        await updateChapters(link, idExtension);
        await correlacionarMarks(idExtension, link);
        // }
      }
      // disponibilizar os capitulos correlacionados

      // MangaInfoController.capitulosCorrelacionados = capitulosCorrelacionados;
      // GlobalData.capitulosDisponiveis;
      // print("");
      GlobalData.mangaModel.capitulos = capitulosCorrelacionados;
      state.value = ChaptersStates.sucess;
    } catch (e) {
      HomePageController.errorMessage = 'erro no catch ChapterController: $e';
      debugPrint('erro no start ChapterController');
      debugPrint('$e');
      state.value = ChaptersStates.error;
    }
  }

  Future<bool> update(
      List<Capitulos> listaCapitulos, String link, int idExtension) async {
    try {
      capitulosCorrelacionados = listaCapitulos;
      await correlacionarDownloads(
          link: mapOfExtensions[idExtension]!.getLink(link),
          idExtension: idExtension,
          chaptersList: listaCapitulos);
      await updateChapters(link, idExtension);
      await correlacionarMarks(idExtension, link);
      // }
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

  Future<void> updateChapters(String link, int idExtension) async {
    state.value = ChaptersStates.loading;
    try {
      debugPrint('update chapters');
      // conseguir os dados
      ClientDataModel clientData = await _hiveController.getClientData();
      // achar os capitulos lidos do manga pelo link
      List<dynamic> capitulosLidos = [];
      String completUrl = link.contains("http")
          ? link
          : mapOfExtensions[idExtension]!.getLink(link);
      RegExp regex = RegExp(completUrl, dotAll: true, caseSensitive: false);

      for (int i = 0; i < clientData.capitulosLidos.length; ++i) {
        if (clientData.capitulosLidos[i]['link'].contains(regex)) {
          capitulosLidos = clientData.capitulosLidos[i]['capitulos'];
        }
      }
      debugPrint('$capitulosLidos');
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
                mark: capitulosCorrelacionados[i].mark,
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
              mark: capitulosCorrelacionados[i].mark,
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

  Future<void> marcarDesmarcar(String id, String link,
      Map<String, String> nameAndImage, int idExtension) async {
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

  // ========================================================================
  //                  ----- MARK MANAGEMENT -----
  // ========================================================================
  Future<bool> markOrRemoveMarkFromChapter(
      String link, int idExtension, String chapterId) async {
    try {
      final List<MarkChaptersModel> models = await _hiveController.getMarks();
      String completUrl = link.contains("http")
          ? link
          : mapOfExtensions[idExtension]!.getLink(link);
      MarkChaptersModel markModel =
          MarkChaptersModel(idExtension: 0, link: '', marks: []);
      for (int modelIndex = 0; modelIndex < models.length; ++modelIndex) {
        MarkChaptersModel model = models[modelIndex];
        if (model.idExtension == idExtension && model.link == completUrl) {
          markModel = model;
          models.removeAt(modelIndex);
          break;
        }
      }
      // case 0: error or not found
      if (!(markModel.idExtension == 0) && markModel.marks.isNotEmpty) {
        bool found = false;
        for (int markIndex = 0;
            markIndex < markModel.marks.length;
            ++markIndex) {
          if (chapterId == markModel.marks[markIndex]) {
            found = true;
            markModel.marks.removeWhere((id) => id == chapterId);
            models.add(markModel);
            break;
          }
        }
        if (!found) {
          markModel.marks.add(chapterId);
          models.add(markModel);
        }
      } else {
        models.add(MarkChaptersModel(
            idExtension: idExtension, link: link, marks: [chapterId]));
      }
      await _hiveController.updateMarks(models);
      return true;
    } catch (e) {
      debugPrint("erro no markOrRemoveFromChapter at ChaptersController: $e");
      return false;
    }
  }

  Future<void> correlacionarDownloads(
      {required String link,
      required int idExtension,
      required List<Capitulos> chaptersList}) async {
    List<DownloadPagesModel> donloadModels =
        await _hiveController.getDownloads();
    List<DownloadPagesModel> models = [];

    /// obtem os downloads que pertencem a este manga [ o link deve ser completo]
    for (DownloadPagesModel model in donloadModels) {
      final String completeUrl =
          mapOfExtensions[model.idExtension]!.getLink(model.link);
      if (model.idExtension == idExtension && completeUrl == link) {
        models.add(model);
      }
    }
    if (models.isNotEmpty) {
      for (int chapterIndex = 0;
          chapterIndex < chaptersList.length;
          ++chapterIndex) {
        /// caso todos os capitulos já estejam correlacionados ele para o correlacionamento
        if (models.isEmpty) break;
        // final Capitulos chapter = chaptersList[chapterIndex];
        for (int i = 0; i < models.length; ++i) {
          if (chaptersList[chapterIndex].id == models[i].id) {
            chaptersList[chapterIndex].download = true;
            chaptersList[chapterIndex].downloadPages = models[i].pages;
            models.removeAt(i);
            break;
          }
        }
      }
    }
    capitulosCorrelacionados = chaptersList;
  }

  // correlaciona os capitulos marcados
  Future<void> correlacionarMarks(int idExtension, String link) async {
    final List<MarkChaptersModel> models = await _hiveController.getMarks();
    String completUrl = link.contains("http")
        ? link
        : mapOfExtensions[idExtension]!.getLink(link);
    MarkChaptersModel markModel =
        MarkChaptersModel(idExtension: 0, link: '', marks: []);
    for (MarkChaptersModel model in models) {
      if (model.idExtension == idExtension && model.link == completUrl) {
        markModel = model;
        break;
      }
    }
    // case 0: error or not found
    if (!(markModel.idExtension == 0) && markModel.marks.isNotEmpty) {
      /// continue to implement this
      for (int markIndex = 0; markIndex < markModel.marks.length; ++markIndex) {
        final String mark = markModel.marks[markIndex];
        for (int chapterIndex = 0;
            chapterIndex < capitulosCorrelacionados.length;
            ++chapterIndex) {
          /// testa o id
          if (capitulosCorrelacionados[chapterIndex].id == mark) {
            capitulosCorrelacionados[chapterIndex].mark = true;
            break;
          }
        }
      }
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
            (dataOcultLibrary[i].books[iBook].idExtension ==
                book['idExtension'])) {
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
