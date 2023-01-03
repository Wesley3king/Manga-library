import 'package:flutter/material.dart';
import 'package:manga_library/app/views/about/controller/about_page_controller.dart';

class ManualPage extends StatelessWidget {
  final AboutPageController controller;
  const ManualPage({super.key, required this.controller});
  /*
  library,
  ocultLibrary,
  backup,
  extensions,
  updates
  */

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.local_library),
          title: Text("Biblioteca"),
        ),
        ListTile(
          leading: Icon(Icons.local_library_outlined),
          title: Text("Biblioteca Oculta"),
        ),
        ListTile(
          leading: Icon(Icons.backup),
          title: Text("Backup"),
        ),
        ListTile(
          leading: Icon(Icons.explore),
          title: Text("Extensões"),
        ),
        ListTile(
          leading: Icon(Icons.update),
          title: Text("Atualizações"),
        ),
        ListTile(
          leading: Icon(Icons.download),
          title: Text("Downloads"),
        ),
      ],
    );
  }
}
