import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
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
          List<String> corteUrl1 = data.link.split('manga/');
          GoRouter.of(context)
              .push('/info/${corteUrl1[1].replaceFirst('/', '')}');
        },
        child: SizedBox(
          width: 110,
          height: 170,
          child: Column(
            children: [
              SizedBox(
                width: 145.0,
                height: 187.5,
                child: Image.network(
                  data.img,
                  width: 145.0,
                  height: 187.5,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey,
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(Icons.report_problem),
                  ),
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

  Widget resultList(SearchModel model) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        itemCount: model.books.length,
        cacheExtent: 1000,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => item(model.books[index], context),
      ),
    );
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
              return resultList(results[index]);
            }
          },
        ));
  }
}
