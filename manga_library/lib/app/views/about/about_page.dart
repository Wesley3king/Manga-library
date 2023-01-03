import 'package:flutter/material.dart';
import 'package:manga_library/app/views/about/controller/about_page_controller.dart';
import 'package:manga_library/app/views/about/home/about_home.dart';
import 'package:manga_library/app/views/about/manual/backup/manual_backup.dart';
import 'package:manga_library/app/views/about/manual/downloads/manual_downloads.dart';
import 'package:manga_library/app/views/about/manual/extensions/manual_extensions.dart';
import 'package:manga_library/app/views/about/manual/library/manual_library.dart';
import 'package:manga_library/app/views/about/manual/manual.dart';
import 'package:manga_library/app/views/about/manual/ocult_library/manual_ocult_library.dart';
import 'package:manga_library/app/views/about/manual/updates/manual_updates.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final AboutPageController controller = AboutPageController();

  Widget stateManagement(AboutPageStates state) {
    switch (state) {
      case AboutPageStates.home:
        return AboutHomePage(controller: controller);
      case AboutPageStates.manual:
        return ManualPage(controller: controller);
      case AboutPageStates.library:
        return const ManualLibraryPage();
      case AboutPageStates.ocultLibrary:
        return const ManualOcultLibraryPage();
      case AboutPageStates.backup:
        return const ManualBackupPage();
      case AboutPageStates.updates:
        return const ManualUpdatesPage();
      case AboutPageStates.extensions:
        return const ManualExtensionsPage();
      case AboutPageStates.downloads:
        return const ManualDownloadsPage();
    }
  }

  /// POP
  Future<bool> exitPage() async {
    if (controller.state.value == AboutPageStates.home) {
      return true;
    } else if (controller.state.value == AboutPageStates.manual) {
      controller.state.value = AboutPageStates.home;
      return false;
    } else {
      controller.state.value = AboutPageStates.manual;
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sobre"),
      ),
      body: WillPopScope(
        onWillPop: exitPage,
        child: AnimatedBuilder(
          animation: controller.state,
          builder: (context, child) => stateManagement(controller.state.value),
        ),
      ),
    );
  }
}
