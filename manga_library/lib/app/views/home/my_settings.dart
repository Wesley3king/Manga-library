
import 'package:flutter/material.dart';
import 'package:manga_library/app/views/bottom_navigation_bar.dart';

class MySettingsPage extends StatefulWidget {
  const MySettingsPage({super.key});

  @override
  State<MySettingsPage> createState() => _MySettingsPageState();
}

class _MySettingsPageState extends State<MySettingsPage> {
  ScrollController controller = ScrollController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('my settings page')),
      bottomNavigationBar: CustomBottomNavigationBar(controller: controller,),
    );

  }
}
