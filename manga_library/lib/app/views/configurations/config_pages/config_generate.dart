import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/system_config.dart';
import 'package:manga_library/app/models/globais.dart';
import 'package:manga_library/app/models/settings_model.dart';
import 'package:manga_library/app/views/configurations/config_pages/controller/page_config_controller.dart';

List<Widget> generateOptions(List<dynamic> settingsAndContainers,
    BuildContext context, SettingsOptionsController controller) {
  List<Widget> widgets = [];
  for (int i = 0; i < settingsAndContainers.length; ++i) {
    widgets.add(generateOption(settingsAndContainers[i], context, controller,
        isFirstOption: i == 0 ? true : false));
  }

  return widgets;
}

Widget generateOption(
    dynamic data, BuildContext context, SettingsOptionsController controller,
    {bool isFirstOption = false, bool isNotDisponible = false}) {
  final InputTypes inputTypes = InputTypes();
  final SettingsContainers containers = SettingsContainers();

  switch (data.type) {
    case "container":
      return containers.container(data, context, controller);
    case "dependence":
      return containers.dependence(data, context, controller);
    case "class":
      return containers.classe(data, context, controller, isFirstOption);
    case "switch":
      return inputTypes.onOff(data, controller,
          isNotDisponible: isNotDisponible);
    case "radio":
      return inputTypes.radio(data, context, controller,
          isNotDisponible: isNotDisponible);
    case "confirm":
      return inputTypes.confirm(data, context, controller,
          isNotDisponible: isNotDisponible);
    case "input":
      return inputTypes.input(data, context, controller,
          isNotDisponible: isNotDisponible);
    default:
      return Container();
  }
}

class SettingsContainers {
  ConfigSystemController configSystemController = ConfigSystemController();
  Widget container(dynamic data, BuildContext context,
      SettingsOptionsController controller) {
    debugPrint("container - data: ${data.toJson()}");

    List<Widget> buildItens() {
      List<Widget> itens = [];
      for (dynamic element in data.children) {
        debugPrint("elemento do buildItens: $element");
        if (element is Widget) {
          itens.add(element);
        } else {
          itens.add(generateOption(data, context, controller));
        }
      }
      return itens;
    }

    return Column(
      children: buildItens(),
    );
  }

  Widget dependence(dynamic data, BuildContext context,
      SettingsOptionsController controller) {
    debugPrint("dependence - data: $data");
    bool disponible = data.children[0].value == true;
    return Column(
      children: [
        generateOption(data.children[0], context, controller),
        disponible
            ? generateOption(data.children[1], context, controller)
            : generateOption(data.children[1], context, controller,
                isNotDisponible: true)
      ],
    );
  }

  Widget classe(dynamic data, BuildContext context,
      SettingsOptionsController controller, bool isFirstOption) {
    debugPrint("classe - data: ${data.toJson()}");
    List<Widget> itens = data.children
        .map<Widget>(
            (dynamic setting) => generateOption(setting, context, controller))
        .toList();
    return Column(
      children: [
        isFirstOption
            ? Container()
            : Divider(
                color: configSystemController.colorManagement(),
              ),
        Text(
          data.nameClass,
          style: TextStyle(color: configSystemController.colorManagement()),
        ),
        ...itens // children
      ],
    );
  }
}

class InputTypes {
  ConfigSystemController configSystemController = ConfigSystemController();

  Widget onOff(Setting data, SettingsOptionsController controller,
      {bool isNotDisponible = false}) {
    debugPrint('${data.value}');
    // return SwitchListTile(
    //   title: Text(data.nameConfig),
    //   subtitle: Text(data.description),
    //   // selected: isNotDisponible ? false : true,
    //   value: data.value,
    //   activeColor: configSystemController.colorManagement(),
    //   onChanged: (value) {
    //     data.function(value, controller);
    //   },
    // );
    return ListTile(
      title: Text(data.nameConfig),
      subtitle: Text(data.description),
      enabled: isNotDisponible ? false : true,
      trailing: Switch(
          value: data.value,
          onChanged: (value) {
            data.function(value, controller);
            debugPrint("mudou: $value");
          }),
    );
  }

  Widget radio(
      Setting data, BuildContext context, SettingsOptionsController controller,
      {bool isNotDisponible = false}) {
    return ListTile(
      title: Text(data.nameConfig),
      subtitle: Text(data.description),
      enabled: isNotDisponible ? false : true,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            //dynamic valuegroup = data.value;
            List<Widget> list = [];
            for (int i = 0; i < data.optionsAndValues.length; ++i) {
              list.add(RadioListTile(
                title: Text(data.optionsAndValues[i].option),
                value: data.optionsAndValues[i].value,
                groupValue: data.value,
                onChanged: (value) {
                  data.function(value, controller);
                  Navigator.of(context).pop();
                },
              ));
            }
            return SimpleDialog(
              title: Text(data.nameConfig),
              children: list,
            );
          },
        );
      },
    );
  }

  Widget input(
      Setting data, BuildContext context, SettingsOptionsController controller,
      {bool isNotDisponible = false}) {
    return ListTile(
        title: Text(data.nameConfig),
        subtitle: Text(data.description),
        enabled: isNotDisponible ? false : true,
        onTap: () async {
          bool isAuthorized = false;
          if (data.nameConfig == "Senha da Biblioteca Oculta") {
            String oldPassword = "";
            await showDialog(
              context: context,
              builder: (context) => SimpleDialog(
                title: const Text("Insira a senha Antiga"),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 6.0),
                    child: TextField(
                      autofocus: true,
                      // decoration: const InputDecoration(
                      //     label: Text("Nome da Biblioteca")),
                      onChanged: (value) => oldPassword = value,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Cancelar")),
                      TextButton(
                          onPressed: () {
                            if (oldPassword !=
                                GlobalData
                                    .settings["Senha da Biblioteca Oculta"]) {
                              showSnackBar(context, "Senha Incorreta!");
                            } else {
                              isAuthorized = true;
                            }
                            Navigator.of(context).pop();
                          },
                          child: const Text("Confirmar")),
                    ],
                  )
                ],
              ),
            );
          } else {
            isAuthorized = true;
          }
          if (isAuthorized) {
            String text = "";
            showDialog(
              context: context,
              builder: (context) => SimpleDialog(
                title: const Text("Insira a senha"),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 6.0),
                    child: TextField(
                      autofocus: true,
                      // decoration: const InputDecoration(
                      //     label: Text("Nome da Biblioteca")),
                      onChanged: (value) => text = value,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("Cancelar")),
                      TextButton(
                          onPressed: () {
                            data.function(text, controller);
                            Navigator.of(context).pop();
                          },
                          child: const Text("Salvar")),
                    ],
                  )
                ],
              ),
            );
          }
        });
  }

  Widget confirm(
      Setting data, BuildContext context, SettingsOptionsController controller,
      {bool isNotDisponible = false}) {
    return ListTile(
      title: Text(data.nameConfig),
      subtitle: Text(data.description),
      enabled: isNotDisponible ? false : true,
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Deseja ${data.nameConfig}?'),
                  content: const Text("está ação pode não ser reversivel"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Cancelar")),
                    TextButton(
                        onPressed: () {
                          data.function(true, controller);
                          Navigator.of(context).pop();
                        },
                        child: const Text("Confirmar"))
                  ],
                ));
      },
    );
  }

  void showSnackBar(BuildContext context, String txt) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(txt)));
  }
}
