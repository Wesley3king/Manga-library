import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/extensions/extension_manga_yabu.dart';
import 'package:manga_library/app/models/home_page_model.dart';

enum HomeStates { start, loading, sucess, error }

class HomePageController {
  final mangaYabu = ExtensionMangaYabu();
  List<ModelHomePage> data = [];
  
  final ValueNotifier<HomeStates> state = ValueNotifier(HomeStates.start);

  Future<List<ModelHomePage>> start() async {
    state.value = HomeStates.loading;
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
