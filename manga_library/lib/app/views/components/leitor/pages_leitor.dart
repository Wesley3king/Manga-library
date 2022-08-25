import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/leitor_controller.dart';

class PagesLeitor extends StatefulWidget {
  final String link;
  final String id;
  const PagesLeitor({super.key, required this.link, required this.id});

  @override
  State<PagesLeitor> createState() => _PagesLeitorState();
}

class _PagesLeitorState extends State<PagesLeitor> {
  LeitorController _leitorController = LeitorController();

  @override
  void initState() {
    super.initState();
    _leitorController.start(widget.link, widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
