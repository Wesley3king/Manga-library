import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConfigurationsTypes extends StatelessWidget {
  const ConfigurationsTypes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.local_library),
            title: const Text('Biblioteca'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.chrome_reader_mode),
            title: const Text('Leitor'),
            onTap: () {},
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
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Segurança'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.explore),
            title: const Text('Extensões e Pesquisa'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.report_problem),
            title: const Text('Avançado'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
