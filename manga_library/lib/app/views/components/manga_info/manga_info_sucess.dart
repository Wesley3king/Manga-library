import 'package:flutter/material.dart';
import 'package:manga_library/app/models/manga_info_model.dart';

class SucessMangaInfo extends StatelessWidget {
  final ModelMangaInfo dados;
  const SucessMangaInfo({super.key, required this.dados});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 400,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 400,
                    child: Image.network(dados.cover, fit: BoxFit.cover,),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 400,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        stops: [0.1,0.2, 1],
                        colors: [
                          Color.fromARGB(255, 48, 48, 48),
                          Color.fromARGB(237, 49, 49, 49),
                          Colors.transparent
                        ]
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                          width: 150,
                          height: 225,
                          child: Image.network(dados.cover, fit: BoxFit.fill,),
                        ),
                  )
                ],
              ),
            ),
            const SizedBox(width: 12,),
            Text(dados.chapterName, style: const TextStyle(fontSize: 22, ),),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Capítulos: ${dados.chapters}', textAlign: TextAlign.start,),
              )),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 37,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: dados.genres.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.green,width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6.0, right: 7.0, left: 7.0),
                      child: Text(dados.genres[index]),
                    ),
                  ),
                ),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(dados.description, textAlign: TextAlign.justify, style: TextStyle(fontSize: 16),),
            )
          ],
        )
      );
  }
}
