import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/views/home/bottom_navigation_bar.dart';
import 'package:manga_library/app/views/home/home_page.dart';
import 'package:manga_library/app/views/home/library.dart';
import 'package:manga_library/app/views/home/others.dart';
import 'package:manga_library/app/views/home/search.dart';

import '../models/globais.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ScrollController scrollController;
  ValueNotifier<int> currentRoute = ValueNotifier<int>(0);

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
        return HomePage(
          scrollController: scrollController,
        );
      case 1:
        return LibraryPage(
          scrollController: scrollController,
        );
      case 2:
        return SearchPage(
          scrollController: scrollController,
        );
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
    // if (GlobalData.settings['Autenticação']) {
    //   GoRouter.of(context).replace('/auth');
    // }
    return AnimatedBuilder(
      animation: currentRoute,
      builder: (context, child) => WillPopScope(
        onWillPop: () async {
          if (currentRoute.value == 0) {
            return true;
          } else {
            currentRoute.value = 0;
            return false;
          }
        },
        child: Scaffold(
          appBar: getAppBar(context, currentRoute.value),
          body: redirect(currentRoute.value),
          bottomNavigationBar: CustomBottomNavigationBar(
            controller: scrollController,
            currentIndex: currentRoute,
          ),
        ),
      ),
    );
  }
}
