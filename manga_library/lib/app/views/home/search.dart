import 'package:flutter/material.dart';
import 'package:manga_library/app/views/bottom_navigation_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ScrollController controller = ScrollController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('serach page')),
      bottomNavigationBar: CustomBottomNavigationBar(controller: controller,),
    );

  }
}
