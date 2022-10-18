import 'package:flutter/material.dart';
import 'package:manga_library/app/views/configurations/config_pages/config_generate.dart';
import 'package:manga_library/app/views/configurations/config_pages/controller/page_config_controller.dart';

class ConfigOptionsPage extends StatefulWidget {
  final String type;
  const ConfigOptionsPage({super.key, required this.type});

  @override
  State<ConfigOptionsPage> createState() => _ConfigOptionsPageState();
}

class _ConfigOptionsPageState extends State<ConfigOptionsPage> {
  final SettingsOptionsController settingsOptionsController = SettingsOptionsController();
  
  // List<Widget> buildAllInputs(BuildContext context) {
  //   List<Widget> widgets = [];
  //   for (int i = 0;
  //       i < settingsOptionsController.settingsAndContainers.length;
  //       ++i) {
  //     widgets.add(_buidInput(
  //         ));
  //   }
  //   generateOptions(settingsOptionsController.settingsAndContainers[i], context)
  //   return widgets;
  // }

  Widget _sucess(BuildContext context) {
    return ListView(
      children: generateOptions(settingsOptionsController.settingsAndContainers, context, settingsOptionsController),
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
