import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/message_core.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutHomePage extends StatelessWidget {
  const AboutHomePage({super.key});

  Future<void> _launchUrl() async {
    const String url = "https://github.com/Wesley3king/Manga-library";
    if (!await launchUrl(Uri.parse(url))) {
      MessageCore.showMessage("Erro ao abrir o Navegador");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: 150,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: Image.asset('assets/imgs/new-icon-manga-mini.png')
            )
          ),
        ),
        const Divider(),
        const ListTile(
          leading: Icon(Icons.info),
          title: Text("Manual do Usuario"),
        ),
        const ListTile(
          leading: Icon(Icons.android),
          title: Text("Versão"),
          subtitle: Text("beta 1.0.0+1"),
        ),
        ListTile(
          leading: const Icon(Icons.update),
          title: const Text("Verificar por Atualizações"),
          // onTap: () => _launchUrl(),
        ),
        ListTile(
          leading: Image.asset('assets/imgs/git-hub-icon.png'),
          title: const Text("Git Hub"),
          onTap: () => _launchUrl(),
        ),
      ],
    );
  }
}