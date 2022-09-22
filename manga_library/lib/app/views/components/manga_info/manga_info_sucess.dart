import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/controllers/manga_info_controller.dart';
import 'package:manga_library/app/models/globais.dart';
import 'package:manga_library/app/models/leitor_pages.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';
// import 'package:manga_library/app/views/components/manga_info/add_to_library.dart';
// import 'package:manga_library/app/views/components/manga_info/chapters_list_states.dart';
import 'package:manga_library/app/views/components/manga_info/manga_details.dart';

import '../../../controllers/system_config.dart';
import '../../../models/globais.dart';
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
  final ConfigSystemController configSystemController =
      ConfigSystemController();
  final ChaptersController chaptersController = ChaptersController();

  int itemCount = 2;
  // colors
  final TextStyle indisponivel = const TextStyle(color: Colors.red);
  // final List<Capitulos> listaCapitulos;
  //   final List<ModelLeitor>? listaCapitulosDisponiveis;
  // trailings
  IconButton naoLido(String id, String link) {
    Map<String, String> nameImageLink = {
      "name": widget.dados.name,
      "img": widget.dados.img,
      "link": widget.link
    };
    return IconButton(
      onPressed: () async {
        await chaptersController.marcarDesmarcar(id, link, nameImageLink);
        chaptersController.updateChapters(
            widget.controller.capitulosDisponiveis,
            ChaptersController.capitulosCorrelacionados,
            nameImageLink["link"]!);
      },
      icon: const Icon(Icons.check),
    );
  }

  IconButton lido(String id, String link) {
    Map<String, String> nameImageLink = {
      "name": widget.dados.name,
      "img": widget.dados.img,
      "link": widget.link
    };
    return IconButton(
      onPressed: () async {
        await chaptersController.marcarDesmarcar(id, link, nameImageLink);
        chaptersController.updateChapters(
            widget.controller.capitulosDisponiveis,
            ChaptersController.capitulosCorrelacionados,
            nameImageLink["link"]!);
      },
      icon: const Icon(
        Icons.check,
        color: Colors.green,
      ),
    );
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
    //GlobalData.capitulosDisponiveis;
    // print(
    //     "========= \n capitulo: ${capitulo.capitulo}/ ${capitulo.disponivel} / ${capitulo.readed}");
    // print("chapters count  ${capitulo.capitulo}/ ${capitulo.pages.length}");
    late dynamic id;
    try {
      if (capitulo.id is int) {
        id = capitulo.id;
      } else {
        id = int.parse(capitulo.id);
      }
    } catch (e) {
      //print("não é um numero! $e");
      id = capitulo.id.split("-my");
      id = id[1];
      id.toString().replaceAll("/", "");
    }
    return ListTile(
      title: Text(
        'Capitulo ${capitulo.capitulo} l = ${capitulo.pages.length}',
        style: capitulo.disponivel ? const TextStyle() : indisponivel,
      ),
      subtitle: Text(capitulo.readed ? "lido" : "não lido"),
      leading: capitulo.readed
          ? lido(capitulo.id.toString(), widget.link)
          : naoLido(capitulo.id.toString(), widget.link),
      trailing: MangaInfoController.isAnOffLineBook ? OffLineWidget(
        capitulo: capitulo,
        model: widget.dados,
      ) : const SizedBox(width: 1, height: 1,),
      onTap: () => GoRouter.of(context).push('/leitor/${widget.link}/$id'),
    );
  }

  @override
  void initState() {
    super.initState();
    //print("link: ${widget.link}");
  }

  // Widget _stateManagement(
  //     BuildContext context, ChaptersStates state, int index) {
  //   switch (state) {
  //     case ChaptersStates.start:
  //       return _loading();
  //     case ChaptersStates.loading:
  //       return _loading();
  //     case ChaptersStates.sucess:
  //       return _buildChapter(context, index);
  //     case ChaptersStates.error:
  //       return _error();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (widget.sucess2) {
      if (chaptersController.state.value == ChaptersStates.start) {
        chaptersController.start(
            widget.capitulosDisponiveis, widget.dados.capitulos, widget.link);
      }
      return RefreshIndicator(
        color: configSystemController.colorManagement(),
        onRefresh: () async {
          if (chaptersController.state.value == ChaptersStates.sucess) {
            await widget.controller.updateBook(widget.link, chaptersController);
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
                  return ListView.builder(
                    itemCount:
                        ChaptersController.capitulosCorrelacionados.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return MangaDetails(
                            link: widget.link,
                            dados: widget.dados,
                            controller: widget.controller,
                            capitulosDisponiveis: widget.capitulosDisponiveis);
                      } else {
                        return _buildChapter(context, index);
                      }
                    },
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
/*
if (ChaptersController.capitulosCorrelacionados.isEmpty) {
                    return Column(
                      children: [
                        LinearProgressIndicator(color: configSystemController.colorManagement()),
                        const Text("Carregando os Capitulos", textAlign: TextAlign.center,),
                      ],
                    );
                  } else {
                    return _buildChapter(context, index);
                  }
*/