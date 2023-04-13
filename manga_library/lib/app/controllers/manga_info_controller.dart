import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/library_management/library_management_controller.dart';
import 'package:manga_library/app/controllers/message_core.dart';
import 'package:manga_library/app/extensions/extensions.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/controllers/off_line/manga_info_off_line.dart';
import 'package:manga_library/app/models/client_data_model.dart';
import 'package:manga_library/app/models/continue_to_read_model.dart';
import 'package:manga_library/app/models/downloads_pages_model.dart';
import 'package:manga_library/app/models/globais.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';
import 'package:manga_library/app/models/mark_chapter_model.dart';

import '../models/libraries_model.dart';

class MangaInfoController {
  final MangaInfoOffLineController _mangaInfoOffLineController =
      MangaInfoOffLineController();
  static ChaptersController? chaptersController;

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
      debugPrint("start MANGA DETAIL: $url");
      // operação OffLine
      MangaInfoOffLineModel? localData =
          await _mangaInfoOffLineController.verifyDatabase(url, idExtension);

      /// adiciona o pedaco do link para ser utilizado no histórico
      GlobalData.pieceOfLink = url;
      if (localData != null) {
        data = localData;
        capitulosDisponiveis = localData.capitulos;

        GlobalData.mangaModel = localData;
        isAnOffLineBook = true;
        state.value = MangaInfoStates.sucess;
      } else {
        // operação OnLine
        final MangaInfoOffLineModel? dados;
        dados = await mapOfExtensions[idExtension]!.mangaDetail(url);
        isAnOffLineBook = false;
        if (dados != null) {
          data = dados;
          capitulosDisponiveis = data.capitulos;
          state.value = MangaInfoStates.sucess;
        } else {
          state.value = MangaInfoStates.error;
          MessageCore.showMessage(
              "Falha ao Obter os Dados de: ${mapOfExtensions[idExtension]!.nome}");
        }
        GlobalData.mangaModel = data;
      }
    } catch (e) {
      debugPrint('Erro no start at MangaInfo: $e');
      state.value = MangaInfoStates.error;
      MessageCore.showMessage("Erro em MangaInfo");
    }
  }

  Future<bool> updateBook(String url, int idExtension,
      {bool isAnUpdateFromCore = false, String? img}) async {
    try {
      // debugPrint("l= $url  - atualizando...");

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
        offLineBook =
            await _mangaInfoOffLineController.verifyDatabase(url, idExtension);
        if (offLineBook == null) {
          /// aqui retorno true -- MAS O MANGA NÃO É ATUALIZADO, já que não existe ná memória
          return true;
        }
      }

      if (isAnOffLineBook) {
        // is an off line book
        capitulosDisponiveis = dados.capitulos;

        await chaptersController?.update(
            capitulosDisponiveis ?? [], url, idExtension);

        final MangaInfoOffLineController mangaInfoOffLineController =
            MangaInfoOffLineController();
        await mangaInfoOffLineController.updateBook(
            model: data,
            img: img ?? offLineBook?.img,
            capitulos: data.capitulos);
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
      MessageCore.showMessage("Atualizado com sucesso!");
      state.value = MangaInfoStates.sucess;
      return true;
    } catch (e) {
      debugPrint("erro no update book at mangaInfoController: $e");
      state.value = MangaInfoStates.error;
      MessageCore.showMessage("Erro ao atualizar");
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
  ContinueToReadModel? continueToRead;

  void start(
      List<Capitulos> listaCapitulos, String link, int idExtension) async {
    state.value = ChaptersStates.loading;
    // GlobalData.capitulosDisponiveis;
    try {
      // debugPrint("chapter offline: ${MangaInfoController.isAnOffLineBook}");
      if (MangaInfoController.isAnOffLineBook) {
        // capitulosCorrelacionados = listaCapitulos;

        await correlacionarDownloads(
            link: mapOfExtensions[idExtension]!.getLink(link),
            idExtension: idExtension,
            chaptersList: listaCapitulos);
        await updateChapters(link, idExtension);
        await correlacionarMarks(idExtension, link); // , listaCapitulos
      } else {
        capitulosCorrelacionados = listaCapitulos;
        await updateChapters(link, idExtension);
        await correlacionarMarks(idExtension, link);
        // }
      }
      setCountinueToRead();
      GlobalData.mangaModel.capitulos = capitulosCorrelacionados;
      state.value = ChaptersStates.sucess;
    } catch (e) {
      MessageCore.showMessage('Erro no start at ChaptersController');
      debugPrint('Erro no start ChaptersController: $e');
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

      state.value = ChaptersStates.loading;
      debugPrint("atualizando a view!");
      state.value = ChaptersStates.sucess;
      return true;
    } catch (e) {
      debugPrint('Erro no update ChaptersController: $e');
      state.value = ChaptersStates.error;
      return false;
    }
  }

  Future<void> updateChapters(String link, int idExtension) async {
    state.value = ChaptersStates.loading;
    try {
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

      if (capitulosLidos.isNotEmpty) {
        for (int i = 0; i < capitulosCorrelacionados.length; ++i) {
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
        // debugPrint("---------- listaCapitulosCorrelacionados");
        // debugPrint('$listaCapitulosCorrelacionadosLidos');
        capitulosCorrelacionados = listaCapitulosCorrelacionadosLidos;
      }
      debugPrint('--------- update chapters finalizado -----------');
      setCountinueToRead();
      state.value = ChaptersStates.sucess;
    } catch (e) {
      debugPrint('Erro no updateChapters at ChaptersController: $e');
      state.value = ChaptersStates.error;
    }
  }

  // ==========================================================
  //    ---------- Obtem o Capitulo a ser lido -------------
  // ==========================================================
  void setCountinueToRead() {
    bool foundChapter = false;
    for (int i = 0; i < capitulosCorrelacionados.length; ++i) {
      if (capitulosCorrelacionados[i].readed) {
        if (i != 0) {
          continueToRead = ContinueToReadModel(
              id: capitulosCorrelacionados[i - 1].id,
              chapter: capitulosCorrelacionados[i - 1].capitulo,
              isStart: false);
        } else {
          continueToRead = ContinueToReadModel(
              id: capitulosCorrelacionados[i].id,
              chapter: capitulosCorrelacionados[i].capitulo,
              isStart: false);
        }
        foundChapter = true;
        debugPrint('CountinueToRead - Configurado!');
        break;
      }
    }
    if (!foundChapter) {
      final int maxIndice = capitulosCorrelacionados.length - 1;
      continueToRead = ContinueToReadModel(
          id: capitulosCorrelacionados[maxIndice].id,
          chapter: capitulosCorrelacionados[maxIndice].capitulo,
          isStart: true);
    }
  }

  Future<void> marcarDesmarcar(String id, String link,
      Map<String, String> nameAndImage, int idExtension) async {
    ClientDataModel clientData = await _hiveController.getClientData();
    // debugPrint('${clientData.capitulosLidos}');

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
      debugPrint('O model não existe! adicionando...');
      await _hiveController.updateClientData(clientData);
    }
    // debugPrint('marcar desmarcar concluido!');
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
  /// CONTROLLERS
  final HiveController hiveController = HiveController();
  final MangaInfoOffLineController mangaInfoOffLineController =
      MangaInfoOffLineController();

  /// MODELS
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

  Future<void> addOrRemoveFromLibrary(
      List<Map> categoryList, Map<String, dynamic> book,
      {required String link, required MangaInfoOffLineModel model}) async {
    dataLibrary = await hiveController.getLibraries();
    bool removeBookFromDb = true;

    for (int categoryIndex = 0;
        categoryIndex < categoryList.length;
        ++categoryIndex) {
      bool isInTheCategory = false;
      for (int bookIndex = 0;
          bookIndex < dataLibrary[categoryIndex].books.length;
          ++bookIndex) {
        // check if they are the same book
        if (testBook(
            dataLibraryName: dataLibrary[categoryIndex].library,
            categoryName: categoryList[categoryIndex]['library'],
            book: book,
            bookLibrary: dataLibrary[categoryIndex].books[bookIndex])) {
          isInTheCategory = true;
          if (!categoryList[categoryIndex]['selected']) {
            debugPrint('remover da library');
            dataLibrary[categoryIndex] = removeFromLibrary(
                dataLibrary: dataLibrary[categoryIndex], book: book);
            break;
          } else {
            removeBookFromDb = false;
          }
        }
      }
      // tests to add the book to this category
      if (!isInTheCategory && categoryList[categoryIndex]['selected']) {
        debugPrint('adicionar a library');
        removeBookFromDb = false;
        dataLibrary[categoryIndex] =
            addToLibrary(dataLibrary: dataLibrary[categoryIndex], book: book);
      }
    }
    // save to database
    await hiveController.updateLibraries(dataLibrary);
    // add or remove from database
    if (!MangaInfoController.isAnOffLineBook) {
      await addToDB(
        link: link,
        model: model,
      );
    } else if (removeBookFromDb) {
      bool inOtherLibrary = await isInOcultLibrary(
          hiveController: hiveController,
          link: link,
          idExtension: book['idExtension']);
      if (!inOtherLibrary) {
        await removeFromDB(link: link, idExtension: book['idExtension']);
      }
    }
  }
  // ==========================================================================
  //                  ---- OCULT LIBRARY ----
  // ==========================================================================

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

  /// adicionar ou remover da ocultLibrary (biblioteca oculta)
  Future<void> addOrRemoveFromOcultLibrary(
      List<Map> categoryList, Map<String, dynamic> book,
      {required String link, required MangaInfoOffLineModel model}) async {
    dataOcultLibrary = await hiveController.getOcultLibraries();
    bool removeBookFromDb = true;

    for (int categoryIndex = 0;
        categoryIndex < categoryList.length;
        ++categoryIndex) {
      bool isInTheCategory = false;
      for (int bookIndex = 0;
          bookIndex < dataOcultLibrary[categoryIndex].books.length;
          ++bookIndex) {
        // check if they are the same book
        if (testBook(
            dataLibraryName: dataOcultLibrary[categoryIndex].library,
            categoryName: categoryList[categoryIndex]['library'],
            book: book,
            bookLibrary: dataOcultLibrary[categoryIndex].books[bookIndex])) {
          isInTheCategory = true;
          if (!categoryList[categoryIndex]['selected']) {
            debugPrint('remover da library');
            dataOcultLibrary[categoryIndex] = removeFromLibrary(
                dataLibrary: dataOcultLibrary[categoryIndex], book: book);
            break;
          } else {
            removeBookFromDb = false;
          }
        }
      }
      // tests to add the book to this category
      if (!isInTheCategory && categoryList[categoryIndex]['selected']) {
        debugPrint('adicionar a library');
        removeBookFromDb = false;
        dataOcultLibrary[categoryIndex] = addToLibrary(
            dataLibrary: dataOcultLibrary[categoryIndex], book: book);
      }
    }
    // save to database
    await hiveController.updateOcultLibraries(dataOcultLibrary);
    // add or remove from database
    if (!MangaInfoController.isAnOffLineBook) {
      await addToDB(
        link: link,
        model: model,
      );
    } else if (removeBookFromDb) {
      bool inOtherLibrary = await isInLibrary(
          hiveController: hiveController,
          link: link,
          idExtension: book['idExtension']);
      if (!inOtherLibrary) {
        await removeFromDB(link: link, idExtension: book['idExtension']);
      }
    }
  }

  /// remove book from database
  Future<bool> removeFromDB(
      {required String link, required int idExtension}) async {
    debugPrint("--- deleting a book");
    try {
      return mangaInfoOffLineController.deleteBook(
          link: link, idExtension: idExtension);
    } catch (e) {
      debugPrint("erro no removeFromDB at DialogController: $e");
      return false;
    }
  }

  /// add book to database
  Future<bool> addToDB(
      {required String link, required MangaInfoOffLineModel model}) async {
    debugPrint("--- adding a book");
    return await mangaInfoOffLineController.addBook(
        model: model, capitulos: ChaptersController.capitulosCorrelacionados);
  }
}
