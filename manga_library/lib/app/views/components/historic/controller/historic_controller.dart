import 'package:flutter/foundation.dart';
import 'package:manga_library/app/controllers/historic_manager_controller.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/models/historic_model.dart';
import 'package:manga_library/app/views/components/historic/historic_process_builders.dart';

class HistoricController {
  final HiveController _hiveController = HiveController();
  final ManagerHistoricController managerHistoricController =
      ManagerHistoricController();
  ValueNotifier<HistoricStates> state =
      ValueNotifier<HistoricStates>(HistoricStates.start);
  // List<HistoricModel> data = [];

  void start(HistoricProcessBuilders builder) async {
    try {
      state.value = HistoricStates.loading;
      // data = ;
      List<HistoricModel> data = await _hiveController.getHistoric();
      builder.processHistoricBooks(data.reversed.toList());
      state.value = HistoricStates.sucess;
    } catch (e) {
      debugPrint("erro no start at HistoricController: $e");
      state.value = HistoricStates.error;
    }
  }

  /// limpa o histórico
  Future<String> cleanHistoric() async {
    bool response = await managerHistoricController.cleanHistoric();
    if (!response) return "erro ao limpar o histórico!";
    return "Limpo!";
  }

  /// atualiza a view depois de uma modificação
  // void update() {

  // }
}

enum HistoricStates { start, loading, sucess, error }
