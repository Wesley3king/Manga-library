import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/manga_info_controller.dart';
import 'package:manga_library/app/views/components/error.dart';
import 'package:manga_library/app/views/components/manga_info/manga_info_sucess.dart';

class MangaInfo extends StatefulWidget {
  final String link;
  const MangaInfo({super.key, required this.link});

  @override
  State<MangaInfo> createState() => _MangaInfoState();
}

class _MangaInfoState extends State<MangaInfo> {
  final MangaInfoController _mangaInfoController = MangaInfoController();

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
      case MangaInfoStates.sucess:
        return SucessMangaInfo(dados: _mangaInfoController.data);
      case MangaInfoStates.error:
        return const ErrorHomePage();
    }
  }

  @override
  void initState() {
    super.initState();
    _mangaInfoController.start(widget.link);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Mangá'),
      ),
      body: AnimatedBuilder(
        animation: _mangaInfoController.state,
        builder: (context, child) =>
            stateManagement(_mangaInfoController.state.value),
      ),
    );
  }
}
