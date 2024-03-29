import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';
import 'package:manga_library/app/views/manga_info/off_line/controller/off_line_widget_controller.dart';

class OffLineWidget extends StatefulWidget {
  final String pieceOfLink;
  final MangaInfoOffLineModel model;
  final Capitulos capitulo;
  const OffLineWidget({super.key, required this.pieceOfLink, required this.capitulo, required this.model});

  @override
  State<OffLineWidget> createState() => _OffLineWidgetState();
}

class _OffLineWidgetState extends State<OffLineWidget> {
  final OffLineWidgetController _offLineWidgetController =
      OffLineWidgetController();
  Widget download() {
    return IconButton(
        onPressed: () => _offLineWidgetController.download(
            link: widget.pieceOfLink,
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
                    log("Progresso do Download: $second");
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
            onPressed: () => _offLineWidgetController.cancel(widget.capitulo, widget.model.link),
            icon: const Icon(Icons.close))
      ],
    );
  }

  Widget delete() {
    return IconButton(
        onPressed: () => _offLineWidgetController.delete(mangaModel: widget.model, capitulo: widget.capitulo),
        icon: const Icon(Icons.delete_outline));
  }

  Widget error() {
    return IconButton(
        onPressed: () => _offLineWidgetController.state.value = DownloadStates.download,
        tooltip: "FALHA no download!",
        icon: const Icon(
          Icons.info_outline,
          color: Colors.red,
        ));
  }

  Widget _stateManagement(DownloadStates state) {
    switch (state) {
      case DownloadStates.download:
        return download();
      case DownloadStates.downloading:
        return cancel();
      case DownloadStates.delete:
        return delete();
      case DownloadStates.error:
        return error();
    }
  }

  @override
  void initState() {
    super.initState();
    _offLineWidgetController.start(widget.capitulo, link: widget.model.link, idExtension: widget.model.idExtension);
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
