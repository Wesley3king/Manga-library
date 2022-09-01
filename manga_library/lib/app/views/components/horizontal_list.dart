import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/models/home_page_model.dart';

class HorizontalList extends StatefulWidget{
  final List<ModelHomePage> lista;
  final String identificacion;
  const HorizontalList(
      {super.key, required this.lista, required this.identificacion});

  @override
  State<HorizontalList> createState() => _HorizontalListState();
}

class _HorizontalListState extends State<HorizontalList>  with AutomaticKeepAliveClientMixin {
  Widget item(ModelHomePage data, var context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: GestureDetector(
        onTap: () {
          List<String> corteUrl1 = data.url.split('manga/');
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
                child: CachedNetworkImage(
                  imageUrl: data.img,
                  placeholder: (context, url) => Container(color: Colors.grey,),
                  errorWidget: (context, url, error) => const Center(child: Icon(Icons.report_problem),),
                  fit: BoxFit.fill,
                )
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
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 235,
      child: Column(
        children: [
          Text(widget.identificacion, style: const TextStyle(fontSize: 19)),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.lista.length,
              addAutomaticKeepAlives: true,
              itemBuilder: (context, index) => item(widget.lista[index], context),
            ),
          ),
        ],
      ),
    );
  }
}
/*
Image(
                  image: CachedNetworkImageProvider(data.img),
                  width: 145.0,
                  height: 187.5,
                  fit: BoxFit.fill,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Container(
                      color: Colors.grey,
                    );
                  },
                ),
                */