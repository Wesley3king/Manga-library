import 'package:manga_library/app/controllers/extensions/extension_manga_yabu.dart';
import 'package:manga_library/app/models/home_page_model.dart';

enum HomeStates { start, loading, sucess, error }

class HomePageController {
  HomeStates state = HomeStates.start;
  final manga_yabu = ExtensionMangaYabu();
  List<ModelHomePage> data = [];

  Future<List<ModelHomePage>> start() async {
    state = HomeStates.loading;
    List? dados = await manga_yabu.homePage();

    if (dados != null) {
      dados.forEach((element) {
        data.add(ModelHomePage.fromJson(element));
      });
      state = HomeStates.sucess;
      
    } else {
      state = HomeStates.error;
    }
    return data;
  }
}
