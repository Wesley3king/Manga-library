import 'package:flutter/material.dart';
import 'package:manga_library/app/views/about/controller/about_page_controller.dart';
import 'package:manga_library/app/views/about/home/about_home.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final AboutPageController controller = AboutPageController();

  Widget stateManagement(AboutPageStates state) {
    switch (state) {
      case AboutPageStates.home:
        return const AboutHomePage();
      case AboutPageStates.library:
        return Container();
      case AboutPageStates.ocultLibrary:
        return Container();
      case AboutPageStates.backup:
        return Container();
      case AboutPageStates.updates:
        return Container();
      case AboutPageStates.extensions:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sobre"),
      ),
      body: AnimatedBuilder(
        animation: controller.state,
        builder: (context, child) => stateManagement(controller.state.value),
      ),
    );
  }
}
