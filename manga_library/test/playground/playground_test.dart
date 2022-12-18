import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("teste de recepção", () async {
    final Dio dio = Dio(
      BaseOptions(headers: {
        "cookie": "cf_clearance=jxmiPRndhqutmEWrJo7GM2nekBeoSXhzEsBxjJ5GmI8-1671372030-0-150; csrftoken=8ZSjJ09FBBty9v9ri2Yd8qIJp0768T2vik6wskxfAqD0fytKAhssVaMCGJmrqzij",
        "sec-ch-ua": '"Google Chrome";v="105", "Not)A;Brand";v="8", "Chromium";v="105"',
        "sec-ch-ua-mobile": "?0",
        "sec-ch-ua-platform": '"Linux"',
        "sec-fetch-dest": "document",
        "sec-fetch-mode": "navigate",
        "sec-fetch-site": "none",
        "sec-fetch-user": "?1",
        "upgrade-insecure-requests": "1",
        "user-agent":"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36"
      }, )
    );
    var data = await dio.get("https://nhentai.net/g/432301/");
    debugPrint("data: ${data.data}");
  });
}
