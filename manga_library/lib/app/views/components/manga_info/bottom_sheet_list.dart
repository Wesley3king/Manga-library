import 'package:flutter/material.dart';
import 'package:manga_library/app/models/manga_info_model.dart';

class ButtomBottomSheetChapterList extends StatelessWidget {
  final List<Allposts> listaCapitulos;
  const ButtomBottomSheetChapterList({super.key, required this.listaCapitulos});

  @override
  Widget build(BuildContext context) {
    const double bottomSheetRadius = 25.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.green),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(21),
          )),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const <Widget>[
            Icon(
              Icons.bookmark,
              size: 40,
            ),
            Text(
              'Capítulos',
              style: TextStyle(fontSize: 24),
            )
          ],
        ),
        onPressed: () {
          //print();
          showModalBottomSheet(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(bottomSheetRadius),
                    topRight: Radius.circular(bottomSheetRadius))),
            context: context,
            builder: (context) => SizedBox(
              height: 500,
              child: Column(
                children: [
                  Container(
                    height: 35,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(bottomSheetRadius),
                            topRight: Radius.circular(bottomSheetRadius))),
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 5, right: 8),
                        child: Icon(
                          Icons.close,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: listaCapitulos.length,
                        itemBuilder: (context, index) {
                          final Allposts capitulo = listaCapitulos[index];
                          return ListTile(
                            title: Text('Capitulo ${capitulo.num}'),
                          );
                        }),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
