import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/library_controller.dart';
import 'package:manga_library/app/views/components/library/libraries_sucess_state.dart';

class LibraryPage extends StatefulWidget {
  final ScrollController scrollController;
  const LibraryPage({super.key, required this.scrollController});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final LibraryController libraryController = LibraryController();

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
        return LibrarrySucessState(dados: libraryController.librariesData, controllerScroll: widget.scrollController, controller: libraryController);
      case LibraryStates.error:
        return _error();
    }
  }

  @override
  void initState() {
    super.initState();
    libraryController.start();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: libraryController.state,
        builder: (context, child) => _stateManagement(libraryController.state.value),
        );
  }
}