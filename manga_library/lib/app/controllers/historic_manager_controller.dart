import 'package:flutter/rendering.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';

import '../models/historic_model.dart';

class ManagerHistoricController {
  final HiveController _hiveController = HiveController();

  /// inseri o model no histórico.
  /// caso ele já exista apenas atualiza o [capitulo] e a [data].
  Future<bool> insertOnHistoric(HistoricModel model) async {
    try {
      List<HistoricModel> data = await _hiveController.getHistoric();
      bool done = false;
      for (int i = 0; i < data.length; ++i) {
        if ((data[i].link == model.link) &&
            (data[i].idExtension == model.idExtension)) {
          // caso já exista
          data[i].chapter = model.chapter;
          data[i].date = model.date;
          bool updated = await _hiveController.updateHistoric(data);
          // caso tenha um erro ao atualizar
          if (!updated) return false;
          done = true;
        }
      }
      // caso não tenha um registro
      if (!done) {
        data.add(model);
        bool updated = await _hiveController.updateHistoric(data);
        // caso tenha um erro ao atualizar
        if (!updated) return false;
      }
      return true;
    } catch (e) {
      debugPrint("erro no indertOnHistoric at ManagerHistoricController: $e");
      return false;
    }
  }

  Future<bool> removeFromHistoric(HistoricModel model) async {
    try {
      List<HistoricModel> data = await _hiveController.getHistoric();
      data.removeWhere((element) =>
          (element.link == model.link) &&
          (element.idExtension == model.idExtension));
      bool updated = await _hiveController.updateHistoric(data);
      // caso tenha um erro ao atualizar
      if (!updated) return false;
      return true;
    } catch (e) {
      debugPrint("erro no indertOnHistoric at ManagerHistoricController: $e");
      return false;
    }
  }

  Future<bool> cleanHistoric() async {
    try {
      bool updated = await _hiveController.updateHistoric([]);
      // caso tenha um erro ao atualizar
      if (!updated) return false;
      return true;
    } catch (e) {
      debugPrint("erro no cleanHistoric at  ManagerHistoricController: $e");
      return false;
    }
  }

  String getDateTime() {
    final String date = '${DateTime.now()}';
    List<String> splitedDate = date.split('.');
    return splitedDate[0];
  }
}
