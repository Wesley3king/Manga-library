import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/views/components/manga_info/trash/bottom_sheet_states.dart';

import '../../../controllers/manga_info_controller.dart';
// import '../../../controllers/system_config.dart';
import '../../../models/leitor_model.dart';
import '../../../models/manga_info_offline_model.dart';
import 'off_line/off_line_widget.dart';

class ChaptersListState extends StatefulWidget {
  final List<Capitulos> listaCapitulos;
  final List<ModelLeitor>? listaCapitulosDisponiveis;
  final Map<String, String> nameImageLink;

  const ChaptersListState({
    super.key,
    required this.listaCapitulos,
    required this.listaCapitulosDisponiveis,
    required this.nameImageLink,
  });

  @override
  State<ChaptersListState> createState() => _ChaptersListStateState();
}

class _ChaptersListStateState extends State<ChaptersListState> {
  int itemCount = 1;
  final ChaptersController chaptersController = ChaptersController();
  final BottomSheetStatesPages statePages = BottomSheetStatesPages();

  // trailings
  IconButton naoLido(String id, String link) {
    return IconButton(
      onPressed: () async {
        await chaptersController.marcarDesmarcar(
            id, link, widget.nameImageLink);
        chaptersController.updateChapters(widget.listaCapitulosDisponiveis,
            widget.listaCapitulos, widget.nameImageLink["link"]!);
      },
      icon: const Icon(Icons.check),
    );
  }

  IconButton lido(String id, String link) {
    return IconButton(
      onPressed: () async {
        await chaptersController.marcarDesmarcar(
            id, link, widget.nameImageLink);
        chaptersController.updateChapters(widget.listaCapitulosDisponiveis,
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

  // colors
  final TextStyle indisponivel = const TextStyle(color: Colors.red);

  Widget _chapterList() {
    // List<Widget> lista = [];
    // for (int index = 0; index < widget.listaCapitulos.length; ++index) {
    //   final Capitulos capitulo =
    //       ChaptersController.capitulosCorrelacionados[index];
    //   late dynamic id;
    //   try {
    //     id = int.parse(capitulo.id);
    //   } catch (e) {
    //     //print("não é um numero!");
    //     id = capitulo.id.split("-my");
    //     id = id[1];
    //     id.toString().replaceAll("/", "");
    //   }
    //   lista.add(ListTile(
    //     title: Text(
    //       'Capitulo ${capitulo.capitulo}',
    //       style: capitulo.disponivel ? const TextStyle() : indisponivel,
    //     ),
    //     subtitle: Text(capitulo.readed ? "lido" : "não lido"),
    //     leading: capitulo.readed
    //         ? lido(capitulo.id.toString(), widget.nameImageLink['link']!)
    //         : naoLido(capitulo.id.toString(), widget.nameImageLink['link']!),
    //     trailing: OffLineWidget(
    //       id: capitulo.id,
    //     ),
    //     onTap: () => GoRouter.of(context)
    //         .push('/leitor/${widget.nameImageLink['link']}/$id'),
    //   ));
    // }
    return ListView.builder(
      itemCount: widget.listaCapitulos.length,
      itemBuilder: (context, index) {
        final Capitulos capitulo =
            ChaptersController.capitulosCorrelacionados[index];
        late dynamic id;
        try {
          id = int.parse(capitulo.id);
        } catch (e) {
          //print("não é um numero!");
          id = capitulo.id.split("-my");
          id = id[1];
          id.toString().replaceAll("/", "");
        }
        return ListTile(
          title: Text(
            'Capitulo ${capitulo.capitulo}',
            style: capitulo.disponivel ? const TextStyle() : indisponivel,
          ),
          subtitle: Text(capitulo.readed ? "lido" : "não lido"),
          leading: capitulo.readed
              ? lido(capitulo.id.toString(), widget.nameImageLink['link']!)
              : naoLido(capitulo.id.toString(), widget.nameImageLink['link']!),
          trailing: OffLineWidget(
            id: capitulo.id,
          ),
          onTap: () => GoRouter.of(context)
              .push('/leitor/${widget.nameImageLink['link']}/$id'),
        );
      },
    );
  }

  Widget _stateManagement(ChaptersStates state) {
    switch (state) {
      case ChaptersStates.start:
        itemCount = 1;
        return _loading();
      case ChaptersStates.loading:
        itemCount = 1;
        return _loading();
      case ChaptersStates.sucess:
        itemCount = widget.listaCapitulos.length;
        return _chapterList();
      case ChaptersStates.error:
        itemCount = 1;
        return _error();
    }
  }

  @override
  void initState() {
    super.initState();
    print('iniciou ------');
    chaptersController.start(widget.listaCapitulosDisponiveis,
        widget.listaCapitulos, widget.nameImageLink["link"]!);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: chaptersController.state,
      builder: (context, child) => _stateManagement(chaptersController.state.value),
    );
  }
}
