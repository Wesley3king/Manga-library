import 'package:flutter/material.dart';
import 'package:manga_library/app/views/configurations/library_config/libraries_config/library_config.dart';
import 'package:manga_library/app/views/configurations/library_config/ocult_library_config/ocult_library_config.dart';

class LibraryConfig extends StatelessWidget {
  final bool isOcultLibrary;
  const LibraryConfig({super.key, required this.isOcultLibrary});

  @override
  Widget build(BuildContext context) {
    return isOcultLibrary ? const LibraryOcultConfig(): const LibraryConfigMain();
  }
}