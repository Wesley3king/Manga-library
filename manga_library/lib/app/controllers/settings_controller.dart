import 'package:manga_library/app/controllers/hive/hive_controller.dart';
import 'package:manga_library/app/models/globais.dart';
import 'package:manga_library/app/models/seetings_model.dart';

class SettingsController {
  final HiveController hiveController = HiveController();
  SettingsModel settings = SettingsModel(data: []);

  Future start() async {
    Map<String, dynamic> data = await hiveController.getSettings();
    GlobalData.settings = data;
    GlobalData.settingsApp = buildSettingsModel(data);
  }

  buildSettingsModel(Map<String, dynamic> data) {
    return SettingsModel.fromJson({
      "data": [
        {
          "type": "library",
          "nameOptions": "Biblioteca",
          "settings": [
            {
              "nameConfig": "Ordenação",
              "description": "A ordem em que os mangas serão exibidos",
              "inputType": "radio",
              "value": data['Ordenação'],
              "optionsAndValues": [
                {"option": "Velhos até Novos", "value": "oldtonew"},
                {"option": "Novos até Velhos", "value": "newtoold"},
                {"option": "Alfabética", "value": "alfabetic"}
              ]
            },
            {
              "nameConfig": "Tamanho dos quadros",
              "description": "Configura o tamanho das capas",
              "inputType": "radio",
              "value": data['Tamanho dos quadros'],
              "optionsAndValues": [
                {"option": "Pequenos", "value": "small"},
                {"option": "Normal", "value": "normal"},
                {"option": "Grandes", "value": "big"}
              ]
            },
            {
              "nameConfig": "Atualizar as Capas",
              "description": "Atualiza as capas da Biblioteca",
              "inputType": "confirm",
              "value": ['Atualizar as Capa'],
              "optionsAndValues": [
                {"option": "Cancelar", "value": false},
                {"option": "Confirmar", "value": true}
              ]
            }
          ]
        },
        {
          "type": "leitor",
          "nameOptions": "Leitor",
          "settings": [
            {
              "nameConfig": "Tipo do Leitor",
              "description": "O modo como as paginas disponibilizadas",
              "inputType": "radio",
              "value": data['Tipo do Leitor'],
              "optionsAndValues": [
                {"option": "Vertical", "value": "vertical"},
                {"option": "Esquerda para Direita", "value": "ltr"},
                {"option": "Direita para esquerda", "value": "rtl"}
              ]
            },
            {
              "nameConfig": "Cor de fundo",
              "description": "A cor para o fundo do Leitor",
              "inputType": "radio",
              "value": data['Cor de fundo'],
              "optionsAndValues": [
                {"option": "Automatico", "value": "auto"},
                {"option": "Dark", "value": "dark"},
                {"option": "Preto", "value": "black"},
                {"option": "Branco", "value": "white"}
              ]
            },
            {
              "nameConfig": "Tela cheia",
              "description": "Se o Leitor será exibido em tela cheia",
              "inputType": "switch",
              "value": data['Tela cheia'],
              "optionsAndValues": [
                {"option": "switch", "value": true}
              ]
            }
          ]
        },
        {
          "type": "theme",
          "nameOptions": "Thema e Idioma",
          "settings": [
            {
              "nameConfig": "Tema",
              "description": "Define o tema do aplicativo",
              "inputType": "radio",
              "value": data['Tema'],
              "optionsAndValues": [
                {"option": "Automatico", "value": "auto"},
                {"option": "Light", "value": "light"},
                {"option": "Dark", "value": "dark"}
              ]
            },
            {
              "nameConfig": "Cor da Interface",
              "description": "Define a cor dos icones e cabechalhos",
              "inputType": "radio",
              "value": data['Cor da Interface'],
              "optionsAndValues": [
                {"option": "Azul", "value": "blue"},
                {"option": "Verde", "value": "green"},
                {"option": "Lime", "value": "lime"},
                {"option": "Roxo", "value": "purple"},
                {"option": "Rosa", "value": "pink"},
                {"option": "Laranja", "value": "orange"},
                {"option": "Vermelho", "value": "red"},
                {"option": "Preto", "value": "black"},
                {"option": "Branco", "value": "white"},
                {"option": "Cinza", "value": "grey"}
              ]
            },
            {
              "nameConfig": "Idioma",
              "description": "Define o linguagem do aplicativo",
              "inputType": "radio",
              "value": data['Idioma'],
              "optionsAndValues": [
                {"option": "Português(Br)", "value": "ptbr"}
              ]
            },
            {
              "nameConfig": "Rolar a Barra",
              "description": "retira a barra ao rolar para baixo",
              "inputType": "switch",
              "value": data['Rolar a Barra'],
              "optionsAndValues": [
                {"option": "switch", "value": true}
              ]
            }
          ]
        },
        {
          "type": "downloads",
          "nameOptions": "Downloads",
          "settings": [
            {
              "nameConfig": "Local de armazenamento",
              "description": "Define o local que fivaram os downloads",
              "inputType": "radio",
              "value": data['Local de armazenamento'],
              "optionsAndValues": [
                {"option": "Interno", "value": "intern"},
                {"option": "Externo", "value": "extern"},
                {"option": "Externo oculto", "value": "externocult"}
              ]
            }
          ]
        },
        {
          "type": "security",
          "nameOptions": "Segurança",
          "settings": [
            {
              "nameConfig": "Autenticação",
              "description": "Define se havera autenticação ao entrar",
              "inputType": "switch",
              "value": data['Autenticação'],
              "optionsAndValues": [
                {"option": "switch", "value": false}
              ]
            },
            {
              "nameConfig": "Tipo de Autenticação",
              "description": "Define o tipo autenticação",
              "inputType": "radio",
              "value": data['Tipo de Autenticação'],
              "optionsAndValues": [
                {"option": "Caracteres", "value": "text"},
                {"option": "Numeros", "value": "number"}
              ]
            },
            {
              "nameConfig": "Senha de Autenticação",
              "description": "Define se havera autenticação ao entrar",
              "inputType": "input",
              "value": data['Senha de Autenticação'],
              "optionsAndValues": [
                {"option": "Caracteres", "value": ""},
                {"option": "Numeros", "value": ""}
              ]
            }
          ]
        },
        {
          "type": "extension",
          "nameOptions": "Exetensões e e Pesquisa",
          "settings": [
            {
              "nameConfig": "Multiplas Pesquisas",
              "description":
                  "Define se pode fazer mais de uma pesquisa por vez",
              "inputType": "switch",
              "value": data['Multiplas Pesquisas'],
              "optionsAndValues": [
                {"option": "switch", "value": false}
              ]
            },
            {
              "nameConfig": "Conteudo NSFW",
              "description": "Define se havera extesões +18",
              "inputType": "switch",
              "value": data['Conteudo NSFW'],
              "optionsAndValues": [
                {"option": "switch", "value": false}
              ]
            },
            {
              "nameConfig": "Mostrar na Lista",
              "description": "Exibe estas extensões na Lista de Extensões",
              "inputType": "switch",
              "value": data['Mostrar na Lista'],
              "optionsAndValues": [
                {"option": "switch", "value": true}
              ]
            }
          ]
        },
        {
          "type": "advanced",
          "nameOptions": "Avançado",
          "settings": [
            {
              "nameConfig": "Limpar o Cache",
              "description": "Remove dados substituiveis",
              "inputType": "confirm",
              "value": data['Limpar o Cache'],
              "optionsAndValues": [
                {"option": "Cancelar", "value": false},
                {"option": "Confirmar", "value": true}
              ]
            },
            {
              "nameConfig": "Restaurar",
              "description": "Remove todos os dados do aplicativo",
              "inputType": "confirm",
              "value": data['Restaurar'],
              "optionsAndValues": [
                {"option": "Cancelar", "value": false},
                {"option": "Confirmar", "value": true}
              ]
            }
          ]
        }
      ]
    });
  }
}
