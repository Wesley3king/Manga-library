import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/extensions/gekkou_scans/extesion_gekkou_scans.dart';
import 'package:manga_library/app/extensions/model_extension.dart';

void main() {
  final Extension extend = ExtensionGekkouScans();
  test("deve retornar uma lista de home page model", () async {
    var data = await extend.homePage();
    debugPrint('$data');
  });
}
