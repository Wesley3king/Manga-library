
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/views/bottom_navigation_bar.dart';

class OthersPage extends StatefulWidget {
  const OthersPage({super.key});

  @override
  State<OthersPage> createState() => _OthersPageState();
}

class _OthersPageState extends State<OthersPage> {
  ScrollController controller = ScrollController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Outros'),
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: Image.asset('assests/imgs/grid-image-ready.png', fit: BoxFit.cover,),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                color: Colors.black54,
              ),
              Center(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset('assests/imgs/new-icon-manga-mini.png', fit: BoxFit.contain,),
                ),
              )
            ],
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Fila de Downloads'),
            onTap: (){},
          ),
          ListTile(
            leading: const Icon(Icons.download_done),
            title: const Text('Downloads'),
            onTap: (){},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Historico'),
            onTap: (){},
          ),
          ListTile(
            leading: const Icon(Icons.bookmark),
            title: const Text('Biblioteca'),
            onTap: (){},
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Conta e Sincronização'),
            onTap: (){},
          ),
          ListTile(
            leading: const Icon(Icons.download_done),
            title: const Text('Backup e restauração local'),
            onTap: (){},
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            onTap: () => GoRouter.of(context).push('/settings'),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Sobre e Manual de Istruções'),
            onTap: (){},
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(controller: controller,),
    );

  }
}
