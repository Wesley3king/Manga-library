import 'package:flutter/material.dart';
import 'package:manga_library/app/models/libraries_model.dart';
import 'package:manga_library/app/views/components/library/library_grid.dart';

class LibrarrySucessState extends StatefulWidget {
  final List<LibraryModel> dados;
  final ScrollController controllerScroll;
  const LibrarrySucessState({super.key, required this.dados, required this.controllerScroll});

  @override
  State<LibrarrySucessState> createState() => _LibrarrySucessStateState();
}

class _LibrarrySucessStateState extends State<LibrarrySucessState>
    with SingleTickerProviderStateMixin {
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
      tabs.add(Tab(text: lista[i].library));
    }
    return tabs;
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
          backgroundColor: Colors.blueAccent,
          snap: true,
          floating: true,
          bottom: TabBar(
            controller: tabController,
            tabs: _getTabs(widget.dados),
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