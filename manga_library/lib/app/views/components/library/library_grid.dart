import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/models/libraries_model.dart';

class LibraryItens extends StatefulWidget {
  final LibraryModel data;
  const LibraryItens({super.key, required this.data});

  @override
  State<LibraryItens> createState() => _LibraryItensState();
}

class _LibraryItensState extends State<LibraryItens>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GridView.builder(
        addAutomaticKeepAlives: true,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          mainAxisExtent: 280,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: widget.data.books.length,
        itemBuilder: (context, index) => Container(
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
                color: Color.fromARGB(204, 0, 0, 0),
                offset: Offset(1.0, 1.0),
                blurRadius: 2.0)
          ]),
          width: 300,
          height: 350,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            child: Stack(
              children: [
                SizedBox(
                  width: 300,
                  height: 350,
                  child: CachedNetworkImage(
                    imageUrl: widget.data.books[index].img,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Container(color: Colors.grey,),
                    errorWidget: (context, url, error) => const Center(child: Icon(Icons.report_problem),),
                    ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 5,
                        bottom: 15.0,
                        left: 6.0,
                      ),
                      child: Text(
                        widget.data.books[index].name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                  color: Colors.black,
                                  offset: Offset(1.5, 1.5),
                                  blurRadius: 1.5)
                            ]),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    print('clickado!');
                    List<String> corteUrl1 = widget.data.books[index].link.split('manga/');
                    GoRouter.of(context).push('/info/${corteUrl1[1].replaceFirst('/', '')}');
                  },
                  style: ButtonStyle(
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(0))),
                  child: const SizedBox(
                    height: 350,
                    width: 300,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
