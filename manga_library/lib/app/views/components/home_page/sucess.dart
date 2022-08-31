import 'package:flutter/material.dart';
import 'package:manga_library/app/models/home_page_model.dart';
import 'package:manga_library/app/views/components/horizontal_list.dart';

class Sucess extends StatelessWidget {
  final List<ModelHomePage> dados;
  final ScrollController controllerScroll;
  List<ModelHomePage> lancamentos = [];
  List<ModelHomePage> popular = [];
  List<ModelHomePage> ultimosAtualizados = [];
  Sucess({super.key, required this.dados, required this.controllerScroll});

  alinharMangas() {
    for (int i = 0; i < dados.length; ++i) {
      if (i < 18) {
        lancamentos.add(dados[i]);
      } else if (i < 33) {
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
      controller: controllerScroll,
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
                        height: 240,
                        child: Image.network(
                          dados[0].img,
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
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
          HorizontalList(
            lista: lancamentos,
            identificacion: 'Lançamentos',
          ),
          const SizedBox(
            height: 10,
          ),
          HorizontalList(
            lista: popular,
            identificacion: 'Popular',
          ),
          const SizedBox(
            height: 10,
          ),
          HorizontalList(
            lista: ultimosAtualizados,
            identificacion: 'Ultimos Atualizados',
          ),
        ],
      ),
    );
  }
}
