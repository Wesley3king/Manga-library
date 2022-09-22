import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
// -------------------------------------------------------------------------
//               ====== File Management ======
// -------------------------------------------------------------------------

/// class that allows manipulating system directories or files
class FileManager {
  Directory dir = Directory("/storage/emulated/0/Manga Libray");

  Future<void> verifyIfIsFirstTime() async {
    if (!dir.existsSync()) {
      startForFirstTime();
    }
  }

  void startForFirstTime() async {
    try {
      //Directory dir = Directory("/storage/emulated/0/Manga Libray");
      var res = await dir.create(recursive: false);
      // cria os subdiretórios
      Directory backup = Directory("${res.path}/Backups");
      Directory downloads = Directory("${res.path}/Downloads");
      await backup.create(recursive: false);
      await downloads.create(recursive: false);
    } catch (e) {
      debugPrint("erro no startForFirstTime at FileManager: $e");
    }
  }
}

void deleteFile() async {
  // is working = true
  try {
    File file = File("/storage/emulated/0/image.jpg");

    var res = await file.delete(recursive: false);
    debugPrint("$res");
  } catch (e) {
    print('erro no delete file: $e');
  }
}

void deleteDirectory() async {
  try {
    Directory dir = Directory("/storage/emulated/0/Manga Libray");
    dir.delete(recursive: false).whenComplete(() => print("deletado!"));
  } catch (e) {
    debugPrint("erro no delete Directory: $e");
  }
}

void createFileBackup() async {
  try {
    File file = File("/storage/emulated/0/Manga Libray/backup5_bynary.bin");
    if (file.existsSync()) {
      debugPrint("este arquivo existe!");
    } else {
      Map<String, dynamic> data = {
        "tipo": "vertical",
        "exists": true,
        "num": [1, 3, 6]
      };
      debugPrint("este arquivo não existe!");
      var resArchive = await file.create(recursive: false);
      debugPrint("archive: $resArchive");

      var jsonData = json.encode(data);
      var bynary = utf8.encode(jsonData);
      resArchive
          .writeAsBytes(bynary)
          .whenComplete(() => debugPrint("file escrita!"));
    }
  } catch (e) {
    debugPrint("erro no createFile: $e");
  }
}

void readArchive() async {
  try {
    File file = File("/storage/emulated/0/Manga Libray/backup5_bynary.bin");
    var bin = await file.readAsBytes();
    print(bin);
    var data = utf8.decode(bin);
    print(data);
  } catch (e) {
    debugPrint("erro no readArchive: $e");
  }
}
