import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/controllers/historic_manager_controller.dart';
import 'package:manga_library/app/controllers/manga_info_controller.dart';
import 'package:manga_library/app/models/globais.dart';
import 'package:manga_library/app/models/historic_model.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';
import 'package:manga_library/app/views/manga_info/manga_details.dart';
import 'package:vs_scrollbar/vs_scrollbar.dart';

import '../../controllers/system_config.dart';
import 'off_line/off_line_widget.dart';

class SucessMangaInfo extends StatefulWidget {
  final MangaInfoOffLineModel dados;
  final bool sucess2;
  final List<Capitulos>? capitulosDisponiveis;
  final String link;
  final MangaInfoController controller;
  const SucessMangaInfo({
    super.key,
    required this.dados,
    required this.sucess2,
    required this.link,
    required this.capitulosDisponiveis,
    required this.controller,
  });

  @override
  State<SucessMangaInfo> createState() => _SucessMangaInfoState();
}

class _SucessMangaInfoState extends State<SucessMangaInfo> {
  final ManagerHistoricController historicController =
      ManagerHistoricController();
  final ConfigSystemController configSystemController =
      ConfigSystemController();
  late final ChaptersController chaptersController;
  late ScrollController _scrollController;

  int itemCount = 2;
  // colors
  final TextStyle indisponivel = const TextStyle(color: Colors.red);
  // final List<Capitulos> listaCapitulos;
  //   final List<ModelLeitor>? listaCapitulosDisponiveis;
  // trailings
  IconButton naoLido(String id, String link, String chapter) {
    Map<String, String> nameImageLink = {
      "name": widget.dados.name,
      "img": widget.dados.img,
      "link": widget.link
    };
    return IconButton(
      onPressed: () => markOrRemoveMark(id, link, chapter),
      icon: const Icon(Icons.check),
    );
  }

  IconButton lido(String id, String link, String chapter) {
    return IconButton(
      onPressed: () => markOrRemoveMark(id, link, chapter),
      icon: const Icon(
        Icons.check,
        color: Colors.green,
      ),
    );
  }

  /// marca os capitulos como lido ou remove-o da lista de lidos (caso já esteja lido)
  Future<void> markOrRemoveMark(String id, String link, String chapter) async {
    Map<String, String> nameImageLink = {
      "name": widget.dados.name,
      "img": widget.dados.img,
      "link": widget.link
    };
    await chaptersController.marcarDesmarcar(
        id, link, nameImageLink, widget.dados.idExtension);
    await historicController.insertOnHistoric(HistoricModel(
        name: widget.dados.name,
        img: widget.dados.img,
        link: widget.link,
        idExtension: widget.dados.idExtension,
        chapter: chapter,
        date: ""));
    chaptersController.updateChapters(widget.controller.capitulosDisponiveis,
        nameImageLink["link"]!, widget.dados.idExtension);
  }

  // states
  Widget _error() {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: Center(
        child: Column(
          children: const <Widget>[
            Icon(Icons.report_problem),
            Text('Error!'),
          ],
        ),
      ),
    );
  }

  Widget _buildChapter(BuildContext context, int index) {
    final Capitulos capitulo =
        ChaptersController.capitulosCorrelacionados[index - 1];
    GlobalData.capitulosDisponiveis;

    return ListTile(
      title: Text(
        'Capítulo ${capitulo.capitulo}', //  l = ${capitulo.pages.length}, ${capitulo.id}
        style: capitulo.disponivel
            ? capitulo.readed
                ? const TextStyle(color: Color.fromARGB(255, 184, 184, 184))
                : const TextStyle()
            : indisponivel,
      ),
      subtitle: Text(capitulo.description),
      leading: capitulo.readed
          ? lido(capitulo.id.toString(), widget.link, capitulo.capitulo)
          : naoLido(capitulo.id.toString(), widget.link, capitulo.capitulo),
      trailing: MangaInfoController.isAnOffLineBook
          ? OffLineWidget(
              capitulo: capitulo,
              model: widget.dados,
            )
          : const SizedBox(
              width: 1,
              height: 1,
            ),
      onTap: () async {
        if (!capitulo.readed) {
          markOrRemoveMark(
            capitulo.id.toString(), widget.link, capitulo.capitulo);
        }
        GoRouter.of(context).push(
            '/leitor/${widget.link}/${capitulo.id}/${widget.dados.idExtension}');
      },
    );
  }

  @override
  void initState() {
    super.initState();
    chaptersController = ChaptersController();
    MangaInfoController.chaptersController = chaptersController;
    _scrollController = ScrollController();
    //print("link: ${widget.link}");
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sucess2) {
      if (chaptersController.state.value == ChaptersStates.start) {
        chaptersController.start(widget.capitulosDisponiveis,
            widget.dados.capitulos, widget.link, widget.dados.idExtension);
      }
      return RefreshIndicator(
        color: configSystemController.colorManagement(),
        onRefresh: () async {
          if (chaptersController.state.value == ChaptersStates.sucess) {
            await widget.controller.updateBook(
                widget.link,
                /*chaptersController*/
                widget.dados.idExtension);
          }
        },
        child: AnimatedBuilder(
            animation: chaptersController.state,
            builder: (context, child) {
              chaptersController.state.value == ChaptersStates.sucess
                  ? itemCount =
                      (ChaptersController.capitulosCorrelacionados.length + 1)
                  : itemCount = 2;
              switch (chaptersController.state.value) {
                case ChaptersStates.start:
                  return ListView(
                    children: [
                      MangaDetails(
                          link: widget.link,
                          dados: widget.dados,
                          controller: widget.controller,
                          capitulosDisponiveis: widget.capitulosDisponiveis),
                      Column(
                        children: [
                          LinearProgressIndicator(
                              color: configSystemController.colorManagement()),
                          const Text(
                            "Carregando os Capitulos",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  );
                case ChaptersStates.loading:
                  return ListView(
                    children: [
                      MangaDetails(
                          link: widget.link,
                          dados: widget.dados,
                          controller: widget.controller,
                          capitulosDisponiveis: widget.capitulosDisponiveis),
                      const SizedBox(
                        height: 3.0,
                      ),
                      Column(
                        children: [
                          LinearProgressIndicator(
                              color: configSystemController.colorManagement()),
                          const Text(
                            "Carregando os Capitulos",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                    ],
                  );
                case ChaptersStates.sucess:
                  return VsScrollbar(
                    controller: _scrollController,
                    style: const VsScrollbarStyle(
                        color: Color.fromARGB(223, 158, 158, 158)),
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          ChaptersController.capitulosCorrelacionados.length +
                              1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return MangaDetails(
                              link: widget.link,
                              dados: widget.dados,
                              controller: widget.controller,
                              capitulosDisponiveis:
                                  widget.capitulosDisponiveis);
                        } else {
                          return _buildChapter(context, index);
                        }
                      },
                    ),
                  );
                case ChaptersStates.error:
                  return ListView(
                    children: [
                      MangaDetails(
                          link: widget.link,
                          dados: widget.dados,
                          controller: widget.controller,
                          capitulosDisponiveis: widget.capitulosDisponiveis),
                      _error(),
                    ],
                  );
              }
            }),
      );
    } else {
      return ListView(
        children: [
          MangaDetails(
              link: widget.link,
              dados: widget.dados,
              controller: widget.controller,
              capitulosDisponiveis: widget.capitulosDisponiveis),
          const SizedBox(
            height: 3.0,
          ),
          Column(
            children: [
              LinearProgressIndicator(
                  color: configSystemController.colorManagement()),
              const Padding(
                padding: EdgeInsets.all(4.0),
                child: Text(
                  "Carregando os Capítulos",
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
        ],
      );
    }
  }
}
