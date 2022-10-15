import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/historic_manager_controller.dart';
import 'package:manga_library/app/models/historic_model.dart';

class HistoricProcessBuilders {
  ManagerHistoricController _managerHistoricController =
      ManagerHistoricController();

  String? atualDateTime;
  String? lastDateTime;
  int referencesCount = 0;
  List<Widget> historicWidgets = [];

  void processHistoricBooks(List<HistoricModel> models) {
    for (HistoricModel model in models) {
      manageBuilderHistoric(model);
    }
  }

  void manageBuilderHistoric(HistoricModel model) {
    debugPrint("datas: atual ${model.date} - last $lastDateTime");
    if (lastDateTime == null) {
      String referenceName = verfifyApropriatedTitle(model.date);

      historicWidgets.add(Text(referenceName));
      buildListTile(model);
    } else if (model.date == lastDateTime) {
      buildListTile(model);
    } else {
      String referenceName = verfifyApropriatedTitle(model.date);

      historicWidgets.add(Text(referenceName));
      buildListTile(model);
    }
    lastDateTime = model.date;
  }

  /// constroi o listTile
  void buildListTile(HistoricModel model) {
    historicWidgets.add(ListTile(
      title: Text(model.name),
      subtitle: Text('Cap. ${model.chapter} - ${getHour(model.date)}'),
      leading: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: SizedBox(
          width: 50,
          height: 80,
          child: CachedNetworkImage(imageUrl: model.img),
        ),
      ),
      trailing: IconButton(
          onPressed: () => _managerHistoricController.removeFromHistoric(model),
          icon: const Icon(Icons.delete)),
    ));
  }

  String verfifyApropriatedTitle(String date) {
    // caso seja o primeiro
    atualDateTime ??= _managerHistoricController.getDateTime();
    return defineDate(atualDateTime!, date);
  }

  String defineDate(String atualDate, String modelDate) {
    List<String> atualDateAndHour = atualDate.split(' ');
    List<String> modelDateAndHour = modelDate.split(' ');

    List<String> atualDay = atualDateAndHour[0].split("-");
    List<String> modelDay = modelDateAndHour[0].split("-");

    if (int.parse(atualDay[2]) == int.parse(modelDay[2])) {
      return "Hoje";
    } else if (int.parse(atualDay[2]) == (int.parse(modelDay[2]) - 1)) {
      return "Ontem";
    } else {
      return "${modelDay[2]}/${modelDay[1]} de ${modelDay[0]}}";
    }
  }

  String getHour(String date) {
    List<String> modelDateAndHour = date.split(' ');

    List<String> modelHour = modelDateAndHour[1].split(":");

    return '${modelHour[0]}:${modelHour[1]}';
  }
}

// references.add({
//   "index": index,
//   "position": references.length,
//   "widget": Text(referenceName),
// });