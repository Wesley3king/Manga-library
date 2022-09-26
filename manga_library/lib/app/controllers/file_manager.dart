import 'dart:convert';
import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
// -------------------------------------------------------------------------
//               ====== File Management ======
// -------------------------------------------------------------------------

/// class that allows manipulating system directories or files
class FileManager {
  Directory dir = Directory("/storage/emulated/0/Manga Library");

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

  Future<bool> createGzFile(
      {required Map<String, dynamic> backupData, required String path}) async {
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

  Future<dynamic> readGZFile(String path) async {
    // final String erro = "";
    try {
      File file = File(path);
      //erro += ""
      var bin = await file.readAsBytes();
      var decode = GZipCodec(dictionary: bin);
      var bytes = decode.decoder;
      var stringUtf8 = utf8.decode(bytes.convert(bin));
      var data = json.decode(stringUtf8);
      print(data);
      return data;
    } catch (e) {
      debugPrint("erro no readGzArchive: $e");
      return "$e";
    }
  }

  // abre o buscador de arquivos do sistema para retirar um .gz
  Future<dynamic> getAnGZFile() async {
    //String status = "";
    try {
      final data = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.custom,
          allowedExtensions: ['gz']);
      if (data == null) {
        //status += "sem selecionar";
        debugPrint("não selecionou um arquivo!");
        return false;
      } else {
        // modifique o caminho  com.example.manga_library com.king.manga_library
        final path = data.files.single.path!
            .replaceFirst("Android/data/com.example.manga_library/files/", "");
        log("arquive - path: $path");
        //status += "p= $path";
        //File file = File(path);
        return await readGZFile(path);
      }
    } catch (e) {
      debugPrint("falha at readArchive System: $e");
      return null; //  "$status - $e"
    }
  }

  Future<String?> getDirectory() async {
    try {
      final data = await FilePicker.platform.getDirectoryPath();
      if (data == null) {
        log("não foi selecionado uma file!");
        return null;
      } else {
        log("path: $data");
        return data;
      }
    } catch (e) {
      debugPrint("erro no getDirectory: $e");
      return null;
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


