import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/controllers/updates/updates_controller.dart';
import 'package:dart_date/dart_date.dart';

void main() {
  test("deve retornar um true caso tenha se passado mais de 6h", () {
    UpdatesCore.verifyIfIsTimeToUpdate();
  });

  test("get date", () {
    DateTime nowTime = DateTime.now();
    DateTime oldTime = DateTime.parse("2022-12-20 12:56:43");
    debugPrint('${(nowTime - const Duration(days: 7)) >= oldTime}');
    // 6 : (nowTime - const Duration(hours: 6)) >= oldTime
    // 12 : (nowTime - const Duration(hours: 12)) >= oldTime
    // 24 : (nowTime - const Duration(days: 1)) >= oldTime
    // 168(one week) : (nowTime - const Duration(days: 7)) >= oldTime
  });
}
