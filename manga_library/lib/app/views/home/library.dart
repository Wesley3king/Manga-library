import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/library_controller.dart';
import 'package:manga_library/app/views/bottom_navigation_bar.dart';
import 'package:manga_library/app/views/components/library/libraries_sucess_state.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final LibraryController _libraryController = LibraryController();
  ScrollController controller = ScrollController();

  Widget _loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  _error() {
    return Center(
      child: Column(
        children: const <Widget>[
          Icon(Icons.info),
          Text('Error!'),
        ],
      ),
    );
  }

  _stateManagement(LibraryStates state) {
    switch (state) {
      case LibraryStates.start:
        return _loading();
      case LibraryStates.loading:
        return _loading();
      case LibraryStates.sucess:
        return LibrarrySucessState(dados: _libraryController.librariesData, controllerScroll: controller,);
      case LibraryStates.error:
        return _error();
    }
  }

  @override
  void initState() {
    super.initState();
    _libraryController.start();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _libraryController.state,
        builder: (context, child) => _stateManagement(_libraryController.state.value),
        ),
      bottomNavigationBar: CustomBottomNavigationBar(
        controller: controller,
      ),
    );
  }
}
