import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/extensions/extension_manga_yabu.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/models/home_page_model.dart';

enum HomeStates { start, loading, sucess, error }

class HomePageController {
  static String errorMessage = '';
  final mangaYabu = ExtensionMangaYabu();
  final HiveController _hiveController = HiveController();
  List<ModelHomePage> data = [];

  final ValueNotifier<HomeStates> state = ValueNotifier(HomeStates.start);

  Future<List<ModelHomePage>> start() async {
    state.value = HomeStates.loading;
    //_hiveController.writeClientData();
    List? dados = await mangaYabu.homePage();

    if (dados != null) {
      dados.forEach((element) {
        data.add(ModelHomePage.fromJson(element));
      });
      state.value = HomeStates.sucess;
    } else {
      state.value = HomeStates.error;
    }
    return data;
  }
}
