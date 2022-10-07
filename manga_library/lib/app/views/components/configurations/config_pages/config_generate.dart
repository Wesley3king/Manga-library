import 'package:flutter/material.dart';
import 'package:manga_library/app/models/settings_model.dart';
import 'package:manga_library/app/views/components/configurations/config_pages/controller/page_config_controller.dart';

List<Widget> generateOptions(List<dynamic> settingsAndContainers,
    BuildContext context, SettingsOptionsController controller) {
  List<Widget> widgets = [];
  for (int i = 0; i < settingsAndContainers.length; ++i) {
    widgets.add(generateOption(settingsAndContainers[i], context, controller));
  }

  return widgets;
}

Widget generateOption(
    dynamic data, BuildContext context, SettingsOptionsController controller) {
  final InputTypes inputTypes = InputTypes();
  final SettingsContainers containers = SettingsContainers();

  switch (data.inputType) {
    case "container":
      return containers.container(data, context, controller);
    case "dependence":
      return containers.dependence(data, context, controller);
    case "class":
      return containers.classe(data, context, controller);
    case "switch":
      return inputTypes.onOff(data, controller);
    case "radio":
      return inputTypes.radio(data, context, controller);
    case "confirm":
      return inputTypes.confirm(data, context, controller);
    case "input":
      return inputTypes.input(data, context, controller);
    default:
      return Container();
  }
}

class SettingsContainers {
  Widget container(dynamic data, BuildContext context,
      SettingsOptionsController controller) {
    debugPrint("container - data: $data");

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
    return Column(
      children: [
        generateOption(data.children[0], context, controller),
        generateOption(data.children[1], context, controller)
      ],
    );
  }

  Widget classe(dynamic data, BuildContext context,
      SettingsOptionsController controller) {
    debugPrint("classe - data: $data");
    return Column(
      children: [
        const Divider(),
        Text(data.nameClass), // children
      ],
    );
  }
}

class InputTypes {
  Widget onOff(Setting data, SettingsOptionsController controller) {
    debugPrint('${data.value}');
    return SwitchListTile(
      title: Text(data.nameConfig),
      subtitle: Text(data.description),
      value: data.value,
      onChanged: (value) {
        data.function(value, controller);
      },
    );
  }

  Widget radio(Setting data, BuildContext context,
      SettingsOptionsController controller) {
    return ListTile(
      title: Text(data.nameConfig),
      subtitle: Text(data.description),
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

  Widget input(Setting data, BuildContext context,
      SettingsOptionsController controller) {
    return Container();
  }

  Widget confirm(Setting data, BuildContext context,
      SettingsOptionsController controller) {
    return Container();
  }
}
