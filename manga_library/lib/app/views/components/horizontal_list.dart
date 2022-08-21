import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/models/home_page_model.dart';

class HorizontalList extends StatelessWidget {
  final List<ModelHomePage> lista;
  final String identificacion;
  const HorizontalList(
      {super.key, required this.lista, required this.identificacion});

  Widget item(ModelHomePage data, var context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: GestureDetector(
        onTap: () {
          List<String> corteUrl1 = data.url.split('manga/');
          GoRouter.of(context).push('/info/${corteUrl1[1].replaceFirst('/','')}');
        },
        child: SizedBox(
          width: 110,
          height: 170,
          child: Column(
            children: [
              SizedBox(
                width: 145,
                height: 187.5,
                child: Image.network(
                  data.img,
                  fit: BoxFit.fill,
                ),
              ),
              Text(data.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 235,
      child: Column(
        children: [
          Text(identificacion, style: const TextStyle(fontSize: 19)),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: lista.length,
              itemBuilder: (context, index) => item(lista[index], context),
            ),
          ),
        ],
      ),
    );
  }
}
