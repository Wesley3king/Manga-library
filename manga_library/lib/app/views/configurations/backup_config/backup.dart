import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/backup/backup_controller.dart';
import 'package:manga_library/app/controllers/system_config.dart';

import '../../../controllers/message_core.dart';

class BackupConfig extends StatefulWidget {
  const BackupConfig({super.key});

  @override
  State<BackupConfig> createState() => _BackupConfigState();
}

class _BackupConfigState extends State<BackupConfig> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Backup e Restauração"),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: ListView(
          children: [
            ListTile(
              title: const Text("Criar Backup"),
              subtitle: const Text(
                  "Cria um Backup na pasta de backups em Manga Library/Backups"),
              onTap: () => BackupCore.createBackup(),
            ),
            ListTile(
              title: const Text("Restaurar Dados"),
              subtitle: const Text("restaura os dados a partir de um backup"),
              onTap: () async {
                String response = await BackupCore.readBackup();
                MessageCore.showSnackBar(context, response);
              },
            ),
            Divider(
              height: 1,
              color: ConfigSystemController().colorManagement(),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.report_problem),
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width - 60,
                          child: const Text(
                              "Atenção: depois de restaurar um backup é necessário fechar e abrir o app novamente."))
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
