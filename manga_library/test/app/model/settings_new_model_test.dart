import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:manga_library/app/models/settings_model.dart';

void main() {
  test("deve retornar o model", () {
    List<Map<String, dynamic>> jsons = [
      {
        "type": "library",
        "nameOptions": "Biblioteca",
        "settings": [
          {
            "type": "container",
            "children": [
              {
                "nameConfig": "Ordenação",
                "description": "A ordem em que os mangas serão exibidos",
                "inputType": "radio",
                "value": "oldtonew",
                "function": (){ debugPrint("king of shadows");},
                "optionsAndValues": [
                  {"option": "Velhos até Novos", "value": "oldtonew"},
                  {"option": "Novos até Velhos", "value": "newtoold"},
                  {"option": "Alfabética", "value": "alfabetic"}
                ]
              },
              const Text("king")
            ]
          },
          {
            "type": "dependence",
            "children": [
              {
                "nameConfig": "Ordenação",
                "description": "A ordem em que os mangas serão exibidos",
                "inputType": "radio",
                "value": "oldtonew",
                "function": (){ debugPrint("king of shadows");},
                "optionsAndValues": [
                  {"option": "Velhos até Novos", "value": "oldtonew"},
                  {"option": "Novos até Velhos", "value": "newtoold"},
                  {"option": "Alfabética", "value": "alfabetic"}
                ]
              },
              {
                "type": "container",
                "children": [

                  {
                    "nameConfig": "Ordenação",
                    "description": "A ordem em que os mangas serão exibidos",
                    "inputType": "radio",
                    "value": "oldtonew",
                    "function": (){ debugPrint("king of shadows");},
                    "optionsAndValues": [
                      {"option": "Velhos até Novos", "value": "oldtonew"},
                      {"option": "Novos até Velhos", "value": "newtoold"},
                      {"option": "Alfabética", "value": "alfabetic"}
                    ]
                  },
                  const Text("king")
                ]
              },
            ]
          },
          {
            "type": "class",
            "nameClass": "tema",
            "children": []
          },
        ]
      }
    ];

    var data = SettingsModel.fromJson(jsons);
    debugPrint("data: $data");
  });
}
