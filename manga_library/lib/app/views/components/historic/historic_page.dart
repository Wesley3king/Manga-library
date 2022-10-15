import 'package:flutter/material.dart';
import 'package:manga_library/app/views/components/historic/controller/historic_controller.dart';
import 'package:manga_library/app/views/components/historic/historic_process_builders.dart';

class HistoricPage extends StatefulWidget {
  const HistoricPage({super.key});

  @override
  State<HistoricPage> createState() => _HistoricPageState();
}

class _HistoricPageState extends State<HistoricPage> {
  final HistoricController controller = HistoricController();
  final HistoricProcessBuilders listBulders = HistoricProcessBuilders();

  Widget get loading => const Center(
        child: CircularProgressIndicator(),
      );
  Widget get error => Center(
        child: Column(
          children: const [
            Icon(Icons.report_problem),
            Text("Erro ao conguir o histórico!")
          ],
        ),
      );

  Widget sucess() {
    return ListView.builder(
      itemCount: listBulders.historicWidgets.length,
      itemBuilder: (context, index) => listBulders.historicWidgets[index],
    );
  }

  /// mostra um alerta antes de excluir o histórico
  void showCleanHistoricDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Limpar Histórico?"),
        content: const Text('Esta ação não é reversivel'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar')),
          TextButton(
              onPressed: () async {
                String response = await controller.cleanHistoric();
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(response)));
                Navigator.of(context).pop();
              },
              child: const Text('Confirmar'))
        ],
      ),
    );
  }

  Widget _stateManagement(HistoricStates state) {
    switch (state) {
      case HistoricStates.start:
        return loading;
      case HistoricStates.loading:
        return loading;
      case HistoricStates.sucess:
        return sucess();
      case HistoricStates.error:
        return error;
    }
  }

  @override
  void initState() {
    super.initState();
    controller.start(listBulders);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico'),
        actions: [
          IconButton(
            onPressed: () => showCleanHistoricDialog(context),
            tooltip: "Limpar o Histórico",
            icon: const Icon(Icons.delete_forever),
          )
        ],
      ),
      body: AnimatedBuilder(
        animation: controller.state,
        builder: (context, child) => _stateManagement(controller.state.value),
      ),
    );
  }
}
