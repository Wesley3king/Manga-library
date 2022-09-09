import 'package:manga_library/app/controllers/hive/hive_controller.dart';
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

  Future<bool> addBook(ModelMangaInfo model) async {
    try {
      // implement this method! List<MangaInfoOffLineModel>
      var data = await _hiveController.getBooks();
      
      return true;
    } catch (e) {
      print("erro no addBook at MangaInfoOffLineController: $e");
      return false;
    }
  }

  // update an offline book

  Future<ModelMangaInfo?> updateBook() async {
    try {
      // implement this method!
    } catch (e) {
      print("erro no updateBook at MangaInfoOffLineController: $e");
      return null;
    }
  }
}
