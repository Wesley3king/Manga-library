import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/controllers/system_config.dart';
import 'package:manga_library/app/models/globais.dart';
import 'package:manga_library/app/views/configurations/library_config/libraries_config/controller/library_config_controller.dart';

import '../../../../models/libraries_model.dart';

class LibraryConfigMain extends StatefulWidget {
  const LibraryConfigMain({super.key});

  @override
  State<LibraryConfigMain> createState() => _LibraryConfigMainState();
}

class _LibraryConfigMainState extends State<LibraryConfigMain> {
  final ConfigSystemController _configSystemController =
      ConfigSystemController();
  final LibraryConfigController _libraryConfigController =
      LibraryConfigController();
  // guarda a ordem da biblioteca
  List<LibraryModel> lista = [];
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
          Text(
            "Deseja remover a Biblioteca $libraryName",
            textAlign: TextAlign.center,
          ),
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
    textController.value = TextEditingValue(text: name);
    // String valor = name;
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text("Renomear Biblioteca"),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              autofocus: true,
              controller: textController,
              // onChanged: (value) => valor = value,
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
                    _libraryConfigController.renameLibrary(
                        oldName: name, newName: textController.text);
                    Navigator.of(context).pop();
                  },
                  child: const Text("Renomear")),
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

  /// ir para a biblioteca oculta depois de autenticar
  void goToOcultLibrary(BuildContext context) {
    String value = "";
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text("Biblioteca Oculta"),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              autofocus: true,
              onChanged: (valor) => value = valor,
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
                    if (GlobalData.settings.hiddenLibraryPassword == value) {
                      GoRouter.of(context).push('/configlibrary/true');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Senha incorreta!'))
                      );
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text("Ir")),
            ],
          )
        ],
      ),
    );
  }

  Widget _sucess() {
    lista = _libraryConfigController.libraries;
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
                  // print(index);
                } while (index < noMove - oldIndex);
                lista[noMove] = item;
              }
              setState(() {});
            }
          }),
    );
  }

  Widget _stateManagement(OcultLibraryConfigStates state) {
    switch (state) {
      case OcultLibraryConfigStates.start:
        return _loading();
      case OcultLibraryConfigStates.loading:
        return _loading();
      case OcultLibraryConfigStates.restarting:
        return _loading();
      case OcultLibraryConfigStates.sucess:
        return _sucess();
      case OcultLibraryConfigStates.error:
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
              onPressed: () {
                if (lista.isNotEmpty) {
                  _libraryConfigController.sortLibrary(lista);
                }
              },
              icon: const Icon(Icons.checklist_rounded)),
          IconButton(
            tooltip: "Biblioteca Oculta",
            onPressed: () => goToOcultLibrary(context),
            icon: const Icon(Icons.lock),
          ),
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
                    decoration: const InputDecoration(
                        label: Text("Nome da Biblioteca")),
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
