import 'package:flutter/foundation.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';

class HistoricController {
  final HiveController _hiveController = HiveController();
  ValueNotifier<HistoricStates> state =
      ValueNotifier<HistoricStates>(HistoricStates.start);
  void start() async {
    try {
      state.value = HistoricStates.loading;
      // implement this
      state.value = HistoricStates.sucess;
    } catch (e) {
      debugPrint("erro no start at HistoricController: $e");
      state.value = HistoricStates.error;
    }
  }
}

enum HistoricStates { start, loading, sucess, error }
