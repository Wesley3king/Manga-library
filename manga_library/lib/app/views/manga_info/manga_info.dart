import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/controllers/download/download_controller.dart';
import 'package:manga_library/app/controllers/extensions/extensions.dart';
import 'package:manga_library/app/controllers/manga_info_controller.dart';
import 'package:manga_library/app/controllers/system_config.dart';
import 'package:manga_library/app/controllers/system_navigation_and_app_bar_styles.dart';
import 'package:manga_library/app/views/home_page/error.dart';
import 'package:manga_library/app/views/manga_info/manga_info_sucess.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
  }

  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemStatusBarContrastEnforced: false,
        statusBarColor: Colors.transparent,
        systemNavigationBarContrastEnforced: false,
        systemNavigationBarDividerColor: Colors.black26,
        systemNavigationBarColor: Colors.black26));
    initialStart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: () => GoRouter.of(context).pop(), icon: Icon(Icons.arrow_back, color: ConfigSystemController.instance.isDarkTheme ? Colors.white: const Color.fromARGB(255, 51, 51, 51),),),
        actionsIconTheme: IconThemeData(color: ConfigSystemController.instance.isDarkTheme ? Colors.white: const Color.fromARGB(255, 51, 51, 51)),
        elevation: 0,
        title: Text('Detalhes do Mangá', style: TextStyle(color: ConfigSystemController.instance.isDarkTheme ? Colors.white: const Color.fromARGB(255, 51, 51, 51)),),
        actions: [
          ValueListenableBuilder(
            valueListenable: mangaInfoController.state,
            builder: (context, value, child) => IconButton(
              onPressed: () {
                // utilize url_launcher
                Uri url = Uri.parse(mapOfExtensions[widget.idExtension]!.getLink(widget.link));
                launchUrl(url);
              },
              tooltip: "Compartilhar",
              icon: const Icon(Icons.share),
            ),
          )
        ],
      ),
      body: AnimatedBuilder(
        animation: mangaInfoController.state,
        builder: (context, child) =>
            stateManagement(mangaInfoController.state.value),
      ),
    );
  }
}
