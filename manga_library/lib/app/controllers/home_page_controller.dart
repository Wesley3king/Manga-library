import 'package:flutter/material.dart';
// import 'package:manga_library/app/controllers/extensions/extension_manga_yabu.dart';
import 'package:manga_library/app/controllers/extensions/extensions.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/models/home_page_model.dart';

enum HomeStates { start, loading, sucess, error }

class HomePageController {
  static String errorMessage = '';
  final List<dynamic> extensoes = listOfExtensions;
  final HiveController _hiveController = HiveController();
  List<ModelHomePage> data = [];

  final ValueNotifier<HomeStates> state = ValueNotifier(HomeStates.start);

  Future<void> start() async { // List<ModelHomePage>
    try {
      state.value = HomeStates.loading;
      //_hiveController.writeClientData();
      // List? dados = await mangaYabu.homePage();
      for (dynamic font in extensoes) {
        List<ModelHomePage> dados = await font.homePage();
        
        data.addAll(dados);
      }

      state.value = HomeStates.sucess;
    } catch (e) {
      debugPrint("erro no start at HomePageController: $e");
      state.value = HomeStates.error;
    }
  }
}
// if (dados.isNotEmpty) {
//   dados.forEach((element) {
//     data.add(ModelHomePage.fromJson(element));
//   });

//   for (ModelHomePage model in dados) {

//   }
//   data.addAll(dados);
// } else {
//   state.value = HomeStates.error;
// }