import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/download/download_controller.dart';
import 'package:manga_library/app/controllers/manga_info_controller.dart';
import 'package:manga_library/app/views/components/home_page/error.dart';
import 'package:manga_library/app/views/components/manga_info/manga_info_sucess.dart';

import '../models/leitor_pages.dart';

class MangaInfo extends StatefulWidget {
  final String link;
  final int idExtension;
  const MangaInfo({super.key, required this.link, required this.idExtension});

  @override
  State<MangaInfo> createState() => _MangaInfoState();
}

class _MangaInfoState extends State<MangaInfo> {
  final MangaInfoController mangaInfoController = MangaInfoController();

  Widget _loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget stateManagement(MangaInfoStates state) {
    switch (state) {
      case MangaInfoStates.start:
        return _loading();
      case MangaInfoStates.loading:
        return _loading();
      case MangaInfoStates.sucess1:
        return SucessMangaInfo(
          dados: mangaInfoController.data,
          sucess2: false,
          capitulosDisponiveis: const [],
          link: widget.link,
          controller: mangaInfoController,
        );
      case MangaInfoStates.sucess2:
        //  for (ModelLeitor element in mangaInfoController.capitulosDisponiveis!) {
        //   print("mangainfo cap: ${element.capitulo} / ${element.pages.length}");
        // }
        return SucessMangaInfo(
          dados: mangaInfoController.data,
          sucess2: true,
          capitulosDisponiveis: mangaInfoController.capitulosDisponiveis,
          link: widget.link,
          controller: mangaInfoController,
        );
      case MangaInfoStates.error:
        return const ErrorHomePage();
    }
  }

  void initialStart() async {
    await mangaInfoController.start(widget.link, widget.idExtension);
    if (MangaInfoController.isAnOffLineBook) {
      DownloadController.mangaInfoController = mangaInfoController;
    }
    //FullScreenController().exitFullScreen();
  }

  @override
  void initState() {
    super.initState();
    initialStart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Mangá'),
      ),
      body: AnimatedBuilder(
        animation: mangaInfoController.state,
        builder: (context, child) =>
            stateManagement(mangaInfoController.state.value),
      ),
    );
  }
}
