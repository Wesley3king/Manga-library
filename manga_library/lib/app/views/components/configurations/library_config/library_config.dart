import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/system_config.dart';
import 'package:manga_library/app/views/components/configurations/library_config/controller/library_config_controller.dart';

import '../../../../models/libraries_model.dart';

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

  void _delete(String libraryName) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text("Remover Biblioteca?"),
        children: [
          Text("Deseja remover a Biblioteca $libraryName", textAlign: TextAlign.center,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancelar")),
              TextButton(
                  onPressed: () {
                    _libraryConfigController.removeLibrary(libraryName);
                    Navigator.of(context).pop();
                  },
                  child: const Text("Remover")),
            ],
          ),
        ], // _libraryConfigController.removeLibrary(_libraryConfigController.libraries[i].library)
      ),
    );
  }

  void _rename(String name) {
    TextEditingController textController = TextEditingController();
    textController.text = name;
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text("Adicionar Biblioteca"),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              autofocus: true,
              controller: textController,
              onChanged: (value) => textController.text = value,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Cancelar")),
              TextButton(onPressed: () {
                // implement this
                 Navigator.of(context).pop();
              }, child: const Text("Adicionar")),
            ],
          )
        ],
      ),
    );
  }

  List<Widget> itensEdit() {
    List<Widget> list = [];
    for (int i = 0; i < _libraryConfigController.libraries.length; ++i) {
      list.add(
        ListTile(
          title: Text(_libraryConfigController.libraries[i].library),
          trailing: PopupMenuButton<String>(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text("Renomear"),
                onTap: () {
                  Navigator.of(context).pop();
                    Future.delayed(
                        const Duration(milliseconds: 100),
                        () => _rename(
                            _libraryConfigController.libraries[i].library));
                },
              ),
              PopupMenuItem(
                  child: const Text("Excluir"),
                  onTap: () {
                    Navigator.of(context).pop();
                    Future.delayed(
                        const Duration(milliseconds: 100),
                        () => _delete(
                            _libraryConfigController.libraries[i].library));
                  })
            ],
          ),
        ),
      );
    }
    return list;
  }

  void _showEdit() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text("Editar Bibliotecas"),
        children: itensEdit(),
      ),
    );
  }

  /*
  SizedBox(
                  width: 50,
                  height: 40,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            _rename(
                                _libraryConfigController.libraries[index].library);
                          },
                          icon: const Icon(Icons.border_color)),
                      IconButton(
                          onPressed: () {
                            _delete(
                                _libraryConfigController.libraries[index].library);
                          },
                          icon: const Icon(Icons.delete_outline)),
                    ],
                  ),
                ),
                */

  Widget _sucess() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: ReorderableListView.builder(
          itemBuilder: (context, index) => ListTile(
                key: UniqueKey(),
                leading: const Icon(Icons.density_large),
                title: Text(_libraryConfigController.libraries[index].library),
              ),
          itemCount: _libraryConfigController.libraries.length,
          onReorder: (oldIndex, newIndex) {
            // aqui temos o sistema para mudar a ordem
            if (oldIndex != newIndex) {
              List<LibraryModel> lista = _libraryConfigController.libraries;
              LibraryModel item = lista[oldIndex];
              if (oldIndex > newIndex) {
                // bottom to top
                for (int i = oldIndex; i > newIndex; i--) {
                  lista[i] = lista[i - 1];
                }
                lista[newIndex] = item;
              } else if (oldIndex < newIndex) {
                // top to bottom
                int noMove = newIndex - 1;
                int index = 0;
                int local = oldIndex;
                do {
                  lista[local] = lista[++local];
                  index++;
                  print(index);
                } while (index < noMove - oldIndex);
                lista[noMove] = item;
              }
              setState(() {});
            }
          }),
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
              tooltip: "Salvar Ordem",
              onPressed: () {},
              icon: const Icon(Icons.checklist_rounded)),
          IconButton(
              tooltip: "Editar",
              onPressed: () => _showEdit(),
              icon: const Icon(Icons.edit)),
        ],
      ),
      body: AnimatedBuilder(
        animation: _libraryConfigController.state,
        builder: (context, child) =>
            _stateManagement(_libraryConfigController.state.value),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _configSystemController.colorManagement(),
        tooltip: "Adicionar Biblioteca",
        onPressed: () {
          String libraryName = "";
          showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              title: const Text("Adicionar Biblioteca"),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 6.0),
                  child: TextField(
                    autofocus: true,
                    onChanged: (value) => libraryName = value,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Cancelar")),
                    TextButton(
                        onPressed: () {
                          _libraryConfigController.addLibrary(libraryName);
                          Navigator.of(context).pop();
                        },
                        child: const Text("Adicionar")),
                  ],
                )
              ],
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
