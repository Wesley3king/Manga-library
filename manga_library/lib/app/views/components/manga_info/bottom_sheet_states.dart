import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/views/components/manga_info/off_line/off_line_widget.dart';

import '../../../models/manga_info_offline_model.dart';

class BottomSheetStatesPages {
  // BottomSheetController bottomSheetController = BottomSheetController();
  Widget loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget sucess(List<Capitulos> capitulos, String link, Map<String, Function> metodos) {
    return ListView.builder(
        itemCount: capitulos.length,
        itemBuilder: (context, index) {
          final Capitulos capitulo = capitulos[index];
          // print(capitulo.readed ? "true" : "false");
          // print(capitulo.disponivel ? " d - true" : "d - false");
          return ListTile(
            title: Text(
              'Capitulo ${capitulo.capitulo}',
              style: capitulo.disponivel ? const TextStyle() : indisponivel,
            ),
            subtitle: Text(capitulo.readed ? "lido": "não lido"),
            leading: capitulo.readed ? metodos['lido']!(capitulo.id.toString(), link) : metodos['naoLido']!(capitulo.id.toString(), link),
            trailing: OffLineWidget(id: capitulo.id,),
            onTap: () => GoRouter.of(context).push('/leitor/$link/${capitulo.id}'),
          );
        });
  }

  // colors
  TextStyle indisponivel = const TextStyle(color: Colors.red);
  //TextStyle lido = const TextStyle(color: Colors.red);

  // trailings
  // GestureDetector naoLido(String id, String link) {
  //   return GestureDetector(
  //     onTap: () {
  //       bottomSheetController.marcarDesmarcar(id, link);
  //     },
  //     child: const Icon(Icons.check),
  //   );
  // }

  // GestureDetector lido(String id, String link) {
  //   return GestureDetector(
  //     onTap: () {
  //       bottomSheetController.marcarDesmarcar(id, link);
  //     },
  //     child: const Icon(
  //       Icons.check,
  //       color: Colors.green,
  //     ),
  //   );
  // }
}
