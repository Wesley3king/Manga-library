
import 'package:flutter/material.dart';
import 'package:manga_library/app/models/home_page_model.dart';

class HorizontalList extends StatelessWidget {
  final List<ModelHomePage> lista;
  const HorizontalList({super.key, required this.lista});

  Widget item(ModelHomePage data) {
    return SizedBox(
      width: 110,
      height: 170,
      child: Column(
        children: [
          SizedBox(
            width: 100,
            height: 150,
            child: Image.network(data.img),
          ),
          Text(data.name, style: const TextStyle(
            color: Color.fromARGB(255, 3, 3, 3),
            fontSize: 14,
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => item(lista[index]),
      ),
    );
  }
}
