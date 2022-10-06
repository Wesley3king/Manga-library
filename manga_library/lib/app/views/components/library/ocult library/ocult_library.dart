import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manga_library/app/models/libraries_model.dart';
import 'package:manga_library/app/views/components/library/library_grid.dart';

import '../../../../controllers/system_config.dart';
import 'controller/ocult_library_controller.dart';

class LibraryOcult extends StatefulWidget {
  // final List<LibraryModel> dados;
  // final ScrollController controllerScroll;
  const LibraryOcult(
      {super.key});

  @override
  State<LibraryOcult> createState() => _LibraryOcultState();
}

class _LibraryOcultState extends State<LibraryOcult>
    with SingleTickerProviderStateMixin {
  final ConfigSystemController configSystemController =
      ConfigSystemController();
  late ScrollController controllerScroll;
  final OcultLibraryController _libraryController = OcultLibraryController();
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
    final List<LibraryModel> dados = _libraryController.ocultLibrariesData;
    return NestedScrollView(
      controller: controllerScroll,
      floatHeaderSlivers: true,
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          title: const Text('Biblioteca'),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          pinned: true,
          snap: true,
          floating: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(35),
            child: TabBar(
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
        tabController = TabController(length: _libraryController.ocultLibrariesData.length, vsync: this);
        return sucess(context);
      case OcultLibraryStates.error:
        return _error();
    }
  }

  @override
  void initState() {
    super.initState();
    _libraryController.start();
    controllerScroll = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _libraryController.state,
        builder: (context, child) =>
            _stateManagement(context, _libraryController.state.value),
      ),
    );
  }
}
