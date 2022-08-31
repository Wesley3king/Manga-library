import 'package:flutter/material.dart';
import 'package:manga_library/app/models/libraries_model.dart';

class LibrarrySucessState extends StatelessWidget {
  final List<LibraryModel> dados;
  const LibrarrySucessState({super.key, required this.dados});

  List<Widget> _getPages(List<LibraryModel> lista) {
    List<Widget> pages = [];
    for (int i = 0; i < lista.length; ++i) {
      pages.add(Center(
        child: Text('pagina = ${lista[i].library}'),
      ));
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
  Widget build(BuildContext context) {
    return NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          title: const Text('Biblioteca'),
          backgroundColor: Colors.blueAccent,
          snap: true,
          floating: true,
          bottom: TabBar(tabs: _getTabs(dados)),
        )
      ],
      body: TabBarView(
        children: _getPages(dados),
      ),
    );
  }
}
