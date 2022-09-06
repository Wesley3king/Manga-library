import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/settings_options_controller.dart';
import 'package:manga_library/app/models/seetings_model.dart';

class ConfigOptionsPage extends StatefulWidget {
  final String type;
  const ConfigOptionsPage({super.key, required this.type});

  @override
  State<ConfigOptionsPage> createState() => _ConfigOptionsPageState();
}

class _ConfigOptionsPageState extends State<ConfigOptionsPage> {
  final SettingsOptionsController settingsOptionsController =
      SettingsOptionsController();
  final InputTypes inputTypes = InputTypes();

  Widget _buidInput(Settings data, BuildContext context) {
    switch (data.inputType) {
      case "switch":
        return inputTypes.onOff(data, settingsOptionsController);
      case "radio":
        return inputTypes.radio(data, context, settingsOptionsController);
      case "confirm":
        return inputTypes.confirm(data);
      case "input":
        return inputTypes.input(data);
      default:
        return Container();
    }
  }

  List<Widget> buildAllInputs(BuildContext context) {
    List<Widget> widgets = [];
    for (int i = 0; i < settingsOptionsController.settings.length; ++i) {
      widgets.add(_buidInput(settingsOptionsController.settings[i], context));
    }
    return widgets;
  }

  Widget _sucess(BuildContext context) {
    return ListView(
      children: buildAllInputs(context),
    );
  }

  Widget _stateManagement(SettingsOptionsStates state, BuildContext context) {
    switch (state) {
      case SettingsOptionsStates.start:
        return Container();
      case SettingsOptionsStates.loading:
        return Container();
      case SettingsOptionsStates.sucess:
        return _sucess(context);
      case SettingsOptionsStates.update:
        return Container();
      case SettingsOptionsStates.error:
        return Center(
          child: Column(
            children: const [Icon(Icons.report_problem), Text('Error!')],
          ),
        );
    }
  }

  Widget _buildAppBar(SettingsOptionsStates state) {
    switch (state) {
      case SettingsOptionsStates.sucess:
        return Text(settingsOptionsController.titleType);
      default:
        return const Text('Configurações');
    }
  }

  @override
  void initState() {
    super.initState();
    settingsOptionsController.start(widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: AnimatedBuilder(
            animation: settingsOptionsController.state,
            builder: (context, child) =>
                _buildAppBar(settingsOptionsController.state.value),
          ),
        ),
        body: AnimatedBuilder(
          animation: settingsOptionsController.state,
          builder: (context, child) =>
              _stateManagement(settingsOptionsController.state.value, context),
        ));
  }
}

class InputTypes {
  Widget onOff(Settings data, SettingsOptionsController controller) {
    print(data.value);
    return SwitchListTile(
      title: Text(data.nameConfig),
      subtitle: Text(data.description),
      value: data.value,
      onChanged: (value) {
        data.function(value, controller);
      },
    );
  }

  Widget radio(Settings data, BuildContext context,
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

  Widget input(Settings data) {
    return Container();
  }

  Widget confirm(Settings data) {
    return Container();
  }
}
