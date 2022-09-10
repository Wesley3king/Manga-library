import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/models/leitor_model.dart';
import 'package:manga_library/app/models/manga_info_model.dart';

import '../../models/manga_info_offline_model.dart';

class MangaInfoOffLineController {
  final HiveController _hiveController = HiveController();
  Future<ModelMangaInfo?> verifyDatabase(String link) async {
    try {
      List<MangaInfoOffLineModel>? data = await _hiveController.getBooks();
      if (data != null) {
        MangaInfoOffLineModel? model = _searchBook(link: link, lista: data);
        if (model == null) {
          return null;
        } else {
          return _buildMangaInfoModel(model);
        }
      } else {
        throw Error();
      }
    } catch (e) {
      print('erro no verifyDatabase at MangaInfoOffLineController: $e');
      return null;
    }
  }

  MangaInfoOffLineModel? _searchBook(
      {required String link, required List<MangaInfoOffLineModel> lista}) {
    RegExp regex = RegExp(link, caseSensitive: false);
    for (int i = 0; i < lista.length; ++i) {
      if (lista[i].name.contains(regex)) {
        print("achado na memória!");
        return lista[i];
      }
    }
    print("não encontrei o manga na memoria");
    return null;
  }

  ModelMangaInfo _buildMangaInfoModel(MangaInfoOffLineModel model) {
    return ModelMangaInfo(
      chapterName: model.name,
      chapters: model.chapters,
      description: model.description,
      cover: model.img,
      genres: model.genres,
      chapterList: "off line doesn't have this",
      alternativeName: model.alternativeName,
      allposts: model.capitulos
          .map((cap) => Allposts(id: cap.id, num: cap.capitulo))
          .toList(),
    );
  }

  // add an offline book

  Future<bool> addBook(
      {required ModelMangaInfo model,
      required String link,
      required List<ModelLeitor> capitulos,
      required List<ModelCapitulosCorrelacionados>
          capitulosCorrelacionados}) async {
    try {
      var data = await _hiveController.getBooks();
      var mangaInfoOffLineModel = MangaInfoOffLineModel(
        name: model.chapterName,
        chapters: model.chapters,
        description: model.description,
        img: model.cover,
        link: link,
        genres: model.genres.map((e) => "$e").toList(),
        alternativeName: model.chapterList,
        capitulos: _correlacionarCapitulosOffLineForFirstTime(
            todos: model.allposts,
            capitulos: capitulos,
            capitulosCorrelacionados: capitulosCorrelacionados),
      );
      data!.add(mangaInfoOffLineModel);
      await _hiveController.updateBook(data);
      return true;
    } catch (e) {
      print("erro no addBook at MangaInfoOffLineController: $e");
      return false;
    }
  }

  // update an offline book

  Future<bool> updateBook(
      {required ModelMangaInfo model,
      required String link,
      required List<ModelLeitor> capitulos,
      required List<ModelCapitulosCorrelacionados>
          capitulosCorrelacionados}) async {
    try {
      var data = await _hiveController.getBooks();
      var mangaInfoOffLineModel = MangaInfoOffLineModel(
        name: model.chapterName,
        chapters: model.chapters,
        description: model.description,
        img: model.cover,
        link: link,
        genres: model.genres.map((e) => "$e").toList(),
        alternativeName: model.chapterList,
        capitulos: _correlacionarCapitulosOffLineForFirstTime(
            todos: model.allposts,
            capitulos: capitulos,
            capitulosCorrelacionados: capitulosCorrelacionados),
      );

      data!.add(mangaInfoOffLineModel);
      await _hiveController.updateBook(data);
      return true;
    } catch (e) {
      print("erro no updateBook at MangaInfoOffLineController: $e");
      return false;
    }
  }

  List<Capitulos> _correlacionarCapitulosOffLineForFirstTime(
      {required List<Allposts> todos,
      required List<ModelLeitor> capitulos,
      required List<ModelCapitulosCorrelacionados> capitulosCorrelacionados}) {
    List<Capitulos> listaResultado = [];
    for (int i = 0; i < todos.length; ++i) {
      bool adicionado = false;
      for (int d = 0; d < capitulos.length; ++i) {
        if (todos[i].id == capitulos[d].id) {
          listaResultado.add(Capitulos(
            id: todos[i].id,
            capitulo: todos[i].num,
            download: false,
            readed: capitulosCorrelacionados[i].readed,
            disponivel: capitulosCorrelacionados[i].disponivel,
            downloadPages: [],
            pages: capitulos[d].pages,
          ));
          adicionado = true;
          break;
        }
      }
      if (!adicionado) {
        listaResultado.add(Capitulos(
          id: todos[i].id,
          capitulo: todos[i].num,
          download: false,
          readed: capitulosCorrelacionados[i].readed,
          disponivel: capitulosCorrelacionados[i].disponivel,
          downloadPages: [],
          pages: [],
        ));
      }
    }

    return listaResultado;
  }
}

class UpdateBook {
  final HiveController _hiveController = HiveController();

  Future<bool?> updateImg(
      {required String link, required ModelMangaInfo model}) async {
    try {
      RegExp regex = RegExp(link, caseSensitive: false);
      List<MangaInfoOffLineModel>? data = await _hiveController.getBooks();

      if (data != null) {
        bool modificated = false;
        for (int i = 0; i < data.length; ++i) {
          if (data[i].link.contains(regex)) {
            data[i].img = model.cover;
            modificated = true;
            break;
          }
        }
        if (modificated) {
          await _hiveController.updateBook(data);
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print("error no UpdateBook at MangaInfoOffLineController: $e");
      return false;
    }
  }

  Future updateChapters(
      {required String link,
      required List<Allposts> todos,
      required List<ModelLeitor> capitulos,
      required List<ModelCapitulosCorrelacionados>
          capitulosCorrelacionados}) async {}

  Future<List<Capitulos>?> _correlacionarCapitulosOffLineForUpdate(
      {required String link,
      required List<ModelLeitor> capitulos,
      required List<ModelCapitulosCorrelacionados>
          capitulosCorrelacionados}) async {
    List<MangaInfoOffLineModel>? data = await _hiveController.getBooks();
    RegExp regex = RegExp(link, caseSensitive: false);
    MangaInfoOffLineModel? model;
    if (data != null) {
      for (int i = 0; i < data.length; ++i) {
        if (data[i].link.contains(regex)) {
          model = data[i];
          break;
        }
      }
      List<Capitulos> listaResultado = [];
      for (int i = 0; i < capitulosCorrelacionados.length; ++i) {
        bool adicionado = false;
        for (int d = 0; d < capitulos.length; ++i) {
          if (capitulosCorrelacionados[i].id == capitulos[d].id) {
            adicionado = true;
            break;
          }
        }
        if (!adicionado) {
          listaResultado.add(Capitulos(
            id: capitulosCorrelacionados[i].id,
            capitulo: capitulosCorrelacionados[i].capitulo,
            download: false,
            readed: false,
            disponivel: capitulosCorrelacionados[i].disponivel,
            downloadPages: [],
            pages: [],
          ));
        }
      }
      return listaResultado;
    } else {
      return null;
    }
  }
}
