import 'package:flutter/material.dart';

class OffLineWidgetController {
  ValueNotifier<DownloadStates> state = ValueNotifier<DownloadStates>(DownloadStates.loading);

  start() async {
    
  }
}

enum DownloadStates { loading, download, downloading, delete }
