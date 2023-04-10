import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/controllers/message_core.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

class HandleDataCore {
  final HiveController _hiveController = HiveController();
  final List<String> genres;
  final ValueNotifier<int> notifier = ValueNotifier<int>(0);
  HandleDataCore({required this.genres});

  /// add an genre
  void addGenre(String genre) {
    if (!genres.contains(genre)) {
      genres.add(genre);
      notifier.value++;
    }
  }

  /// remove an genre
  void removeGenre(String genre) {
    genres.remove(genre);
    notifier.value++;
  }

  /// save data
  void saveData(
      {required MangaInfoOffLineModel model,
      required String name,
      required String link,
      required String img,
      required String description,
      required String authors}) async {
    final List<MangaInfoOffLineModel>? models =
        await _hiveController.getBooks();
    if (models == null) {
      MessageCore.showMessage(
          "Erro ao obter os Models. at saveData in HandleDataCore");
    } else {
      for (int i = 0; i < models.length; ++i) {
        if (models[i].link == model.link) {
          models[i].name = name;
          models[i].link = link;
          models[i].img = img;
          models[i].description = description;
          models[i].authors = authors;
          models[i].genres = genres;
          break;
        }
      }
      final bool result = await _hiveController.updateBook(models);
      result
          ? MessageCore.showMessage("Alterações salvas")
          : MessageCore.showMessage(
              "Erro ao inserir os Models. at saveData in HandleDataCore");
    }
  }
}
