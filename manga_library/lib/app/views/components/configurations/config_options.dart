import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/controllers/system_config.dart';

import '../../../models/globais.dart';

class ConfigurationsTypes extends StatefulWidget {
  const ConfigurationsTypes({super.key});

  @override
  State<ConfigurationsTypes> createState() => _ConfigurationsTypesState();
}

class _ConfigurationsTypesState extends State<ConfigurationsTypes> {
  Color _colorManagement() {
    switch (GlobalData.settings['Cor da Interface']) {
      case "blue":
        return Colors.blue;
      case "green":
        return Colors.green;
      case "lime":
        return Colors.lime;
      case "purple":
        return Colors.purple;
      case "pink":
        return Colors.pink;
      case "orange":
        return Colors.orange;
      case "red":
        return Colors.red;
      case "black":
        return Colors.black;
      case "white":
        return Colors.white;
      case "grey":
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: AnimatedBuilder(
        animation: ConfigSystemController.instance,
        builder: (context, child) => IconTheme(
          data: IconThemeData(color: _colorManagement()),
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.local_library),
                title: const Text('Biblioteca'),
                onTap: () {
                  GoRouter.of(context).push('/settingoptions/library');
                },
              ),
              ListTile(
                leading: const Icon(Icons.chrome_reader_mode),
                title: const Text('Leitor'),
                onTap: () {
                  GoRouter.of(context).push('/settingoptions/leitor');
                },
              ),
              ListTile(
                leading: const Icon(Icons.lightbulb),
                title: const Text('Tema e Idioma'),
                onTap: () {
                  GoRouter.of(context).push('/settingoptions/theme');
                },
              ),
              ListTile(
                leading: const Icon(Icons.download),
                title: const Text('Downloads'),
                onTap: () {
                  GoRouter.of(context).push('/settingoptions/downloads');
                },
              ),
              ListTile(
                leading: const Icon(Icons.security),
                title: const Text('Segurança'),
                onTap: () {
                  GoRouter.of(context).push('/settingoptions/security');
                },
              ),
              ListTile(
                leading: const Icon(Icons.explore),
                title: const Text('Extensões e Pesquisa'),
                onTap: () {
                  GoRouter.of(context).push('/settingoptions/extension');
                },
              ),
              ListTile(
                leading: const Icon(Icons.report_problem),
                title: const Text('Avançado'),
                onTap: () {
                  GoRouter.of(context).push('/settingoptions/advanced');
                },
              ),
            ],
          ),
        ),
      )
    );
  }
}
