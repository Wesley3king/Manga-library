import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/extensions/n_hen_com/extension_n_hen_com.dart';

void main() {
  ExtensionNHenCom extend = ExtensionNHenCom();
  
  test("deve retornar List<ModelHomePage>", () async {
    var data = await extend.homePage();
    debugPrint("img: ${data[0].books[0].img}");
  });

  test("deve retornar um model MangaInfoOffLineModel", () async {
    // wakamatsu-kioku-soushitsu-ni-natta-otoko-tomodachi-ni-kanojo-no-furi-shichau-onnanoko-no-hanashi-a-girl-pretending-to-be-the-girlfriend-of-her-friend-who-lost-his-memories-english hllalsg99-ball
    var data = await extend.mangaDetail("wakamatsu-kioku-soushitsu-ni-natta-otoko-tomodachi-ni-kanojo-no-furi-shichau-onnanoko-no-hanashi-a-girl-pretending-to-be-the-girlfriend-of-her-friend-who-lost-his-memories-english");
    debugPrint("name: ${data!.name}");
  });

  test("deve retornar um model SearchModel", () async {
    var data = await extend.search("kaede");
    debugPrint("name: ${data[0].img}");
  });
}
