import 'package:flutter/material.dart';
import 'package:manga_library/app/views/components/leitor/pages_leitor.dart';

class Leitor extends StatelessWidget {
  final String link;
  final String id;
  const Leitor({super.key, required this.link, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: PagesLeitor(link: link, id: id,),
          ),
        ),
      ),
    );
  }
}
