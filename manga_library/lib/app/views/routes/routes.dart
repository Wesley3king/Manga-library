import 'package:go_router/go_router.dart';
import 'package:manga_library/app/views/components/configurations/backup_config/backup.dart';
import 'package:manga_library/app/views/components/configurations/config_options.dart';
import 'package:manga_library/app/views/components/configurations/config_pages/config_options_page.dart';
import 'package:manga_library/app/views/components/configurations/library_config/library_config.dart';
import 'package:manga_library/app/views/home/home_page.dart';
import 'package:manga_library/app/views/home/library.dart';
import 'package:manga_library/app/views/home/others.dart';
import 'package:manga_library/app/views/home/search.dart';
import 'package:manga_library/app/views/components/leitor/leitor.dart';
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
    path: '/others',
    builder: (context, state) => const OthersPage(),
  ),
  GoRoute(
    path: '/settings',
    builder: (context, state) => const ConfigurationsTypes(),
  ),
  GoRoute(
    path: '/settingoptions/:type',
    builder: (context, state) {
      String type = state.params['type'].toString();
      print(type);
      return ConfigOptionsPage(type: type);
    },
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
  ),
  GoRoute(
    path: '/configlibrary',
    builder: (context, state) => const LibraryConfig(),
  ),
  GoRoute(
    path: '/backupconfig',
    builder: (context, state) => const BackupConfig(),
  ),
]);
