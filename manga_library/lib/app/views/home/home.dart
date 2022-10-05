import 'package:flutter/material.dart';
import 'package:manga_library/app/views/bottom_navigation_bar.dart';
import 'package:manga_library/app/views/home/home_page.dart';
import 'package:manga_library/app/views/home/library.dart';
import 'package:manga_library/app/views/home/others.dart';
import 'package:manga_library/app/views/home/search.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ScrollController scrollController;
  ValueNotifier<int> index = ValueNotifier<int>(0);

  AppBar? getAppBar(BuildContext context, int route) {
    switch (route) {
      case 0:
        return null;
      case 1:
        return null;
      case 2:
        return AppBar(
          title: const Text('Pesquisar'),
          actions: [
            IconButton(
                onPressed: () =>
                    showSearch(context: context, delegate: MySearchDelegate()),
                icon: const Icon(Icons.search))
          ],
        );
      case 3:
        return AppBar(
          title: const Text('Outros'),
        );
    }
    return null;
  }

  redirect(int route) {
    switch (route) {
      case 0:
        return HomePage(scrollController: scrollController,);
      case 1:
        return LibraryPage(scrollController: scrollController,);
      case 2:
        return SearchPage(scrollController: scrollController,);
      case 3:
        return const OthersPage();
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: index,
      builder: (context, child) => Scaffold(
        appBar: getAppBar(context, index.value),
        body: redirect(index.value),
        bottomNavigationBar: CustomBottomNavigationBar(
          controller: scrollController,
          currentIndex: index,
        ),
      ),
    );
  }
}
