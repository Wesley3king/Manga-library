import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:manga_library/app/controllers/extensions/extension_manga_yabu.dart';
import 'package:manga_library/app/controllers/extensions/extensions.dart';
import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/models/globais.dart';
import 'package:manga_library/app/models/home_page_model.dart';

enum HomeStates { start, loading, sucess, error }

class HomePageController {
  static String errorMessage = '';
  final List<dynamic> extensoes = listOfExtensions;
  final HiveController hiveController = HiveController();
  List<ModelHomePage> data = [];

  final ValueNotifier<HomeStates> state = ValueNotifier(HomeStates.start);

  Future<void> start() async {
    try {
      state.value = HomeStates.loading;

      var dados = await hiveController.getHomePage();
      // caso seja nulo atualiza os dados
      dados ??= await _updateHomePage();

      if (dados == null) {
        state.value = HomeStates.error;
      } else {
        data = dados;
        state.value = HomeStates.sucess;
      }
    } catch (e) {
      debugPrint("erro no start at HomePageController: $e");
      state.value = HomeStates.error;
    }
  }

  Future<void> update() async {
    try {
      List<ModelHomePage>? dados = await _updateHomePage();
      data = dados!;
      state.value = HomeStates.loading;
      // aqui fazemos o refresh
      state.value = HomeStates.sucess;
    } catch (e) {
      debugPrint("erro ao atualizar o homePage: $e");
      state.value = HomeStates.error;
    }
  }

  Future<List<ModelHomePage>?> _updateHomePage() async {
    List<ModelHomePage> dados = [];
    try {
      debugPrint("iniciando a atualização do home page!");
      for (dynamic font in extensoes) {
        List<ModelHomePage> extensionData = await font.homePage();

        dados.addAll(extensionData);
      }
      await hiveController.updateHomePage(dados);
      return dados;
    } catch (e) {
      debugPrint("erro no updateHomePage at HomePageController: $e");
      return null;
    }
  }
}
