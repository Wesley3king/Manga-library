import 'package:flutter/material.dart';

class ButtomBottomSheetChapterList extends StatelessWidget {
  const ButtomBottomSheetChapterList({super.key});

  @override
  Widget build(BuildContext context) {
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
          showModalBottomSheet(
           // shape: ShapeBorder(),
            context: context,
            builder: (context) => SizedBox(
              height: 500,
              child: Column(
                children: [      
                  Container(
                    height: 35,
                    width: double.infinity,
                    color: Colors.blue,
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.close),
                    ),
                  ),
            
                  Expanded(
                    child: ListView.builder(
                      itemCount: 11,
                      itemBuilder: (context, index) => ListTile(
                        title: Text('item $index'),
                      ),),
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
