import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/extensions/extensions.dart';

class ExtensionsPage extends StatefulWidget {
  const ExtensionsPage({super.key});

  @override
  State<ExtensionsPage> createState() => _ExtensionsPageState();
}

class _ExtensionsPageState extends State<ExtensionsPage> {
  @override
  Widget build(BuildContext context) {
    List<int> keys = mapOfExtensions.keys.toList();
    return ListView.builder(
      itemCount: keys.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(mapOfExtensions[keys[index]]!.nome),
        leading: SizedBox(
          width: 20,
          height: 20,
          child: Image.asset(
            'assets/extesion_posters/${mapOfExtensions[keys[index]]!.extensionPoster}',
            fit: BoxFit.cover,
          ),
        ),
      ),);
  }
}