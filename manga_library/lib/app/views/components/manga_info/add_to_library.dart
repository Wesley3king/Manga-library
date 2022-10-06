import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/manga_info_controller.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

import '../../../models/leitor_pages.dart';
import '../../../models/libraries_model.dart';

class AddToLibrary extends StatefulWidget {
  final String link;
  final MangaInfoOffLineModel dados;
  final List<Capitulos> capitulos;
  const AddToLibrary({
    super.key,
    required this.link,
    required this.dados,
    required this.capitulos,
  });

  @override
  State<AddToLibrary> createState() => _AddToLibraryState();
}

class _AddToLibraryState extends State<AddToLibrary> {
  final DialogController _dialogController = DialogController();

  // List<Widget> _loading() {
  //   return const [
  //     Center(
  //       child: CircularProgressIndicator(),
  //     )
  //   ];
  // }

  // List<Widget> _error() {
  //   return [
  //     Center(
  //       child: Column(
  //         children: const <Widget>[
  //           Icon(Icons.report_problem),
  //           Text('Error'),
  //         ],
  //       ),
  //     ),
  //   ];
  // }

  // List<Widget> _sucess() {
  //   return _dialogController.addToLibraryCheckboxes;
  // }

  // List<Widget> _stateManagement(DialogStates state) {
  //   print('tipo de sucess = $state');
  //   print(_dialogController.addToLibraryCheckboxes);
  //   switch (state) {
  //     case DialogStates.start:
  //       return _loading();
  //     case DialogStates.loading:
  //       return _loading();
  //     case DialogStates.sucess:
  //       return _sucess();
  //     case DialogStates.error:
  //       return _error();
  //   }
  // }

  // ========================================================================
  // ------------------------- OCULT LIBRARY --------------------------------
  // ========================================================================

  List<Map> resultadoForOcultLibrary = [];
  // gera os valores para o Dialog
  generateValuesForOcultLibrary(
      List<LibraryModel> lista, BuildContext context) async {
    if (resultadoForOcultLibrary.isEmpty) {
      RegExp regex = RegExp(widget.link, caseSensitive: false);
      for (int i = 0; i < lista.length; ++i) {
        bool existe = false;
        for (int iManga = 0; iManga < lista[i].books.length; ++iManga) {
          // print(
          //     '${lista[i].books[iManga].link} == ${widget.link}/ -- ${lista[i].books[iManga].idExtension} == ${widget.dados.idExtension}');
          if (lista[i].books[iManga].link.contains(regex) &&
              lista[i].books[iManga].idExtension == widget.dados.idExtension) {
            resultadoForOcultLibrary.add({
              "library": lista[i].library,
              "selected": true,
            });
            existe = true;
            break;
          }
        }
        if (!existe) {
          resultadoForOcultLibrary.add({
            "library": lista[i].library,
            "selected": false,
          });
        }
      }
    }
    List<Widget> checkboxes = [];
    for (int i = 0; i < resultado.length; ++i) {
      checkboxes.add(CheckboxListTile(
        title: Text(resultadoForOcultLibrary[i]['library']),
        value: resultadoForOcultLibrary[i]['selected'],
        onChanged: (value) => setState(() {
          resultadoForOcultLibrary[i]['selected'] = !resultado[i]['selected'];
          debugPrint(resultado[i]['selected'] ? "adicionado!" : "removido!");
        }),
      ));
    }
    // adicionar a confirmação
    checkboxes.add(Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // TextButton(
        //     onPressed: () {
        //       resultado = [];
        //       Navigator.of(context).pop();
        //       Future.delayed(const Duration(milliseconds: 200), () {

        //       });
        //     },
        //     child: const Text('Library')),
        TextButton(
            onPressed: () {
              resultado = [];
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar')),
        TextButton(
            onPressed: () {
              _dialogController.addOrRemoveFromOcultLibrary(
                resultado,
                {
                  "name": widget.dados.name,
                  "link": widget.link, // '${widget.link}/'
                  "img": widget.dados.img,
                  "idExtension": widget.dados.idExtension
                },
                link: widget.link,
                capitulos: widget.capitulos,
                model: widget.dados,
              );
              Navigator.of(context).pop();
            },
            child: const Text('Confirmar')),
      ],
    ));
    // return checkboxes;
    await showDialog(
      context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => SimpleDialog(
            title: const Text('Adicionar:'),
            children: checkboxes,
        )
      )
    );
  }

  // ========================================================================
  // ------------------------- LIBRARY --------------------------------
  // ========================================================================


  List<Map> resultado = [];
  generateValues(
      List<LibraryModel> lista, Function setState, BuildContext context) {
    if (resultado.isEmpty) {
      RegExp regex = RegExp(widget.link, caseSensitive: false);
      for (int i = 0; i < lista.length; ++i) {
        bool existe = false;
        for (int iManga = 0; iManga < lista[i].books.length; ++iManga) {
          // print(
          //     '${lista[i].books[iManga].link} == ${widget.link}/ -- ${lista[i].books[iManga].idExtension} == ${widget.dados.idExtension}');
          if (lista[i].books[iManga].link.contains(regex) &&
              lista[i].books[iManga].idExtension == widget.dados.idExtension) {
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
          debugPrint(resultado[i]['selected'] ? "adicionado!" : "removido!");
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
              Future.delayed(const Duration(milliseconds: 200), () => generateValuesForOcultLibrary(_dialogController.dataOcultLibrary, context));
            },
            child: const Text('Library')),
        TextButton(
            onPressed: () {
              resultado = [];
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar')),
        TextButton(
            onPressed: () {
              _dialogController.addOrRemoveFromLibrary(
                resultado,
                {
                  "name": widget.dados.name,
                  "link": widget.link, // '${widget.link}/'
                  "img": widget.dados.img,
                  "idExtension": widget.dados.idExtension
                },
                link: widget.link,
                capitulos: widget.capitulos,
                model: widget.dados,
              );
              Navigator.of(context).pop();
            },
            child: const Text('Confirmar')),
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
