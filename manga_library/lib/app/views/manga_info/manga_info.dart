import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/controllers/download/download_controller.dart';
import 'package:manga_library/app/extensions/extensions.dart';
import 'package:manga_library/app/controllers/manga_info_controller.dart';
import 'package:manga_library/app/controllers/system_config.dart';
import 'package:manga_library/app/views/home_page/error.dart';
import 'package:manga_library/app/views/manga_info/manga_info_sucess.dart';
import 'package:share_plus/share_plus.dart';
import '../../controllers/system_navigation_and_app_bar_styles.dart';

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

  /// generate an Message
  void generateMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: ConfigSystemController.instance.isDarkTheme
          ? const Color.fromARGB(255, 17, 17, 17)
          : Colors.white,
      content: Text(
        message,
        style: TextStyle(
            color: ConfigSystemController.instance.isDarkTheme
                ? Colors.white
                : Colors.black),
      ),
    ));
  }

  /// menu
  Widget _generateMenu() {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: const Text('Atualizar'),
          onTap: () async {
            if (mangaInfoController.state.value == MangaInfoStates.sucess) {
              generateMessage(context, "Atualizando...");
              await mangaInfoController.updateBook(
                      widget.link, widget.idExtension)
                  ? generateMessage(context, "Atualizado com Sucesso!")
                  : generateMessage(context, 'Falha ao atualizar!');
            }
          },
        ),
      ],
    );
  }

  Widget stateManagement(MangaInfoStates state) {
    switch (state) {
      case MangaInfoStates.start:
        return _loading();
      case MangaInfoStates.loading:
        return _loading();
      // case MangaInfoStates.sucess1:
      //   return SucessMangaInfo(
      //     dados: mangaInfoController.data,
      //     sucess2: false,
      //     capitulosDisponiveis: const [],
      //     link: widget.link,
      //     controller: mangaInfoController,
      //   );
      case MangaInfoStates.sucess:
        return SucessMangaInfo(
          dados: mangaInfoController.data,
          // sucess2: true,
          // capitulosDisponiveis: mangaInfoController.capitulosDisponiveis,
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
    _customNavigationBar();
    initialStart();
  }

  void _customNavigationBar() {
    // StylesFromSystemNavigation.toggleStatusBarContrastEnforced(true);
    ConfigSystemController.instance.isDarkTheme
        ? StylesFromSystemNavigation.setSystemNavigationBarBlack26()
        : StylesFromSystemNavigation.setSystemNavigationBarWhite24();
  }

  @override
  void dispose() {
    // StylesFromSystemNavigation.toggleStatusBarContrastEnforced(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => GoRouter.of(context).pop(),
          icon: Icon(
            Icons.arrow_back,
            color: ConfigSystemController.instance.isDarkTheme
                ? Colors.white
                : const Color.fromARGB(255, 51, 51, 51),
          ),
        ),
        actionsIconTheme: IconThemeData(
            color: ConfigSystemController.instance.isDarkTheme
                ? Colors.white
                : const Color.fromARGB(255, 51, 51, 51)),
        elevation: 0,
        title: Text(
          'Detalhes do Mangá',
          style: TextStyle(
              color: ConfigSystemController.instance.isDarkTheme
                  ? Colors.white
                  : const Color.fromARGB(255, 51, 51, 51)),
        ),
        actions: [
          ValueListenableBuilder(
            valueListenable: mangaInfoController.state,
            builder: (context, value, child) => IconButton(
              onPressed: () {
                // utilize url_launcher
                // Uri url = Uri.parse(
                //     mapOfExtensions[widget.idExtension]!.getLink(widget.link));
                // launchUrl(url, mode: LaunchMode.externalApplication);
                Share.share(
                    mapOfExtensions[widget.idExtension]!.getLink(widget.link));
              },
              tooltip: "Compartilhar",
              icon: const Icon(Icons.share),
            ),
          ),
          _generateMenu(),
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
