import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/controllers/home_page_controller.dart';

void main() {
  test('deve retornar uma lista de ModelHomePage', () async {
    var homeController = HomePageController();
    var data = await homeController.start();
    print(data[0].name);
  });
}
