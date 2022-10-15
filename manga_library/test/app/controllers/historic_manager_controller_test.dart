import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/controllers/historic_manager_controller.dart';

void main() {
  ManagerHistoricController controller = ManagerHistoricController();
  test("deve retornar a data e hora", () {
    var data = controller.getDateTime();
    debugPrint(data);
  });
}
