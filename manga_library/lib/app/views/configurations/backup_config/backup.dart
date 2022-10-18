import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/backup/backup_controller.dart';

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
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response)));
              },
            )
          ],
        ),
      ),
    );
  }
}
