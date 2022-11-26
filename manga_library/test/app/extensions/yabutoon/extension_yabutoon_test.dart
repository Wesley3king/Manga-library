import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/extensions/model_extension.dart';
import 'package:manga_library/app/extensions/yabutoon/extension_yabutoon.dart';

void main() {
  final Extension extend = ExtensionYabutoon();

  test("deve retornar uma lista de ", () async {
    var data = await extend.homePage();
    debugPrint("data: $data");
  });
}
