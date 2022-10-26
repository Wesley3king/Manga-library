import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manga_library/app/models/libraries_model.dart';
import 'package:manga_library/app/views/library/library_grid.dart';

import '../../../controllers/system_config.dart';
import 'controller/ocult_library_controller.dart';

class LibraryOcult extends StatefulWidget {
  const LibraryOcult(
      {super.key});
  @override
  State<LibraryOcult> createState() => _LibraryOcultState();
}

class _LibraryOcultState extends State<LibraryOcult> with SingleTickerProviderStateMixin {
  // with SingleTickerProviderStateMixin   with TickerProviderStateMixin
  final ConfigSystemController configSystemController =
      ConfigSystemController();
  late ScrollController controllerScroll;
  final OcultLibraryController libraryController = OcultLibraryController();
  TabController? tabController;

  List<Widget> _getPages(List<LibraryModel> lista) {
    List<Widget> pages = [];
    for (int i = 0; i < lista.length; ++i) {
      pages.add(LibraryItens(data: lista[i]));
    }
    return pages;
  }

  List<Tab> _getTabs(List<LibraryModel> lista) {
    List<Tab> tabs = [];
    for (int i = 0; i < lista.length; ++i) {
      tabs.add(Tab(
        text: lista[i].library,
        height: 30,
      ));
    }
    return tabs;
  }

  // ========================================================================
  //         -----------------  Ordem  ----------------------
  // ========================================================================

  Widget buildSetTemporallyOrdem(OcultLibraryController controller) {
    final List<Map<String, String>> options = [
      {"option": "Padrão", "value": "pattern"},
      {"option": "Velhos até Novos", "value": "oldtonew"},
      {"option": "Novos até Velhos", "value": "newtoold"},
      {"option": "Alfabética", "value": "alfabetic"}
    ];

    List<PopupMenuEntry<String>> itens = options
        .map<PopupMenuEntry<String>>(((Map<String, String> option) =>
            PopupMenuItem(
              onTap: () => controller.updateTemporallyOrdem(option['value']!),
              enabled: controller.ordemType == option['value'] ? false : true,
              child: Text(option['option']!),
            )))
        .toList();

    return PopupMenuButton<String>(
      icon: const Icon(Icons.filter_list),
      itemBuilder: (context) => itens,
    );
  }

  // ------------- loading -----------------------
  Widget _loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  // ------------ error --------------------------
  _error() {
    return Center(
      child: Column(
        children: const <Widget>[
          Icon(Icons.info),
          Text('Error!'),
        ],
      ),
    );
  }

  // ------------- SUCESS ------------------
  Widget sucess(BuildContext context) {
    final List<LibraryModel> dados = libraryController.ocultLibrariesData;
    return NestedScrollView(
      controller: controllerScroll,
      floatHeaderSlivers: true,
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          // iconTheme: IconThemeData(color: ConfigSystemController.instance.isDarkTheme ? Colors.white : Colors.black),
          title: const Text('Biblioteca Oculta'),
          // backgroundColor: ConfigSystemController.instance.isDarkTheme ? const Color.fromARGB(255, 54, 54, 54) : const Color.fromARGB(255, 230, 230, 230),
          //systemOverlayStyle: SystemUiOverlayStyle.dark,
          pinned: true,
          snap: true,
          floating: true,
          actions: [
            buildSetTemporallyOrdem(libraryController),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(35),
            child: TabBar(
              labelColor: ConfigSystemController.instance.isDarkTheme ? Colors.white : Colors.black,
              isScrollable: true,
              indicatorWeight: 2.5,
              controller: tabController,
              indicatorColor: configSystemController.colorManagement(),
              tabs: _getTabs(dados),
            ),
          ),
        )
      ],
      body: TabBarView(
        controller: tabController,
        children: _getPages(dados),
      ),
    );
  }

  // ================= STATE MANAGEMENT ====================
  _stateManagement(BuildContext context, OcultLibraryStates state) {
    switch (state) {
      case OcultLibraryStates.start:
        return _loading();
      case OcultLibraryStates.loading:
        return _loading();
      case OcultLibraryStates.sucess:
        tabController ??= TabController(length: libraryController.ocultLibrariesData.length, vsync: this);
        return sucess(context);
      case OcultLibraryStates.error:
        return _error();
    }
  }

  @override
  void initState() {
    super.initState();
    libraryController.start();
    controllerScroll = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    tabController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: libraryController.state,
        builder: (context, child) =>
            _stateManagement(context, libraryController.state.value),
      ),
    );
  }
}
