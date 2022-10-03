
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/models/libraries_model.dart';

import '../../../controllers/search_controller.dart';
import '../../../models/search_model.dart';

class SearchResultsPage extends StatelessWidget {
  final List<SearchModel> results;
  const SearchResultsPage({super.key, required this.results});

  Widget item(Books data, var context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: GestureDetector(
        onTap: () {
          // List<String> corteUrl1 = data.link.split('manga/');
          GoRouter.of(context)
              .push('/detail/${data.link}/${data.idExtension}');
        },
        child: SizedBox(
          width: 110,
          height: 170,
          child: Column(
            mainAxisAlignment:   MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 145.0,
                height: 181.0,
                // child: Image.network(
                //   data.img,
                //   width: 145.0,
                //   height: 187.5,
                //   loadingBuilder: (context, child, loadingProgress) {
                //     if (loadingProgress == null) return child;
                //     return Container(
                //       color: Colors.grey,
                //     );
                //   },
                //   errorBuilder: (context, error, stackTrace) => const Center(
                //     child: Icon(Icons.report_problem),
                //   ),
                //   fit: BoxFit.fill,
                // ),
              ),
              Text(data.name,
                  overflow: TextOverflow.ellipsis,
                  strutStyle: StrutStyle.fromTextStyle(const TextStyle(
                    fontSize: 13,
                  ), height: 1.0,
                  forceStrutHeight: true,
                  fontSize: 13
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget resultList(SearchModel model, BuildContext context) {
    if (model.books.isEmpty) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 95,
        child: Padding(
          padding: const EdgeInsets.only(right: 18.0, bottom: 18.0, left: 18.0),
          child: Column(
            children: [
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: SizedBox(
                  height: 18,
                  child: Text(model.font, style: const TextStyle(fontWeight: FontWeight.bold,),)),
              ),
              const Center(child: Text("Nenhum resultado encontrado"),),
            ],
          ),
        ),
      );
    } else {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 255,
        child: Column(
          children: [
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                height: 18,
                child: Text(model.font, style: const TextStyle(fontWeight: FontWeight.bold,),)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: model.books.length,
                cacheExtent: 1000,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => item(model.books[index], context),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemCount: results.length + 1,
          cacheExtent: 10000,
          itemBuilder: (context, index) {
            if (index + 1 == results.length + 1 &&
                !SearchController.finalized) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (SearchController.finalized && index == results.length) {
              return Container();
            } else {
              return resultList(results[index], context);
            }
          },
        ));
  }
}
