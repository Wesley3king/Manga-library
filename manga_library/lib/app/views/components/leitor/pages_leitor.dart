import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/leitor_controller.dart';
import 'package:manga_library/app/views/components/leitor/pages_states.dart';
import 'package:manga_library/app/controllers/full_screen.dart';

class PagesLeitor extends StatefulWidget {
  final String link;
  final String id;
  const PagesLeitor({super.key, required this.link, required this.id});

  @override
  State<PagesLeitor> createState() => _PagesLeitorState();
}

class _PagesLeitorState extends State<PagesLeitor> with AutomaticKeepAliveClientMixin {
  final LeitorController _leitorController = LeitorController();
  final PagesController pagesController = PagesController();
  final PagesStates _pagesStates = PagesStates();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _leitorController.start(widget.link, widget.id);
    // pagesController.start();
  }

  @override
  Widget build(BuildContext context) {
    FullScreenController().enterFullScreen();
    return _pagesStates.pages(
      _leitorController.capitulosEmCarga,
      pagesController
    );
  }
}

