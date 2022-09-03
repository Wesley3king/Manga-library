import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/full_screen.dart';
import 'package:manga_library/app/controllers/leitor_controller.dart';

import '../../../models/leitor_model.dart';

class PagesStates {
  final FullScreenController fullScreenController = FullScreenController();

  Widget _loading() {
    return const SizedBox(
      width: double.infinity,
      height: 450,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _error(String src) {
    return SizedBox(
      width: double.infinity,
      height: 350,
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.info),
            const SizedBox(
              height: 10,
            ),
            const Text('Error!'),
            Text('image: $src')
          ],
        ),
      ),
    );
  }

  Widget page(String src) {
    return IntrinsicHeight(
      child: Image(
        image: CachedNetworkImageProvider(src),
        key: UniqueKey(),
        loadingBuilder: (
          context,
          child,
          loadingProgress,
        ) {
          if (loadingProgress == null) {
            // aqui já esta carregada
            // next();
            // print(' indice = $index');
            // if (index == 0) {
            // //   print('delayed!');
            // Future.delayed(const Duration(seconds: 2), () {
            //   print('executando ... $index');
            //   next();
            // });
            // } else {
            //   print(' index != 0 ok');
            //   //next();
            // }
            return child;
          }
          return _loading();
        },
        errorBuilder: (context, error, stackTrace) => _error(src),
      ),
    );
  }

/*
src,
        loadingBuilder: (
          context,
          child,
          loadingProgress,
        ) {
          if (loadingProgress == null) {
            // aqui já esta carregada
            // next();
            // print(' indice = $index');
            // if (index == 0) {
            //   print('delayed!');
              Future.delayed(const Duration(seconds: 1), () {
                print('executando ... $index');
                next();
              });
            // } else {
            //   print(' index != 0 ok');
            //   //next();
            // }
            return child;
          }
          return _loading();
        },
        errorBuilder: (context, error, stackTrace) => _error(src),
*/
  List<Widget> builderList(ModelLeitor data) {
    List<Widget> lista = [];
    for (int i = 0; i < data.pages.length; ++i) {
      lista.add(IntrinsicHeight(
          child: Image.network(
        data.pages[i],
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 500,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
        },
        errorBuilder: (context, error, stackTrace) => _error(data.pages[i]),
      )));
    }
    return lista;
  }

  Widget pages(List<ModelLeitor> capitulos, PagesController controller) {
    return InteractiveViewer(
      maxScale: 4.0,
      child: ListView(
        cacheExtent: 10000.0,
        addAutomaticKeepAlives: true,
        children: builderList(capitulos[0]),
      ),
    );
  }
}
