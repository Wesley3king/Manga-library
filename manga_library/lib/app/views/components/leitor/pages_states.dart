import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/leitor_controller.dart';

import '../../../models/leitor_model.dart';

class PagesStates {
  Widget _loading() {
    return const SizedBox(
      width: double.infinity,
      height: 350,
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

  Widget page(String src, Function next, int index) {
    return IntrinsicHeight(
      child: Image(
        image: CachedNetworkImageProvider(
          src,
          ),
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
            //   print('delayed!');
              Future.delayed(const Duration(seconds: 2), () {
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
  List<Widget> builderList(ModelLeitor data, int count, Function next) {
    List<Widget> lista = [];
    for (int i = 0; i < count; ++i) {
      lista.add(page(data.pages[i], next, i));
    }
    return lista;
  }

  Widget listPages(ModelLeitor data, int count, Function next) {
    print('${data.pages.length} -- $count');
    // return ListView.builder(
    //   itemCount: count,
    //   itemBuilder: (context, index) => page(data.pages[index], next, index),
    // );
    return ListView(
      children: builderList(data, count, next),
    );
  }

  AnimatedBuilder pages(
      List<ModelLeitor> capitulos, PagesController controller) {
    controller.maxPages = capitulos[0].pages.length;
    return AnimatedBuilder(
      animation: controller.state,
      builder: ((context, child) => listPages(
            capitulos[0],
            controller.state.value,
            controller.startNextPage,
          )),
    );
  }
}
