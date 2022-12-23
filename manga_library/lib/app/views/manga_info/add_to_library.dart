import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/system_config.dart';
import 'package:manga_library/app/models/globais.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

import '../../controllers/manga_info_controller.dart';
import '../../models/libraries_model.dart';

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
  final ConfigSystemController configSystemController =
      ConfigSystemController();
  final DialogController _dialogController = DialogController();
  bool isOcultLibrary = false;
  ValueNotifier<bool> isOnTheLibrary = ValueNotifier<bool>(false);

  // ========================================================================
  // ------------------------- OCULT LIBRARY --------------------------------
  // ========================================================================

  List<Map> resultadoForOcultLibrary = [];
  // gera os valores para o Dialog
  List<Widget> generateValuesForOcultLibrary(
      List<LibraryModel> lista, Function setState, BuildContext context) {
    if (resultadoForOcultLibrary.isEmpty) {
      RegExp regex = RegExp(widget.link, caseSensitive: false);

      for (int i = 0; i < lista.length; ++i) {
        bool existe = false;
        for (int iManga = 0; iManga < lista[i].books.length; ++iManga) {
          // print(
          //     '${lista[i].books[iManga].link} == ${widget.link}/ -- ${lista[i].books[iManga].idExtension} == ${widget.dados.idExtension}');
          if (lista[i].books[iManga].link.contains(regex) &&
              lista[i].books[iManga].idExtension == widget.dados.idExtension) {
            debugPrint("exite!!!");
            resultadoForOcultLibrary.add({
              "library": lista[i].library,
              "selected": true,
            });
            existe = true;
            break;
          }
        }
        if (!existe) {
          debugPrint("não exite!!!");
          resultadoForOcultLibrary.add({
            "library": lista[i].library,
            "selected": false,
          });
        }
      }
    }
    List<Widget> checkboxes = [];
    for (int i = 0; i < resultadoForOcultLibrary.length; ++i) {
      checkboxes.add(CheckboxListTile(
        title: Text(resultadoForOcultLibrary[i]['library']),
        value: resultadoForOcultLibrary[i]['selected'],
        onChanged: (value) => setState(() {
          resultadoForOcultLibrary[i]['selected'] =
              !resultadoForOcultLibrary[i]['selected'];
          debugPrint(resultadoForOcultLibrary[i]['selected']
              ? "adicionado!"
              : "removido!");
        }),
      ));
    }
    // adicionar a confirmação
    checkboxes.add(Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
            onPressed: () {
              resultadoForOcultLibrary = [];
              Navigator.of(context).pop();
              setState(() {
                isOcultLibrary = false;
              });
            },
            child: const Text('Cancelar')),
        TextButton(
            onPressed: () {
              _dialogController.addOrRemoveFromOcultLibrary(
                resultadoForOcultLibrary,
                {
                  // "name": widget.dados.name,
                  "link": widget.link,
                  // "img": widget.dados.img,
                  "idExtension": widget.dados.idExtension
                },
                link: widget.link,
                capitulos: widget.capitulos,
                model: widget.dados,
              );
              Navigator.of(context).pop();
              setState(() {
                isOcultLibrary = false;
              });
            },
            child: const Text('Confirmar')),
      ],
    ));
    return checkboxes;
  }

  buidDialogForOcultLibrary(BuildContext context) async {
    await _dialogController.startOcultLibrary();
    return await showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (context, setState) => SimpleDialog(
                  title: const Text('Adicionar a Oculta:'),
                  children: generateValuesForOcultLibrary(
                      _dialogController.dataOcultLibrary, setState, context),
                )));
  }

  // ========================================================================
  // ------------------------- LIBRARY --------------------------------
  // ========================================================================

  void verifyIfInLibraryToShowIcon(List<LibraryModel> lista) {
    RegExp regex = RegExp(widget.link, caseSensitive: false);
    bool existe = false;
    for (int i = 0; i < lista.length; ++i) {
      for (int iManga = 0; iManga < lista[i].books.length; ++iManga) {
        // debugPrint(
        //     '${lista[i].books[iManga].link} == ${widget.link}/ -- ${lista[i].books[iManga].idExtension} == ${widget.dados.idExtension}');
        if (lista[i].books[iManga].link.contains(regex) &&
            lista[i].books[iManga].idExtension == widget.dados.idExtension) {
          isOnTheLibrary.value = true;
          debugPrint("is on The LIBRARY!");
          existe = true;
          break;
        }
      }
      if (existe) {
        break;
      }
    }
    if (!existe) {
      isOnTheLibrary.value = false;
    }
  }

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
            onPressed: () async {
              resultado = [];
              Navigator.of(context).pop();
              // bool isAuthorized = false;
              String oldPassword = "";
              await showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  title: const Text("Insira a senha"),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 6.0),
                      child: TextField(
                        autofocus: true,
                        // decoration: const InputDecoration(
                        //     label: Text("Nome da Biblioteca")),
                        onChanged: (value) => oldPassword = value,
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
                              if (oldPassword !=
                                  GlobalData
                                      .settings.hiddenLibraryPassword) {
                                showMessage(context, "Senha Incorreta!");
                                Navigator.of(context).pop();
                              } else {
                                Navigator.of(context).pop();
                                buidDialogForOcultLibrary(context);
                              }
                            },
                            child: const Text("Confirmar")),
                      ],
                    )
                  ],
                ),
              );
            },
            child: const Text('Library')),
        TextButton(
            onPressed: () {
              resultado = [];
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar')),
        TextButton(
            onPressed: () async {
              doAsyncAddOrRemoveFromLibrary();
              Navigator.of(context).pop();
            },
            child: const Text('Confirmar')),
      ],
    ));
    return checkboxes;
  }

  void doAsyncAddOrRemoveFromLibrary() async {
    await _dialogController.addOrRemoveFromLibrary(
      resultado,
      {
        // "name": widget.dados.name,
        "link": widget.link, // '${widget.link}/'
        // "img": widget.dados.img,
        "idExtension": widget.dados.idExtension
      },
      link: widget.link,
      capitulos: widget.capitulos,
      model: widget.dados,
    );
    startDialog();
  }

  buildDialogForLibrary(BuildContext context) async {
    await _dialogController.start();
    return await showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) => SimpleDialog(
                title: const Text('Adicionar:'),
                children: generateValues(
                    _dialogController.dataLibrary, setState, context),
              ),
            ));
  }

  void startDialog() async {
    await _dialogController.start();
    verifyIfInLibraryToShowIcon(_dialogController.dataLibrary);
  }

  // ========== SHOW MESSAGES ============
  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();
    startDialog();
    // startar();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          // isOcultLibrary
          //     ? buidDialogForOcultLibrary(context)
          //     : buildDialogForLibrary(context);
          buildDialogForLibrary(context);
        },
        child: AnimatedBuilder(
            animation: isOnTheLibrary,
            builder: (context, child) => isOnTheLibrary.value
                ? Column(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: configSystemController.colorManagement(),
                        size: 26,
                      ),
                      Text("Na Biblioteca",
                          style: TextStyle(
                              fontSize: 13,
                              color: configSystemController.colorManagement()))
                    ],
                  )
                : Column(
                    children: const [
                      Icon(
                        Icons.favorite_border,
                        size: 26,
                      ),
                      Text("Adicionar a Biblioteca",
                          style: TextStyle(fontSize: 13))
                    ],
                  )));
  }
}

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
