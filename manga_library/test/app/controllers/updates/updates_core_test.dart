import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/controllers/updates/updates_controller.dart';

void main() {
  test("deve retornar um true caso tenha se passado mais de 6h", () {
    UpdatesCore.verifyIfIsTimeToUpdate();
  });

  test("get date", () {
    debugPrint('${DateTime.now()}');
  });
}
