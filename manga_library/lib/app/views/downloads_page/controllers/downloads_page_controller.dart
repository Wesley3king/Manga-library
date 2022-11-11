import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/models/downloads_pages_model.dart';

class DownloadsPageController {
  final HiveController _hiveController = HiveController();
  final ValueNotifier<DownloadsPageStates> state =
      ValueNotifier(DownloadsPageStates.start);
  List<DownloadPagesModel> data = [];

  void start() async {
    state.value = DownloadsPageStates.loading;
    try {
      data = await _hiveController.getDownloads();
      state.value = DownloadsPageStates.sucess;
    } catch (e) {
      debugPrint("erro no start at DownloadsPageController: $e");
      state.value = DownloadsPageStates.error;
    }
  }
}

enum DownloadsPageStates { start, loading, sucess, error }
