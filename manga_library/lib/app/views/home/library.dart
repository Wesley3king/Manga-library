import 'package:flutter/material.dart';
import 'package:manga_library/app/views/bottom_navigation_bar.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  ScrollController controller = ScrollController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 20,
        controller: controller,
        itemBuilder: (context, index) => const ListTile(title: Text('item da lista'),),),
      bottomNavigationBar: CustomBottomNavigationBar(controller: controller,),
    );

  }
}
