import 'package:flutter/material.dart';

class ConfigOptionsPage extends StatefulWidget {
  final String type;
  const ConfigOptionsPage({super.key, required this.type});

  @override
  State<ConfigOptionsPage> createState() => _ConfigOptionsPageState();
}

class _ConfigOptionsPageState extends State<ConfigOptionsPage> {
  bool valor = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tema e Idioma'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Rolar a Barra junto a Rolagem'),
            value: valor,
            onChanged: (value) => setState(() {
              valor = value;
            }),
          ),
        ],
      ),
    );
  }
}
