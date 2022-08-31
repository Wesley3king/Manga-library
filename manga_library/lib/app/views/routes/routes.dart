import 'package:go_router/go_router.dart';
import 'package:manga_library/app/views/home/home_page.dart';
import 'package:manga_library/app/views/home/library.dart';
import 'package:manga_library/app/views/home/my_settings.dart';
import 'package:manga_library/app/views/home/search.dart';
import 'package:manga_library/app/views/leitor.dart';
import 'package:manga_library/app/views/manga_info.dart';

final routes = GoRouter(initialLocation: '/home', routes: [
  GoRoute(
    path: '/home',
    builder: (context, state) => const HomePage(),
  ),
  GoRoute(
    path: '/library',
    builder: (context, state) => const LibraryPage(),
  ),
  GoRoute(
    path: '/search',
    builder: (context, state) => const SearchPage(),
  ),
  GoRoute(
    path: '/settings',
    builder: (context, state) => const MySettingsPage(),
  ),
  GoRoute(
    path: '/info/:link',
    builder: (context, state) {
      String url = state.params['link'].toString();
      print(url);
      return MangaInfo(link: url);
    },
  ),
  GoRoute(
    path: '/leitor/:link/:id',
    builder: (context, state) {
      String url = state.params['link'].toString();
      String id = state.params['id'].toString();

      return Leitor(link: url,id: id,);
    },
  )
]);
