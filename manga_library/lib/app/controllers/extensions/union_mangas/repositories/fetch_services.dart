import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';

Future<dynamic> searchService(String txt) async {
  Dio dio = Dio(BaseOptions(connectTimeout: 40000));
  try {
    var data = await dio
        .get("https://unionleitor.top/assets/busca.php?nomeManga=$txt");
    // print(data);
    return json.decode(data.data);
  } catch (e) {
    debugPrint("erro no search at Union/fetchServices: $e");
    return null;
  }
}
