import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/manga_info_controller.dart';
import 'package:manga_library/app/models/manga_info_model.dart';

import '../../../models/leitor_model.dart';
import '../../../models/libraries_model.dart';

class AddToLibrary extends StatefulWidget {
  final String link;
  final ModelMangaInfo dados;
  final List<ModelLeitor> capitulos;
  const AddToLibrary(
      {super.key,
      required this.link,
      required this.dados,
      required this.capitulos,
    });

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

  List<Map> resultado = [];
  generateValues(
      List<LibraryModel> lista, Function setState, BuildContext context) {
    if (resultado.isEmpty) {
      for (int i = 0; i < lista.length; ++i) {
        bool existe = false;
        for (int iManga = 0; iManga < lista[i].books.length; ++iManga) {
          // print('${lista[i].books[iManga].link} == ${widget.link}/');
          if (lista[i].books[iManga].link == '${widget.link}/') {
            resultado.add({
              "library": lista[i].library,
              "selected": true,
            });
            existe = true;
            break;
          }
        }
        if (!existe) {
          resultado.add({
            "library": lista[i].library,
            "selected": false,
          });
        }
      }
    }
    List<Widget> checkboxes = [];
    for (int i = 0; i < resultado.length; ++i) {
      checkboxes.add(CheckboxListTile(
        title: Text(resultado[i]['library']),
        value: resultado[i]['selected'],
        onChanged: (value) => setState(() {
          resultado[i]['selected'] = !resultado[i]['selected'];
          print(resultado[i]['selected'] ? "adicionado!" : "removido!");
        }),
      ));
    }
    // adicionar a confirmação
    checkboxes.add(Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
            onPressed: () {
              resultado = [];
              Navigator.of(context).pop();
            },
            child: const Text('cancelar')),
        TextButton(
            onPressed: () {
              _dialogController.addOrRemoveFromLibrary(
                resultado,
                {
                  "name": widget.dados.chapterName,
                  "link": '${widget.link}/',
                  "img": widget.dados.cover,
                },
                link: widget.link,
                capitulos: widget.capitulos,
                model: widget.dados,
              );
              Navigator.of(context).pop();
            },
            child: const Text('confirmar')),
      ],
    ));
    return checkboxes;
  }

  void startar() async {
    bool addToLibrary = await _dialogController.start();
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
                  builder: (context) => StatefulBuilder(
                        builder: (context, setState) => SimpleDialog(
                          title: const Text('Adicionar:'),
                          children: generateValues(
                              _dialogController.dataLibrary, setState, context),
                        ),
                      ));
            },
            icon: const Icon(
              Icons.favorite,
              size: 40,
            )));
  }
}
