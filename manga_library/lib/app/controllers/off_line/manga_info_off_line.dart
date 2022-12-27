import 'dart:developer';

import 'package:flutter/rendering.dart';
import 'package:manga_library/app/extensions/extensions.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/models/globais.dart';
import 'package:manga_library/app/models/leitor_pages.dart';

import '../../models/manga_info_offline_model.dart';

class MangaInfoOffLineController {
  final HiveController _hiveController = HiveController();

  Future<MangaInfoOffLineModel?> verifyDatabase(
      String link, int idExtension) async {
    try {
      List<MangaInfoOffLineModel>? data = await _hiveController.getBooks();
      if (data != null) {
        MangaInfoOffLineModel? model =
            _searchBook(link: link, idExtension: idExtension, lista: data);
        if (model == null) {
          return null;
        } else {
          return model;
        }
      } else {
        throw Error();
      }
    } catch (e) {
      debugPrint('erro no verifyDatabase at MangaInfoOffLineController: $e');
      return null;
    }
  }

  MangaInfoOffLineModel? _searchBook(
      {required String link,
      required int idExtension,
      required List<MangaInfoOffLineModel> lista}) {
    // o link pode acabar vindo inteiro (downloads)
    if (!link.contains("/")) {
      link = mapOfExtensions[idExtension]!.getLink(link);
    }
    RegExp regex = RegExp(link, caseSensitive: false);
    for (int i = 0; i < lista.length; ++i) {
      if ((lista[i].link.contains(regex)) &&
          (lista[i].idExtension == idExtension)) {
        debugPrint("achado na memória!");
        return lista[i];
      }
    }
    debugPrint("não encontrei o manga na memoria");
    return null;
  }

  // monta e  retorna um List<ModelPages>
  List<ModelPages> buildModelLeitor(MangaInfoOffLineModel model) {
    return model.capitulos
        .map((Capitulos cap) =>
            ModelPages(capitulo: cap.capitulo, id: cap.id, pages: cap.pages))
        .toList();
  }

  // add an offline book

  Future<bool> addBook(
      {required MangaInfoOffLineModel model,
      required List<Capitulos> capitulos}) async {
    try {
      var data = await _hiveController.getBooks();
      MangaInfoOffLineModel newModel = MangaInfoOffLineModel(
        name: model.name,
        authors: model.authors,
        state: model.state,
        link: model.link,
        idExtension: model.idExtension,
        img: model.img,
        description: model.description,
        chapters: model.chapters,
        alternativeName: model.alternativeName,
        genres: model.genres,
        capitulos: capitulos,
      );
      data!.add(newModel);
      // for (Capitulos element in newModel.capitulos) {
      //   print("capitulo addbook:  ${element.capitulo} / ${element.disponivel}");
      // }
      await _hiveController.updateBook(data);
      debugPrint(" === Adicionado ao Banco de Dados! === ");
      return true;
    } catch (e) {
      debugPrint("erro no addBook at MangaInfoOffLineController: $e");
      return false;
    }
  }

  // delete an offline book

  Future deleteBook({required String link, required int idExtension}) async {
    List<MangaInfoOffLineModel>? data = await _hiveController.getBooks();
    if (data != null) {
      RegExp regex = RegExp(link, caseSensitive: false);
      data.removeWhere((MangaInfoOffLineModel element) {
        return (element.link.contains(regex)) && (element.idExtension == idExtension);
      });
      await _hiveController.updateBook(data);
    }
  }

  // update an offline book

  Future<bool> updateBook(
      {required MangaInfoOffLineModel model,
      required List<Capitulos> capitulos,
      String? img}) async {
    try {
      RegExp regex = RegExp(model.link, caseSensitive: false);
      List<MangaInfoOffLineModel>? data = await _hiveController.getBooks();
      /// verificar se deve atualizar as capas

      if (data != null) {
        for (int i = 0; i < data.length; ++i) {
          if (data[i].link.contains(regex) &&
              data[i].idExtension == model.idExtension) {
            log("manga off-line found!!! == doing changes");
            model.capitulos = capitulos;
            data[i] = model;
            if (GlobalData.settings.updateTheCovers) {
              data[i].img = img!;
            }
            bool sucess = await _hiveController.updateBook(data);
            log("Atualização Executada com : ${sucess ? "sucesso" : "falha"}!");
            break;
          }
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("erro no updateBook at MangaInfoOffLineController: $e");
      return false;
    }
  }
}