import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/extensions/gekkou_scans/extesion_gekkou_scans.dart';
import 'package:manga_library/app/extensions/model_extension.dart';
import 'package:manga_library/app/models/manga_info_offline_model.dart';

void main() {
  final Extension extend = ExtensionGekkouScans();
  test("deve retornar uma lista de ModelHomePage", () async {
    var data = await extend.homePage();
    debugPrint('$data');
  });

  test("deve retornar um ", () async {
    var data = await extend.mangaDetail('eleceed');
    debugPrint("data: $data");
  });

  test("deve retornar um model Capitulos com as paginas", () async {
    var data = await extend.getPages("eleceed--1--1", [
      Capitulos(
          id: "eleceed--1--1",
          capitulo: "cap 1",
          description: '',
          download: false,
          readed: false,
          mark: false,
          downloadPages: [],
          pages: [])
    ]);
    debugPrint("data: $data");
  });

  test("deve retornar um SearchModel", () async {
    var data = await extend.search("wind bre");
    debugPrint("data: $data");
  });
}
