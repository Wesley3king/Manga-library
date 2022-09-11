import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/system_config.dart';
import 'package:manga_library/app/views/components/configurations/library_config/controller/library_config_controller.dart';

class LibraryConfig extends StatefulWidget {
  const LibraryConfig({super.key});

  @override
  State<LibraryConfig> createState() => _LibraryConfigState();
}

class _LibraryConfigState extends State<LibraryConfig> {
  final ConfigSystemController _configSystemController =
      ConfigSystemController();
  final LibraryConfigController _libraryConfigController =
      LibraryConfigController();
  Widget _loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _error() {
    return Center(
      child: Column(
        children: const <Widget>[
          Icon(Icons.report_problem),
          Text('Erro! \n não foi possivel acessar as bibliotecas')
        ],
      ),
    );
  }

  Widget _sucess() {
    return ListView.builder(
      itemCount: _libraryConfigController.libraries.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(_libraryConfigController.libraries[index].library),
      ),
    );
  }

  Widget _stateManagement(LibraryConfigStates state) {
    switch (state) {
      case LibraryConfigStates.start:
        return _loading();
      case LibraryConfigStates.loading:
        return _loading();
      case LibraryConfigStates.sucess:
        return _sucess();
      case LibraryConfigStates.error:
        return _error();
    }
  }

  @override
  void initState() {
    super.initState();
    _libraryConfigController.start();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Biblioteca"),
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.checklist_rounded))
        ],
      ),
      body: AnimatedBuilder(
        animation: _libraryConfigController.state,
        builder: (context, child) =>
            _stateManagement(_libraryConfigController.state.value),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String libraryName = "";
          showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              title: const Text("Adicionar Biblioteca"),
              children: [
                TextField(
                  autofocus: true,
                  onChanged: (value) => libraryName = value,
                ),
                Row(
                  children: [
                    TextButton(onPressed: (){}, child: const Text("Cancelar")),
                    TextButton(onPressed: (){}, child: const Text("Adicionar")),
                  ],
                )
              ],
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: _configSystemController.colorManagement(),
        ),
      ),
    );
  }
}
