import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/manga_info_controller.dart';
import 'package:manga_library/app/models/leitor_model.dart';
import 'package:manga_library/app/models/manga_info_model.dart';
import 'package:manga_library/app/views/components/error.dart';
import 'package:manga_library/app/views/components/manga_info/bottom_sheet_states.dart';

class ButtomBottomSheetChapterList extends StatefulWidget {
  final List<Allposts> listaCapitulos;
  final List<ModelLeitor>? listaCapitulosDisponiveis;
  const ButtomBottomSheetChapterList(
      {super.key,
      required this.listaCapitulos,
      required this.listaCapitulosDisponiveis});

  @override
  State<ButtomBottomSheetChapterList> createState() =>
      _ButtomBottomSheetChapterListState();
}

class _ButtomBottomSheetChapterListState
    extends State<ButtomBottomSheetChapterList> {
  final BottomSheetController bottomSheetController = BottomSheetController();

  final BottomSheetStatesPages statePages = BottomSheetStatesPages();

  Widget _stateManagement(BottomSheetStates state) {
    switch (state) {
      case BottomSheetStates.start:
        return statePages.loading();
      case BottomSheetStates.loading:
        return statePages.loading();
      case BottomSheetStates.sucess:
        return statePages.sucess(bottomSheetController.capitulosCorrelacionados);
      case BottomSheetStates.error:
        return const ErrorHomePage();
    }
  }

  @override
  void initState() {
    super.initState();
    print('iniciou ------');
    bottomSheetController.start(widget.listaCapitulosDisponiveis, widget.listaCapitulos);
  }

  @override
  Widget build(BuildContext context) {
    const double bottomSheetRadius = 25.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.green),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(21),
          )),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const <Widget>[
            Icon(
              Icons.bookmark,
              size: 40,
            ),
            Text(
              'Capítulos',
              style: TextStyle(fontSize: 24),
            )
          ],
        ),
        onPressed: () {
          //print();
          showModalBottomSheet(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(bottomSheetRadius),
                    topRight: Radius.circular(bottomSheetRadius))),
            context: context,
            builder: (context) => SizedBox(
              height: 500,
              child: Column(
                children: [
                  Container(
                    height: 35,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(bottomSheetRadius),
                            topRight: Radius.circular(bottomSheetRadius))),
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 5, right: 8),
                        child: Icon(
                          Icons.close,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: AnimatedBuilder(
                    animation: bottomSheetController.state,
                    builder: (context, child) =>
                        _stateManagement(bottomSheetController.state.value),
                  ))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
