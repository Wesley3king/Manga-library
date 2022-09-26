import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/home_page_controller.dart';
import 'package:manga_library/app/controllers/system_config.dart';
import 'package:manga_library/app/views/bottom_navigation_bar.dart';
import 'package:manga_library/app/views/components/home_page/error.dart';
import 'package:manga_library/app/views/components/home_page/sucess.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController controller = ScrollController();

  final HomePageController _homePageController = HomePageController();
  Widget _start() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: Image.asset('assests/imgs/new-icon-manga-mini.png'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loading() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: Image.asset('assests/imgs/new-icon-manga-mini.png'),
            ),
            const SizedBox(
              height: 50,
            ),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Widget stateManagement(HomeStates state) {
    switch (state) {
      case HomeStates.start:
        return _start();
      case HomeStates.loading:
        return _loading();
      case HomeStates.sucess:
        return Sucess(
          dados: _homePageController.data,
          controllerScroll: controller,
        );
      case HomeStates.error:
        return const ErrorHomePage();
    }
  }

  @override
  void initState() {
    super.initState();
    SystemController().getSystemPermissions();
    _homePageController.start();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _homePageController.state,
        builder: (context, child) =>
            stateManagement(_homePageController.state.value),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        controller: controller,
      ),
    );
  }
}
