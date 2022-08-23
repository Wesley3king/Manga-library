import 'package:flutter/material.dart';

import '../../../models/manga_info_model.dart';

class BottomSheetStatesPages {
  Widget loading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget sucess(List<ModelCapitulosCorrelacionados> capitulos) {
    print('length: ${capitulos.length}');
    return ListView.builder(
        itemCount: capitulos.length,
        itemBuilder: (context, index) {
          final ModelCapitulosCorrelacionados capitulo = capitulos[index];
          return ListTile(
            title: Text(
              'Capitulo ${capitulo.capitulo}',
              style: capitulo.disponivel ? const TextStyle() : indisponivel,
            ),
          );
        });
  }
}

TextStyle indisponivel = const TextStyle(color: Colors.red);
TextStyle lido = const TextStyle(color: Colors.red);

/*
ListView.builder(
                        itemCount: listaCapitulos.length,
                        itemBuilder: (context, index) {
                          final Allposts capitulo = listaCapitulos[index];
                          return ListTile(
                            title: Text('Capitulo ${capitulo.num}'),
                          );
                        }),
                        */