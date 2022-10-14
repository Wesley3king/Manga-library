import 'package:flutter/material.dart';
import 'package:manga_library/app/views/components/historic/controller/historic_controller.dart';

class HistoricPage extends StatefulWidget {
  const HistoricPage({super.key});

  @override
  State<HistoricPage> createState() => _HistoricPageState();
}

class _HistoricPageState extends State<HistoricPage> {
  final HistoricController controller = HistoricController();

  Widget get loading => const Center(child: CircularProgressIndicator(),);

  Widget _stateManagement(HistoricStates state) {
    switch (state) {
      case HistoricStates.start:
        return Container();
      case HistoricStates.loading:
        return Container();
      case HistoricStates.sucess:
        return Container();
      case HistoricStates.error:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
      ),
      body: AnimatedBuilder(
        animation: controller.state,
        builder: (context, child) => _stateManagement(controller.state.value),
      ),
    );
  }
}
