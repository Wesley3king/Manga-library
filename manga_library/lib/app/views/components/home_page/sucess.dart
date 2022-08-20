import 'package:flutter/material.dart';
import 'package:manga_library/app/models/home_page_model.dart';
import 'package:manga_library/app/views/components/horizontal_list.dart';

class Sucess extends StatelessWidget {
  final List<ModelHomePage> dados;
  List<ModelHomePage> lancamentos = [];
  List<ModelHomePage> popular = [];
  List<ModelHomePage> ultimosAtualizados = [];
  Sucess({super.key, required this.dados});

  alinharMangas() {
    for (int i = 0; i < dados.length; ++i) {
      if (i < 16) {
        lancamentos.add(dados[i]);
      } else if (i < 31) {
        popular.add(dados[i]);
      } else {
        ultimosAtualizados.add(dados[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    alinharMangas();
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 330,
            child: Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 330,
                  child: Image.network(
                    dados[0].img,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black, Color.fromARGB(43, 0, 0, 0)],
                        stops: [0.1, 1]),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        height: 225,
                        child: Image.network(dados[0].img),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(dados[0].name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          )),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          HorizontalList(lista: lancamentos),
          HorizontalList(lista: popular),
          HorizontalList(lista: ultimosAtualizados),
        ],
      ),
    );
  }
}
