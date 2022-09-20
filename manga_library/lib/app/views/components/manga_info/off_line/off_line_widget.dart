import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';
import 'package:manga_library/app/views/components/manga_info/off_line/controller/off_line_widget_controller.dart';

class OffLineWidget extends StatefulWidget {
  // final dynamic id;
  final MangaInfoOffLineModel model;
  final Capitulos capitulo;
  const OffLineWidget({super.key, required this.capitulo, required this.model});

  @override
  State<OffLineWidget> createState() => _OffLineWidgetState();
}

class _OffLineWidgetState extends State<OffLineWidget> {
  final OffLineWidgetController _offLineWidgetController =
      OffLineWidgetController();
  Widget download() {
    return IconButton(
        onPressed: () => _offLineWidgetController.download(
            capitulo: widget.capitulo, mangaModel: widget.model),
        icon: const Icon(Icons.download));
  }

  Widget cancel() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 9),
          child: SizedBox(
              width: 30,
              height: 30,
              child: AnimatedBuilder(
                animation: _offLineWidgetController.downloadProgress,
                builder: (context, child) {
                  if (_offLineWidgetController
                          .downloadProgress.value['progress'] !=
                      null) {
                    int first = _offLineWidgetController
                            .downloadProgress.value['progress']! *
                        100;
                    double second = first /
                        _offLineWidgetController
                            .downloadProgress.value['total']!;
                    log("valor de 2: $second");
                    if (_offLineWidgetController
                            .downloadProgress.value['progress']! ==
                        (_offLineWidgetController
                                .downloadProgress.value['total']! -
                            1)) {
                      Future.delayed(
                        const Duration(milliseconds: 100),
                        () => _offLineWidgetController.state.value =
                            DownloadStates.delete,
                      );
                    }
                    return CircularProgressIndicator(
                      strokeWidth: 2.0,
                      value: second / 100,
                    );
                  }

                  return const CircularProgressIndicator(
                    strokeWidth: 2.0,
                  );
                },
              )),
        ),
        IconButton(
            onPressed: () => _offLineWidgetController.cancel(widget.capitulo),
            icon: const Icon(Icons.close))
      ],
    );
  }

  Widget delete() {
    return IconButton(
        onPressed: () => print("need to implement DELETE!"),
        icon: const Icon(Icons.delete_outline));
  }

  Widget _stateManagement(DownloadStates state) {
    switch (state) {
      case DownloadStates.download:
        return download();
      case DownloadStates.downloading:
        return cancel();
      case DownloadStates.delete:
        return delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offLineWidgetController.state,
      builder: (context, child) =>
          _stateManagement(_offLineWidgetController.state.value),
    );
  }
}
