import 'dart:developer';

import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/models/leitor_pages.dart';
import 'package:manga_library/app/models/manga_info_model.dart';

import '../../models/manga_info_offline_model.dart';

class MangaInfoOffLineController {
  final HiveController _hiveController = HiveController();
  // final UpdateBook _updateBookController = UpdateBook();

  Future<MangaInfoOffLineModel?> verifyDatabase(String link) async {
    try {
      List<MangaInfoOffLineModel>? data = await _hiveController.getBooks();
      if (data != null) {
        MangaInfoOffLineModel? model = _searchBook(link: link, lista: data);
        if (model == null) {
          return null;
        } else {
          return model;
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
      print("iniciar!");
      print("quantidade de mangas = ${lista.length}");
      if (lista[i].link.contains(regex)) {
        print("achado na memória!");
        return lista[i];
      }
    }
    print("não encontrei o manga na memoria");
    return null;
  }

  // monta e retorna um ModelMangaInfo
  // ModelMangaInfo buildMangaInfoModel(MangaInfoOffLineModel model) {
  //   return ModelMangaInfo(
  //     chapterName: model.name,
  //     chapters: model.chapters,
  //     description: model.description,
  //     cover: model.img,
  //     genres: model.genres,
  //     chapterList: "off line doesn't have this",
  //     alternativeName: model.alternativeName,
  //     allposts: model.capitulos
  //         .map((cap) => Allposts(
  //             id: cap.id, num: cap.capitulo, disponivel: cap.disponivel))
  //         .toList(),
  //   );
  // }

  // monta e  retorna um List<ModelPages>
  List<ModelPages> buildModelLeitor(MangaInfoOffLineModel model) {
    return model.capitulos
        .map((Capitulos cap) =>
            ModelPages(capitulo: cap.capitulo, id: cap.id, pages: cap.pages))
        .toList();
  }

  // monta e retorna um List<ModelCapitulosCorrelacionados>
  List<ModelCapitulosCorrelacionados> buildModelCapitulosCorrelacionados(
      MangaInfoOffLineModel model) {
    var lista = model.capitulos.map((Capitulos cap) {
      print("mt1 - ${cap.disponivel ? "T" : "F"}");
      var md = ModelCapitulosCorrelacionados(
          id: cap.id,
          capitulo: cap.capitulo,
          disponivel: cap.disponivel,
          readed: cap.readed);
      print("mt2 - ${md.disponivel ? "T" : "F"}");
      return md;
    }).toList();

    return lista;
  }

  // add an offline book

  Future<bool> addBook(
      {required MangaInfoOffLineModel model,
      required List<Capitulos> capitulos}) async {
    try {
      var data = await _hiveController.getBooks();
      MangaInfoOffLineModel newModel = MangaInfoOffLineModel(
        name: model.name,
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
      for (Capitulos element in newModel.capitulos) {
        print("capitulo addbook:  ${element.capitulo} / ${element.disponivel}");
      }
      await _hiveController.updateBook(data);
      print("terinado!");
      return true;
    } catch (e) {
      print("erro no addBook at MangaInfoOffLineController: $e");
      return false;
    }
  }

  // delete an offline book

  Future deleteBook({required String link}) async {
    List<MangaInfoOffLineModel>? data = await _hiveController.getBooks();
    if (data != null) {
      RegExp regex = RegExp(link, caseSensitive: false);
      data.removeWhere(
          (MangaInfoOffLineModel element) => element.link.contains(regex));
      await _hiveController.updateBook(data);
    }
  }

  // update an offline book

  Future<bool> updateBook(
      {required MangaInfoOffLineModel model,
      required List<Capitulos> capitulos}) async {
    try {
      RegExp regex = RegExp(model.link, caseSensitive: false);
      List<MangaInfoOffLineModel>? data = await _hiveController.getBooks();

      if (data != null) {
        for (int i = 0; i < data.length; ++i) {
          if (data[i].link.contains(regex)) {
            log("manga off-line found!!! == doing changes");
            model.capitulos = capitulos;
            data[i] = model;
            break;
          }
        }
        bool sucess = await _hiveController.updateBook(data);
        log("operação de atualização: ${sucess ? "sucess" : "failed"}!");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("erro no updateBook at MangaInfoOffLineController: $e");
      return false;
    }
  }

  // List<Capitulos> _correlacionarCapitulosOffLineForFirstTime(
  //     {required List<Allposts> todos,
  //     required List<ModelLeitor> capitulos,
  //     required List<ModelCapitulosCorrelacionados> capitulosCorrelacionados}) {
  //   print(
  //       "correlacionando os capitulos: ${capitulosCorrelacionados.length} / ${capitulos.length}");
  //   List<Capitulos> listaResultado = [];
  //   for (int i = 0; i < capitulosCorrelacionados.length; ++i) {
  //     bool adicionado = false;
  //     for (int d = 0; d < capitulos.length; ++d) {
  //       // print(
  //       //     "first: ${todos[i].id} == ${capitulos[d].id} / ${todos[i].id == capitulos[d].id ? "T" : "F"}");
  //       if (capitulosCorrelacionados[i].id == capitulos[d].id) {
  //         listaResultado.add(Capitulos(
  //           id: todos[i].id,
  //           capitulo: capitulosCorrelacionados[i].capitulo,
  //           download: false,
  //           readed: capitulosCorrelacionados[i].readed,
  //           disponivel: capitulosCorrelacionados[i].disponivel,
  //           downloadPages: [],
  //           pages: capitulos[d]
  //               .pages
  //               .map<String>((dynamic e) => e.toString())
  //               .toList(),
  //         ));
  //         adicionado = true;
  //         break;
  //       }
  //     }
  //     if (!adicionado) {
  //       listaResultado.add(Capitulos(
  //         id: todos[i].id,
  //         capitulo: todos[i].num,
  //         download: false,
  //         readed: capitulosCorrelacionados[i].readed,
  //         disponivel: capitulosCorrelacionados[i].disponivel,
  //         downloadPages: [],
  //         pages: [],
  //       ));
  //     }
  //   }
  //   print("listaResultado: ${listaResultado.length}");
  //   return listaResultado;
  // }
}

/*
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
    MangaInfoOffLineModel model = MangaInfoOffLineModel(
        name: "",
        description: "",
        img: "",
        link: "",
        genres: [],
        alternativeName: false,
        chapters: 0,
        capitulos: []);

    if (data != null) {
      List<Capitulos> listaResultado = [];
      // indentifica o manga
      for (int i = 0; i < data.length; ++i) {
        if (data[i].link.contains(regex)) {
          model = data[i];

          // inicia o processo de atualização
          for (int i = 0; i < capitulosCorrelacionados.length; ++i) {
            bool existeInDB = false;
            // verifica se ele existe na Db
            for (int d = 0; d < model.capitulos.length; ++d) {
              if (capitulosCorrelacionados[i].id == model.capitulos[d].id) {
                existeInDB = true;
                // verifica se tem as paginas, caso não tenha as adicionara as paginas
                if (model.capitulos[d].pages.isEmpty) {
                  for (int e = 0; e < capitulos.length; ++e) {
                    if (model.capitulos[d].id == capitulos[e].id) {
                      model.capitulos[d].pages = capitulos[e].pages;
                      break;
                    }
                  }
                }
                break;
              }
            }

            if (!existeInDB) {
              // caso o capitulos não exista, o adicionara:
              bool adicinado = false;
              for (int n = 0; n < capitulos.length; ++n) {
                if (capitulosCorrelacionados[i].id == capitulos[n].id) {
                  listaResultado.add(Capitulos(
                    id: capitulosCorrelacionados[i].id,
                    capitulo: capitulosCorrelacionados[i].capitulo,
                    download: false,
                    readed: false,
                    disponivel: capitulosCorrelacionados[i].disponivel,
                    downloadPages: [],
                    pages: capitulos[n].pages,
                  ));
                  adicinado = true;
                  break;
                }
              }
              // caso não tenhamos as paginas do capitulo
              if (!adicinado) {
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
          }
          break;
        }
      }
      // caso não tenha achado o manga deve adiciona-lo:
      if (model.link == "") {
        print("falha ao achar o manga no updateChapters at UpdateBook");
        return null;
      }

      return listaResultado;
    } else {
      print(
          "falha ao achar a lista de manga do db no updateChapters at UpdateBook");
      return null;
    }
  }
}
*/