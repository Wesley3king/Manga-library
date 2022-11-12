// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:manga_library/app/models/settings_model.dart';
import 'package:manga_library/app/models/system_settings.dart';
import 'package:manga_library/app/views/configurations/config_pages/functions/config_functions.dart';

buildSettingsModel() {
  SystemSettingsModel data = settings;
  Map<String, Function> functions = settingsFunctions;
  debugPrint("iniciando a construção do model SettingsModel");
  return SettingsModel.fromJson([
    {
      "type": "library",
      "nameOptions": "Biblioteca",
      "settings": [
        {
          "nameConfig": "Ordenação",
          "description": "A ordem em que os mangas serão exibidos",
          "type": "radio",
          "value": data.ordination,
          "function": functions['Ordenação'],
          "optionsAndValues": [
            {"option": "Velhos até Novos", "value": "oldtonew"},
            {"option": "Novos até Velhos", "value": "newtoold"},
            {"option": "Alfabética", "value": "alfabetic"}
          ]
        },
        {
          "nameConfig": "Tamanho dos quadros",
          "description": "Configura o tamanho das capas",
          "type": "radio",
          "value": data.frameSize,
          "function": functions['Tamanho dos quadros'],
          "optionsAndValues": [
            {"option": "Pequenos", "value": "small"},
            {"option": "Normal", "value": "normal"},
            {"option": "Grandes", "value": "big"}
          ]
        },
        {
          "type": "class",
          "nameClass": "Atualização",
          "children": [
            {
              "nameConfig": "Atualizar",
              "description": "Atualiza a Biblioteca automaticamente ao abrir o app",
              "type": "radio",
              "value": data.update,
              "function": functions['Atualizar'],
              "optionsAndValues": [
                {"option": "Nunca", "value": "0"},
                {"option": "A cada 6 Horas", "value": "6"},
                {"option": "A cada 12 Horas", "value": "12"},
                {"option": "Uma vez no Dia", "value": "24"},
                {"option": "Uma vez na Semana", "value": "1"}
              ]
            },
            {
              "nameConfig": "Atualizar as Capas",
              "description": "Caso não queira que as capas sejam atualizadas desligue.",
              "type": "switch",
              "value": data.updateTheCovers,
              "function": functions['Atualizar as Capas'],
              "optionsAndValues": []
            },
          ]
        },
        {
          "type": "class",
          "nameClass": "Biblioteca Oculta",
          "children": [
            {
              "nameConfig": "Senha da Biblioteca Oculta",
              "description": "Define a senha da Biblioteca Oculta",
              "type": "input",
              "value": data.hiddenLibraryPassword,
              "function": functions['Senha da Biblioteca Oculta'],
              "optionsAndValues": []
            },
          ]
        },
        {
          "type": "container",
          "children": [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: const <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.info),
                  ),
                  Flexible(child: Text("Caso nunca tenha configurado uma senha, por padrão ela é '0000'", softWrap: true,))
                ],
              ),
            )
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
          "type": "radio",
          "value": data.readerType,
          "function": functions['Tipo do Leitor'],
          "optionsAndValues": [
            {"option": "Vertical", "value": "vertical"},
            {"option": "Esquerda para Direita", "value": "ltr"},
            {"option": "Direita para esquerda", "value": "rtl"},
            {"option": "Lista ltr", "value": "ltrlist"},
            {"option": "Lista rtl", "value": "rtllist"},
            {"option": "Webtoon", "value": "webtoon"}
          ]
        },
        {
          "nameConfig": "Cor de fundo",
          "description": "A cor para o fundo do Leitor",
          "type": "radio",
          "value": data.backgroundColor,
          "function": functions['Cor de fundo'],
          "optionsAndValues": [
            {"option": "Preto", "value": "black"},
            {"option": "Branco", "value": "white"}
          ]
        },
        {
          "nameConfig": "Orientação do Leitor",
          "description": "O modo padrão da orientação do aparelho",
          "type": "radio",
          "value": data.readerGuidance,
          "function": functions['Orientação do Leitor'],
          "optionsAndValues": [
            {"option": "Seguir o Sistema", "value": "auto"},
            {"option": "Retrato", "value": "portraitup"},
            {"option": "Retrato Invertido", "value": "portraitdown"},
            {"option": "Paisagem Esquerda", "value": "landscapeleft"},
            {"option": "Paisagem Direita", "value": "landscaperight"},
          ]
        },
        {
          "nameConfig": "Qualidade",
          "description": "A qualidade das imagens (pode afetar o desempenho)",
          "type": "radio",
          "value": data.quality,
          "function": functions['Qualidade'],
          "optionsAndValues": [
            {"option": "Baixo", "value": "low"},
            {"option": "Médio", "value": "medium"},
            {"option": "Alto", "value": "hight"},
            {"option": "Nenhum", "value": "none"},
          ]
        },
        {
          "nameConfig": "Tela cheia",
          "description": "Se o Leitor será exibido em tela cheia",
          "type": "switch",
          "value": data.fullScreen,
          "function": functions['Tela cheia'],
          "optionsAndValues": [
            {"option": "switch", "value": true}
          ]
        },
        {
          "nameConfig": "Manter a tela ligada",
          "description": "Se o Leitor manterá a tela ligada durante todo o tempo",
          "type": "switch",
          "value": data.keepScreenOn,
          "function": functions['Manter a tela ligada'],
          "optionsAndValues": []
        },
        {
          "nameConfig": "Exibir os Controles ao Entrar no Leitor",
          "description": "mostra os controles no inicio",
          "type": "switch",
          "value": data.showControls,
          "function": functions['ShowControls'],
          "optionsAndValues": []
        },
        {
          "type": "class",
          "nameClass": "Brilho e Filtros",
          "children": [
            {
              "nameConfig": "Brilho personalizado",
              "description": "Define se o brilho da tela será personalizado",
              "type": "switch",
              "value": data.customShine,
              "function": functions['Custom Shine'],
              "optionsAndValues": []
            },
            {
              "nameConfig": "Filtro presonalizado",
              "description": "Define um filtro de cores personalizado",
              "type": "switch",
              "value": data.customFilter,
              "function": functions['Custom Filter'],
              "optionsAndValues": []
            },
            {
              "nameConfig": "Filtro Branco e Preto",
              "description": "Define um filtro que deixa tudo em preto e branco",
              "type": "switch",
              "value": data.blackAndWhiteFilter,
              "function": functions['Black and White filter'],
              "optionsAndValues": []
            },
          ]
        },
        {
          "type": "class",
          "nameClass": "Layout",
          "children": [
            {
              "nameConfig": "Tipo de Layout",
              "description": "Define Layout de navegação do leitor",
              "type": "radio",
              "value": data.layout,
              "function": functions['Layout'],
              "optionsAndValues": [
                {"option": "Em forma de L", "value": "L"},
                {"option": "Bordas LTR", "value": "bordersLTR"},
                {"option": "Bordas RTL", "value": "bordersRTL"},
                {"option": "Nenhum", "value": "none"},
              ]
            },
            {
              "nameConfig": "Mostrar Layout ao abrir o Leitor",
              "description": "Exibe as areas de toque no inicio",
              "type": "switch",
              "value": data.showLayout,
              "function": functions['ShowLayout'],
              "optionsAndValues": []
            },
          ]
        },
        {
          "type": "class",
          "nameClass": "Webtoon",
          "children": [
            {
              "nameConfig": "Distancia da Rolagem por Toque",
              "description": "Define a distancia do avanço",
              "type": "radio",
              "value": data.scrollWebtoon,
              "function": functions['ScrollWebtoon'],
              "optionsAndValues": [
                {"option": "100", "value": 100},
                {"option": "200", "value": 200},
                {"option": "400", "value": 400},
                {"option": "600", "value": 600},
              ]
            },
          ]
        },
      ]
    },
    {
      "type": "theme",
      "nameOptions": "Thema e Idioma",
      "settings": [
        {
          "nameConfig": "Rolar a Barra",
          "description": "retira a barra ao rolar para baixo",
          "type": "switch",
          "value": data.rollTheBar,
          "function": functions['Rolar a Barra'],
          "optionsAndValues": [
            {"option": "switch", "value": true}
          ]
        },
        {
          "type": "class",
          "nameClass": "Tema",
          "children": [
            {
              "nameConfig": "Tema",
              "description": "Define o tema do aplicativo",
              "type": "radio",
              "value": data.theme,
              "function": functions['Tema'],
              "optionsAndValues": [
                {"option": "Automatico", "value": "auto"},
                {"option": "Light", "value": "light"},
                {"option": "Dark", "value": "dark"}
              ]
            },
            {
              "nameConfig": "Cor da Interface",
              "description": "Define a cor dos icones e cabechalhos",
              "type": "radio",
              "value": data.interfaceColor,
              "function": functions['Cor da Interface'],
              "optionsAndValues": [
                {"option": "Azul", "value": "blue"},
                {"option": "Verde", "value": "green"},
                {"option": "Lime", "value": "lime"},
                {"option": "Roxo", "value": "purple"},
                {"option": "Rosa Ardente", "value": "pink"},
                {"option": "Rosa Claro", "value": "cleanpink"},
                {"option": "Laranja", "value": "orange"},
                {"option": "Vermelho", "value": "red"},
                {"option": "Preto", "value": "black"},
                {"option": "Branco", "value": "white"},
                {"option": "Cinza", "value": "grey"}
              ]
            },
          ]
        },
        {
          "type": "class",
          "nameClass": "Localidade",
          "children": [
            {
              "nameConfig": "Idioma",
              "description": "Define o linguagem do aplicativo",
              "type": "radio",
              "value": data.language,
              "function": functions['Idioma'],
              "optionsAndValues": [
                {"option": "Português(Br)", "value": "ptbr"}
              ]
            }
          ]
        },
      ]
    },
    {
      "type": "downloads",
      "nameOptions": "Downloads",
      "settings": [
        {
          "nameConfig": "Local de armazenamento",
          "description": "Define o local que fivaram os downloads",
          "type": "radio",
          "value": data.storageLocation,
          "function": functions['Local de armazenamento'],
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
          "type": "dependence",
          "children": [
            {
              "nameConfig": "Autenticação",
              "description": "Define se havera autenticação ao entrar",
              "type": "switch",
              "value": data.authentication,
              "function": functions['Autenticação'],
              "optionsAndValues": [
                {"option": "switch", "value": false}
              ]
            },
            {
              "nameConfig": "Tipo de Autenticação",
              "description": "Define o tipo autenticação",
              "type": "radio",
              "value": data.authenticationType,
              "function": functions['Tipo de Autenticação'],
              "optionsAndValues": [
                {"option": "Caracteres", "value": "text"},
                {"option": "Numeros", "value": "number"}
              ]
            }
          ]
        },
        {
          "nameConfig": "Senha de Autenticação",
          "description": "Define se havera autenticação ao entrar",
          "type": "input",
          "value": data.authenticationPassword,
          "function": functions['Senha de Autenticação'],
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
          "type": "class",
          "nameClass": "Pesquisa",
          "children": [
            {
              "nameConfig": "Multiplas Pesquisas",
              "description": "Define se pode fazer mais de uma pesquisa por vez",
              "type": "switch",
              "value": data.multipleSearches,
              "function": functions['Multiplas Pesquisas'],
              "optionsAndValues": [
                {"option": "switch", "value": false}
              ]
            },
          ]
        },
        {
          "type": "class",
          "nameClass": "Extensões",
          "children": [
            {
              "type": "dependence",
              "children": [
                {
                  "nameConfig": "Conteudo NSFW",
                  "description": "Define se havera extesões +18",
                  "type": "switch",
                  "value": data.nSFWContent,
                  "function": functions['Conteudo NSFW'],
                  "optionsAndValues": [
                    {"option": "switch", "value": false}
                  ]
                },
                {
                  "nameConfig": "Mostrar na Lista",
                  "description": "Exibe estas extensões na Lista de Extensões",
                  "type": "switch",
                  "value": data.showNSFWInList,
                  "function": functions['Mostrar na Lista'],
                  "optionsAndValues": [
                    {"option": "switch", "value": true}
                  ]
                }
              ]
            },
            {
              "type": "container",
              "children": [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.report_problem),
                      ),
                      Flexible(child: Text("Isto não impede Extesões de exibirem conteudo NSFW", softWrap: true,))
                    ],
                  ),
                )
              ]
            }
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
          "type": "confirm",
          "value": data.clearCache,
          "function": functions['Limpar o Cache'],
          "optionsAndValues": [
            {"option": "Cancelar", "value": false},
            {"option": "Confirmar", "value": true}
          ]
        },
        {
          "nameConfig": "Restaurar",
          "description": "Remove todos os dados do aplicativo",
          "type": "confirm",
          "value": data.restore,
          "function": functions['Restaurar'],
          "optionsAndValues": [
            {"option": "Cancelar", "value": false},
            {"option": "Confirmar", "value": true}
          ]
        }
      ]
    }
  ]);
}
