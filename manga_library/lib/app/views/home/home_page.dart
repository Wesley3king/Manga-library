import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/home_page_controller.dart';
import 'package:manga_library/app/controllers/system_config.dart';
import 'package:manga_library/app/views/components/home_page/error.dart';
import 'package:manga_library/app/views/components/home_page/sucess.dart';

class HomePage extends StatefulWidget {
  final ScrollController scrollController;
  const HomePage({super.key, required this.scrollController});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final HomePageController homePageController = HomePageController();
  Widget _start() {
    return const SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _loading() {
    return const SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: CircularProgressIndicator(),
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
          dados: homePageController.data,
          controller: homePageController,
          controllerScroll: widget.scrollController,
        );
      case HomeStates.error:
        return const ErrorHomePage();
    }
  }

  @override
  void initState() {
    super.initState();
    SystemController().getSystemPermissions();
    homePageController.start();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: homePageController.state,
      builder: (context, child) =>
          stateManagement(homePageController.state.value),
    );
  }
}