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

  /// passe a imagem de indice 0 para funcionar :
  /// ex: [ /storage/emulated/0/Android/data/com.example.manga_library/files/Manga Libray/Downloads/Manga_Library/The Beginning After The End/cap_152/0.jpg ]
  Future<bool> deleteDownloads(String imagePath) async {
    try {
      // aqui cortamos o caminho da imagem para pegar seu path e deletar o directório
      List<String> paths = imagePath.split("/0.");
      debugPrint("path delete: ${paths[0]}");
      Directory dir = Directory(paths[0]);
      await dir.delete(recursive: true);
      return true;
    } catch (e) {
      debugPrint("erro no delete Directory: $e");
      return false;
    }
  }

  Future<bool> createGzFile({required Map<String, dynamic> backupData, required String path}) async {
    try {
      File file = File(path);
      if (file.existsSync()) {
        debugPrint("este arquivo existe!");
      } else {
        debugPrint("este arquivo não existe!");
        var resArchive = await file.create(recursive: false);
        // debugPrint("archive: $resArchive");

        var jsonData = json.encode(backupData);
        var bytes = utf8.encode(jsonData);
        var gzBytes = GZipCodec(dictionary: bytes);
        var decode = gzBytes.encoder;
        resArchive
            .writeAsBytes(decode.convert(bytes))
            .whenComplete(() => debugPrint("Backup created!"));
      }
      return true;
    } catch (e) {
      debugPrint("erro no createGZFile: $e");
      return false;
    }
  }

  void readGzArchive() async {
    try {
      File file = File("/storage/emulated/0/Manga Libray/manga/backup2.gz");
      var bin = await file.readAsBytes();
      // print(bin);
      var decode = GZipCodec(dictionary: bin);
      var bytes = decode.decoder;
      var data = utf8.decode(bytes.convert(bin));
      print(data);
    } catch (e) {
      debugPrint("erro no readGzArchive: $e");
    }
  }
}

// void deleteFile() async {
//   // is working = true
//   try {
//     File file = File("/storage/emulated/0/image.jpg");

//     var res = await file.delete(recursive: false);
//     debugPrint("$res");
//   } catch (e) {
//     print('erro no delete file: $e');
//   }
// }


