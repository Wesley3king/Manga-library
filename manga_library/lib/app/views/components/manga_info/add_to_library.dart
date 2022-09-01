import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/manga_info_controller.dart';

import '../../../models/libraries_model.dart';

class AddToLibrary extends StatefulWidget {
  const AddToLibrary({super.key});

  @override
  State<AddToLibrary> createState() => _AddToLibraryState();
}

class _AddToLibraryState extends State<AddToLibrary> {
  final DialogController _dialogController = DialogController();

  List<Widget> _loading() {
    return const [
      Center(
        child: CircularProgressIndicator(),
      )
    ];
  }

  List<Widget> _error() {
    return [
      Center(
        child: Column(
          children: const <Widget>[
            Icon(Icons.report_problem),
            Text('Error'),
          ],
        ),
      ),
    ];
  }

  List<Widget> _sucess() {
    return _dialogController.addToLibraryCheckboxes;
  }

  List<Widget> _stateManagement(DialogStates state) {
    print('tipo de sucess = ${state}');
    print(_dialogController.addToLibraryCheckboxes);
    switch (state) {
      case DialogStates.start:
        return _loading();
      case DialogStates.loading:
        return _loading();
      case DialogStates.sucess:
        return _sucess();
      case DialogStates.error:
        return _error();
    }
  }

  List<Widget> checkboxes = [];
  List<Map> resultado = [];
  generateValues(List<LibraryModel> lista) {
    for (int i = 0; i < lista.length; ++i) {
      resultado.add({
        "library": lista[i].library,
        "selected": false,
      });
    }
    for (int i = 0; i < resultado.length; ++i) {
      checkboxes.add(CheckboxListTile(
        title: Text(resultado[i]['library']),
        value: resultado[i]['selected'],
        onChanged: (value) => setState(() {
          resultado[i]['selected'] = !resultado[i]['selected'];
          print('acionado --------');
          print(resultado[i]['selected'] ? "adicionado!" : "removido!");
        }),
      ));
    }
  }

  void startar() async {
    bool addToLibrary = await _dialogController.start();
    if (addToLibrary) {
      generateValues(_dialogController.dataLibrary);
    } else {
      checkboxes.add(const SizedBox(
        height: 100,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    startar();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 55,
        height: 55,
        child: IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  title: const Text('Adicionar:'),
                  children: checkboxes,
                ),
              );
            },
            icon: const Icon(
              Icons.favorite,
              size: 40,
            )));
  }
}
