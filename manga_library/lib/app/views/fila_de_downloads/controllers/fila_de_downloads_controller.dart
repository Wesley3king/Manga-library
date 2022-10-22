import 'package:flutter/material.dart';

class FilaDeDownloadsController {
  ValueNotifier<FilaDeDownloadsStates> state =
      ValueNotifier<FilaDeDownloadsStates>(FilaDeDownloadsStates.start);
  void start() async {
    try {
      
    } catch (e) {
      debugPrint("erro no start at FilaDeDownloadsController: $e");
      state.value = FilaDeDownloadsStates.error;
    }
  }
}

enum FilaDeDownloadsStates { start, loading, sucess, error }
