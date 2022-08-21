import 'package:go_router/go_router.dart';
import 'package:manga_library/app/views/home_page.dart';
import 'package:manga_library/app/views/manga_info.dart';

final routes = GoRouter(initialLocation: '/home', routes: [
  GoRoute(
    path: '/home',
    builder: (context, state) => const HomePage(),
  ),
  GoRoute(
    path: '/info/:link',
    builder: (context, state) {
      String url = state.params['link'].toString();
      print(url);
      return MangaInfo(link: url);
    },
  ),
]);
