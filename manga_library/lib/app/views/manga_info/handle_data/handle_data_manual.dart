import 'package:flutter/material.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

import '../../../controllers/system_config.dart';

dynamic handleData(BuildContext context, MangaInfoOffLineModel model) async {
  final TextEditingController nameController = TextEditingController(text: model.name);
  final TextEditingController linkController = TextEditingController(text: model.link);
  final TextEditingController imgController = TextEditingController(text: model.img);
  final TextEditingController descriptionController = TextEditingController(text: model.description);
  final TextEditingController authorsController = TextEditingController(text: model.authors);
  // print("--------- HERO'S COME BACK ------------------");
  return await showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: const Text("Editar dados"),
      children: [
        const ListTile(
          leading: Icon(Icons.report_problem),
          subtitle: Text(
              "Atenção, a alteração de dados pode ocasionar um mal funcionamento do aplicativo, podendo levar a perda de todos os dados deste, use somente quando necessario!"),
        ),

        SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Nome"),
                    TextField(
                      controller: nameController,
                      keyboardType: TextInputType.text,
                    ),
                  ],
                )
              ),
            ),
          ),

        SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Link"),
                    TextField(
                      controller: linkController,
                      keyboardType: TextInputType.text,
                    ),
                  ],
                ),
              ),
            ),
          ),

        SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Imagem"),
                    TextField(
                      controller: imgController,
                      keyboardType: TextInputType.text,
                    ),
                  ],
                ),
              ),
            ),
          ),

        SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Descrição"),
                    TextField(
                      controller: descriptionController,
                      keyboardType: TextInputType.text,
                    ),
                  ],
                ),
              ),
            ),
          ),

        SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Autor"),
                    TextField(
                      controller: authorsController,
                      keyboardType: TextInputType.text,
                    ),
                  ],
                ),
              ),
            ),
          ),

          Wrap(
            children: model.genres.map((genre) => Padding(
                padding: const EdgeInsets.all(3.0),
                child: SizedBox(
                  height: 25.0,
                  child: Chip(
                    avatar: const Icon(Icons.close, size: 17.0,),
                    padding: const EdgeInsets.all(0),
                    labelStyle: const TextStyle(height: 0.3),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: Colors.transparent,
                    label: Text(genre),
                  ),
                ),
              )
            ).toList(),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancelar")),
              TextButton(
                  onPressed: () {},
                  child: const Text("Modificar")),
            ],
          )
      ],
    ),
  );
}
