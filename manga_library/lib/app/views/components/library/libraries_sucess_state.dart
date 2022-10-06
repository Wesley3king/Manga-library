import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/models/libraries_model.dart';
import 'package:manga_library/app/views/components/library/library_grid.dart';

import '../../../controllers/system_config.dart';

class LibrarrySucessState extends StatefulWidget {
  final List<LibraryModel> dados;
  final ScrollController controllerScroll;
  const LibrarrySucessState(
      {super.key, required this.dados, required this.controllerScroll});

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
      if (text == "king of shadows") {
        GoRouter.of(context).push('/ocultlibrary');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Acesso Negado!")));
      }
    }
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
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          actions: [
            IconButton(
                onPressed: () => goToOcultLibrary(),
                icon: const Icon(Icons.lock))
          ],
          pinned: true,
          snap: true,
          floating: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(35),
            child: TabBar(
              isScrollable: true,
              // indicatorSize: TabBarIndicatorSize.tab,
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
