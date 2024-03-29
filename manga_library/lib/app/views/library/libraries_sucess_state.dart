import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/views/library/controllers/library_controller.dart';
import 'package:manga_library/app/models/globais.dart';
import 'package:manga_library/app/models/libraries_model.dart';
import 'package:manga_library/app/views/library/library_grid.dart';

import '../../controllers/message_core.dart';
import '../../controllers/system_config.dart';

class LibrarrySucessState extends StatefulWidget {
  final List<LibraryModel> dados;
  final LibraryController controller;
  final ScrollController controllerScroll;
  const LibrarrySucessState(
      {super.key,
      required this.dados,
      required this.controllerScroll,
      required this.controller});

  @override
  State<LibrarrySucessState> createState() => _LibrarrySucessStateState();
}

class _LibrarrySucessStateState extends State<LibrarrySucessState>
    with SingleTickerProviderStateMixin {
  final ConfigSystemController configSystemController =
      ConfigSystemController();
  late TabController tabController;
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

  // ================= OCULT LIBRARY =======================
  void goToOcultLibrary() async {
    String? text;
    bool? result = await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text("Confirme Para entrar"),
        // content: ,
        children: [
          TextField(
            autofocus: true,
            onChanged: (value) => text = value,
          ),
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text("Cancelar")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text("Confirmar"))
            ],
          )
        ],
      ),
    );

    if ((result != null) && result) {
      if (text == GlobalData.settings.hiddenLibraryPassword) {
        GoRouter.of(context).push('/ocultlibrary');
      } else {
        MessageCore.showMessage("Senha incorreta");
      }
    }
  }

  // ========================================================================
  //         -----------------  Ordem  ----------------------
  // ========================================================================

  Widget buildSetTemporallyOrdem(LibraryController controller) {
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

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: widget.dados.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: widget.controllerScroll,
      floatHeaderSlivers: true,
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          title: const Text('Biblioteca'),
          // backgroundColor: ConfigSystemController.instance.isDarkTheme ? const Color.fromARGB(255, 54, 54, 54) : Colors.white70,

          actions: [
            IconButton(
                onPressed: () => goToOcultLibrary(),
                icon: const Icon(Icons.lock)),
            ValueListenableBuilder(
              valueListenable: widget.controller.ordemState,
              builder: (context, value, child) =>
                  buildSetTemporallyOrdem(widget.controller),
            )
          ],
          pinned: true,
          snap: true,
          floating: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(35),
            child: TabBar(
              isScrollable: true,
              // indicatorSize: TabBarIndicatorSize.tab,
              labelColor: ConfigSystemController.instance.isDarkTheme
                  ? Colors.white
                  : Colors.black,
              indicatorWeight: 2.5,
              controller: tabController,
              indicatorColor: configSystemController.colorManagement(),
              tabs: _getTabs(widget.dados),
            ),
          ),
        )
      ],
      body: TabBarView(
        controller: tabController,
        children: _getPages(widget.dados),
      ),
    );
  }
}
