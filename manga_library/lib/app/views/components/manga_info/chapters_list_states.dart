import 'package:flutter/material.dart';
import 'package:manga_library/app/views/components/manga_info/bottom_sheet_states.dart';
import 'package:manga_library/app/views/components/manga_info/chapters_list.dart';

import '../../../controllers/manga_info_controller.dart';
import '../../../controllers/system_config.dart';
import '../../../models/leitor_model.dart';
import '../../../models/manga_info_offline_model.dart';

class ChaptersListState extends StatefulWidget {
  final List<Capitulos> listaCapitulos;
  final List<ModelLeitor>? listaCapitulosDisponiveis;
  final Map<String, String> nameImageLink;
  const ChaptersListState(
      {super.key,
      required this.listaCapitulos,
      required this.listaCapitulosDisponiveis,
      required this.nameImageLink});

  @override
  State<ChaptersListState> createState() => _ChaptersListStateState();
}

class _ChaptersListStateState extends State<ChaptersListState> {
  final BottomSheetController bottomSheetController = BottomSheetController();
  final ConfigSystemController _configSystemController =
      ConfigSystemController();
  final BottomSheetStatesPages statePages = BottomSheetStatesPages();

  // trailings
  IconButton naoLido(String id, String link) {
    return IconButton(
      onPressed: () async {
        await bottomSheetController.marcarDesmarcar(
            id, link, widget.nameImageLink);
        bottomSheetController.update(widget.listaCapitulosDisponiveis,
            widget.listaCapitulos, widget.nameImageLink["link"]!);
      },
      icon: const Icon(Icons.check),
    );
  }

  IconButton lido(String id, String link) {
    return IconButton(
      onPressed: () async {
        await bottomSheetController.marcarDesmarcar(
            id, link, widget.nameImageLink);
        bottomSheetController.update(widget.listaCapitulosDisponiveis,
            widget.listaCapitulos, widget.nameImageLink["link"]!);
      },
      icon: const Icon(
        Icons.check,
        color: Colors.green,
      ),
    );
  }

  // states
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
          Text('Error!'),
        ],
      ),
    );
  }

  Widget _stateManagement(BottomSheetStates state) {
    switch (state) {
      case BottomSheetStates.start:
        return _loading();
      case BottomSheetStates.loading:
        return _loading();
      case BottomSheetStates.sucess:
        return MyChaptersListSucess(
          link: widget.nameImageLink["link"]!,
          capitulos: BottomSheetController.capitulosCorrelacionados,
          metodos: {"lido": lido, "naoLido": naoLido},
        );
      case BottomSheetStates.error:
        return _error();
    }
  }

  @override
  void initState() {
    super.initState();
    print('iniciou ------');
    bottomSheetController.start(widget.listaCapitulosDisponiveis,
        widget.listaCapitulos, widget.nameImageLink["link"]!);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: bottomSheetController.state,
      builder: (context, child) =>
          _stateManagement(bottomSheetController.state.value),
    );
  }
}
