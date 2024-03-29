import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/controllers/download/download_controller.dart';
import 'package:manga_library/app/controllers/message_core.dart';
import 'package:manga_library/app/extensions/extensions.dart';
import 'package:manga_library/app/controllers/manga_info_controller.dart';
import 'package:manga_library/app/controllers/system_config.dart';
import 'package:manga_library/app/views/home_page/error.dart';
import 'package:manga_library/app/views/manga_info/manga_info_sucess.dart';
import 'package:share_plus/share_plus.dart';
import '../../controllers/system_navigation_and_app_bar_styles.dart';
import 'handle_data/handle_data_manual.dart';

class MangaInfo extends StatefulWidget {
  final String link;
  final int idExtension;
  const MangaInfo({super.key, required this.link, required this.idExtension});

  @override
  State<MangaInfo> createState() => _MangaInfoState();
}

class _MangaInfoState extends State<MangaInfo> {
  final MangaInfoController mangaInfoController = MangaInfoController();
  int editCount = 0;

  Widget _loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  /// show menu
  Widget _generateMenu() {
    return PopupMenuButton(
      itemBuilder: (context) => [
        PopupMenuItem(
          child: const Text('Atualizar'),
          onTap: () async {
            if (mangaInfoController.state.value == MangaInfoStates.sucess) {
              MessageCore.showMessage("Atualizando...");
              await mangaInfoController.updateBook(
                      widget.link, widget.idExtension,
                      img: mangaInfoController.data.img)
                  ? MessageCore.showMessage("Atualizado com Sucesso!")
                  : MessageCore.showMessage('Falha ao atualizar!');
            }
          },
        ),
        PopupMenuItem(
          enabled: editCount == 0,
          child: const Text('Editar dados'),
          onTap: () {
            editCount++;
            Future.delayed(const Duration(milliseconds: 100),
                () => handleData(context, mangaInfoController.data));
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
      case MangaInfoStates.sucess:
        return SucessMangaInfo(
          dados: mangaInfoController.data,
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
              onPressed: () => Share.share(
                  mapOfExtensions[widget.idExtension]!.getLink(widget.link)),
              tooltip: "Compartilhar",
              icon: const Icon(Icons.share),
            ),
          ),
          _generateMenu(),
        ],
      ),
      body: AnimatedBuilder(
        animation: mangaInfoController.state,
        builder: (context, child) {
          return stateManagement(mangaInfoController.state.value);
        },
      ),
    );
  }
}
