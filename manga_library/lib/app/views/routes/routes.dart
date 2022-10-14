import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/models/globais.dart';
import 'package:manga_library/app/services/auth_service.dart';
import 'package:manga_library/app/views/auth/password_screen.dart';
import 'package:manga_library/app/views/components/configurations/backup_config/backup.dart';
import 'package:manga_library/app/views/components/configurations/config_options.dart';
import 'package:manga_library/app/views/components/configurations/config_pages/config_options_page.dart';
import 'package:manga_library/app/views/components/configurations/library_config/library_config_main.dart';
import 'package:manga_library/app/views/components/library/ocult%20library/ocult_library.dart';
import 'package:manga_library/app/views/home.dart';
import 'package:manga_library/app/views/components/leitor/leitor.dart';
import 'package:manga_library/app/views/manga_info.dart';

final AuthService authService = AuthService();

final routes = GoRouter(
    initialLocation: '/auth',
    refreshListenable: authService,
    redirect: (state) {
      final isAuth = authService.isAuthenticated;
      final isLoginRoute = state.subloc == '/auth';

      if (isLoginRoute) {
        if (!GlobalData.settings['Autenticação']) return '/home';
        // caso precise de autenticação
        if (!isAuth) {
          return isLoginRoute ? null : '/home';
        }

        if (isLoginRoute) return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/auth',
        builder: (context, state) => PasswordScreen(
          authService: authService,
        ),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const Home(),
      ),
      GoRoute(
        path: '/ocultlibrary',
        builder: (context, state) => const LibraryOcult(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const ConfigurationsTypes(),
      ),
      GoRoute(
        path: '/settingoptions/:type',
        builder: (context, state) {
          String type = state.params['type'].toString();
          // print(type);
          return ConfigOptionsPage(type: type);
        },
      ),
      GoRoute(
        path: '/detail/:link/:extension',
        builder: (context, state) {
          int idExtension = int.parse(state.params['extension'].toString());
          String url = state.params['link'].toString();
          return MangaInfo(
            link: url,
            idExtension: idExtension,
          );
        },
      ),
      GoRoute(
        path: '/leitor/:link/:id/:extension',
        builder: (context, state) {
          String url = state.params['link'].toString();
          String id = state.params['id'].toString();
          int idExtension = int.parse(state.params['extension'].toString());
          return Leitor(
            link: url,
            id: id,
            idExtension: idExtension,
          );
        },
      ),
      GoRoute(
        path: '/configlibrary/:ocultlibrary',
        builder: (context, state) {
          bool isOcultLibrary =
              state.params['ocultlibrary']! == "true" ? true : false;
          debugPrint("isOcultLibrary: $isOcultLibrary");
          return LibraryConfig(
            isOcultLibrary: isOcultLibrary,
          );
        },
      ),
      GoRoute(
        path: '/backupconfig',
        builder: (context, state) => const BackupConfig(),
      ),
    ]);
