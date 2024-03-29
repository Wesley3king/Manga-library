import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/controllers/system_config.dart';
import 'package:manga_library/app/models/libraries_model.dart';
import 'package:manga_library/app/views/library/functions/library_functions.dart';

class LibraryItens extends StatefulWidget {
  final LibraryModel data;
  const LibraryItens({super.key, required this.data});

  @override
  State<LibraryItens> createState() => _LibraryItensState();
}

class _LibraryItensState extends State<LibraryItens>
    with AutomaticKeepAliveClientMixin {
  final ConfigSystemController configSystemController = ConfigSystemController();
  // late ScrollController _scrollController;
  late List<double> sizeOfBooks;
  Widget createBook(BuildContext context, int index) {
    return Container(
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
            color: Color.fromARGB(204, 0, 0, 0),
            offset: Offset(1.0, 1.0),
            blurRadius: 2.0)
      ]),
      width: 300,
      height: 300,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        child: Stack(
          children: [
            SizedBox(
              width: 300,
              height: 300,
              child: CachedNetworkImage(
                imageUrl: widget.data.books[index].img,
                fit: BoxFit.fill,
                placeholder: (context, url) => Container(
                  color: Colors.grey,
                ),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(Icons.broken_image, size: 45,),
                ),
              ),
            ),
            widget.data.books[index].restantChapters != 0 ?
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                    top: 10.0
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: configSystemController.colorManagement(),
                      borderRadius: const BorderRadius.all(Radius.circular(7))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        widget.data.books[index].restantChapters.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.black,
                            // fontWeight: FontWeight.bold,
                          ),
                      ),
                    ),
                  ),
                ),
              ],
            ) : Container(),
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
                // print('clickado!');
                //List<String> corteUrl1 = widget.data.books[index].link.split('manga/');
                GoRouter.of(context).push(
                    '/detail/${widget.data.books[index].link.replaceFirst('/', '')}/${widget.data.books[index].idExtension}');
              },
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(0))),
              child: const SizedBox(
                height: 350,
                width: 300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    sizeOfBooks = getSizeOfBooks();
    // _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GridView.builder(
          addAutomaticKeepAlives: true,
          // controller: _scrollController,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: sizeOfBooks[0],
            mainAxisExtent: sizeOfBooks[1], // aqui ajustamos o height
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: (widget.data.books.length + 2),
          itemBuilder: (context, index) {
            if (index < widget.data.books.length) {
              return createBook(context, index);
            } else {
              return Container();
            }
          }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
