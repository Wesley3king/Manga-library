import 'package:flutter/foundation.dart';
import 'package:manga_library/app/extensions/gekkou_scans/repositories/gekkou_scans_repositories.dart';
import 'package:manga_library/app/extensions/gekkou_scans/scraping/scraping_gekkou_scans.dart';
import 'package:manga_library/app/extensions/model_extension.dart';

import '../../models/home_page_model.dart';
import '../../models/libraries_model.dart';
import '../../models/manga_info_offline_model.dart';

class ExtensionGekkouScans implements Extension {
  @override
  dynamic fetchServices;
  @override
  String nome = "Gekkou Scans";
  @override
  String extensionPoster = "Gekkou-scans.png";
  @override
  int id = 11;
  @override
  bool nsfw = false;
  @override
  Map<String, dynamic>? fetchImagesHeader = {
    "cookie": "cf_clearance=beRkkliZa_oDeD9sVJ3g8alGhXWDkTMdEydyM_TdVdQ-1664823047-0-150; _ga=GA1.3.1765495821.1664823050; __gads=ID=c742cba7cc7ab987-228cd762fa7e003b:T=1664823050:RT=1664823050:S=ALNI_MaHYwDGg4w_JHUVwXp-j8MKabizmw; HstCfa4658307=1664823295697; __dtsu=51A0164372492599D7863ED261253C7B; _cc_id=904481d0e7ca73e696106b90b3de23; HstCmu4658307=1671624926751; _gid=GA1.3.323795942.1671722594; __gpi=UID=00000873d36b0e94:T=1664823050:RT=1671722594:S=ALNI_MaZa8PMjxA2XXsC5o2qKvyIoyedUA; __cf_bm=qfsH35cQYGKU4dHo91qFs6P6NCz8qy0lMf7s_cTDh2M-1671722594-0-Ab711OzVcZ+KpsQUCuIVfm4FTcOeXBjSdHa8pMTxhSjZuoKlgnxzE8FPMC3YTaYcuc0XYhf2uAmKBy7pkPjhsncfS0PMxTLJDoi9juMyRMTmDYhn79tyB5f68y8mhdo+wt5WukX7Oeqc6uHQyu5QUYw=; HstCla4658307=1671722603665; HstPn4658307=1; HstPt4658307=18; HstCnv4658307=4; HstCns4658307=9; panoramaId_expiry=1672327408242; panoramaId=de96a9a33478236fa115efc5475416d53938bc40ace7f3c0a299de1125427a3b; XSRF-TOKEN=eyJpdiI6InFYTzk0UmRhanJlaUx5ZkxxM2NxN2c9PSIsInZhbHVlIjoiRjg3TGgxbDJhSU5Qd0swSGhadmdyUXV5K05DZGpPN2dNaHBVNmlXaUEraTREWlNMTDhYUkVyaFYrRnYxZ0VMM2NYN0xLd010UERzY1JuVlFacUgyNXc9PSIsIm1hYyI6ImZhMTY4NjY2MjZiNTI5ZjQzOTFmY2U5YzFhMjVmYWYwZDZkZTg5NTkyMzBiYTQzN2FiYjQ0MGIwZDQwZGVmYTkifQ%3D%3D; laravel_session=eyJpdiI6ImFHNTJnaUdkY0NUOU80bkN6ZHdUdkE9PSIsInZhbHVlIjoidVZXTmxzU3hwWlwvU1hQXC9ydXFnb2wzZHZMZm5pUkxoTW9taUtIYWNrbUFDWUYyZzg4WmZsK0VKTW1KSXdDSWg0THdzSHFBYlpyK0JrNjR1M2xHa2t3QT09IiwibWFjIjoiY2JlYzA4NmQxNjE4Y2EwOWQxNjQ0NDI3NDFmMWQxZGZmNGQzNTA1NzIyNWQ0NzY4YTMwZTBiNGMzY2Q0NjA4MSJ9",
    "referer": "https://gekkou.com.br/manga/eleceed/1/1",
    "sec-ch-ua": '"Google Chrome";v="105", "Not)A;Brand";v="8", "Chromium";v="105"',
    "sec-ch-ua-mobile": "?0",
    "sec-ch-ua-platform": "Linux",
    "sec-fetch-dest": "image",
    "sec-fetch-mode": "no-cors",
    "sec-fetch-site": "same-origin",
    "user-agent": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36"
  };

  @override
  Future<List<ModelHomePage>> homePage() async {
    return await compute(scrapingHomePage, 0);
  }

  @override
  Future<MangaInfoOffLineModel?> mangaDetail(String link) async {
    return await scrapingMangaDetail(link);
  }

  @override
  String getLink(String pieceOfLink) =>
      "https://gekkou.com.br/manga/$pieceOfLink";

  @override
  Future<Capitulos> getPages(String id, List<Capitulos> listChapters) async {
    Capitulos result = Capitulos(
        capitulo: "",
        id: "",
        description: "",
        mark: false,
        download: false,
        downloadPages: [],
        pages: [],
        readed: false);
    for (int i = 0; i < listChapters.length; ++i) {
      // print(
      //     "teste: num cap: ${listChapters[i].id} $id, id: $id / ${int.parse(listChapters[i].id) == int.parse(id)}");
      if (listChapters[i].id == id) {
        result = listChapters[i];
        break;
      }
    }
    if (!result.download) {
      try {
        result.pages = await scrapingLeitor(id);
      } catch (e) {
        debugPrint("erro - não foi possivel obter as paginas on-line: $e");
      }
    }
    return result;
  }

  @override
  Future<List<String>> getPagesForDownload(String url) async {
    return await scrapingLeitor(url);
  }

  @override
  Future<List<Books>> search(String txt) async {
    try {
      debugPrint("GEKKOU SCANS SEARCH STARTING...");
      StringBuffer buffer = StringBuffer();
      List<String> cortes = txt.split(" ");

      for (int i = 0; i < cortes.length; ++i) {
        final String str = cortes[i];
        if (i == (cortes.length - 1)) {
          buffer.write(str);
        } else {
          buffer.write('$str+');
        }
      }
      List<Map<String, dynamic>> data =
          await searchService(buffer.toString().toLowerCase());

      return data.map<Books>((e) => Books.fromJson(e)).toList();
    } catch (e) {
      debugPrint("erro no search at ExtensionUnionMangas: $e");
      return [];
    }
  }
}
