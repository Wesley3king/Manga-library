import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:manga_library/app/controllers/historic_manager_controller.dart';
import 'package:manga_library/app/models/historic_model.dart';
import 'package:manga_library/app/views/components/historic/controller/historic_controller.dart';

class HistoricProcessBuilders {
  ManagerHistoricController managerHistoricController =
      ManagerHistoricController();

  final HistoricController controller;
  HistoricProcessBuilders({required this.controller});

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
    List<String>? atualDateAndHour = lastDateTime?.split(' ');
    List<String> modelDateAndHour = model.date.split(' ');
    if (lastDateTime == null) {
      buildReferenceTime(model.date);
      buildListTile(model);
    } else if (modelDateAndHour[0] == atualDateAndHour![0]) {
      buildListTile(model);
    } else {
      buildReferenceTime(model.date);
      buildListTile(model);
    }
    lastDateTime = model.date;
  }

  /// gera as referencias de tempo
  void buildReferenceTime(String date) {
    String referenceName = verfifyApropriatedTitle(date);
    historicWidgets.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
      child: Text(
        referenceName,
        style: const TextStyle(
          fontSize: 17,
          color: Color.fromARGB(255, 221, 221, 221)
        ),
      ),
    ));
  }

  /// constroi o listTile
  void buildListTile(HistoricModel model) {
    // historicWidgets.add(ListTile(
    //   title: Text(model.name),
    //   subtitle: Text('Cap. ${model.chapter} - ${getHour(model.date)}'),
    //   leading: ClipRRect(
    //     borderRadius: const BorderRadius.all(Radius.circular(8)),
    //     child: SizedBox(
    //       width: 50,
    //       height: 80,
    //       child: CachedNetworkImage(imageUrl: model.img),
    //     ),
    //   ),
    //   trailing: IconButton(
    //       onPressed: () => _managerHistoricController.removeFromHistoric(model),
    //       icon: const Icon(Icons.delete)),
    //   // style: ListTileStyle.drawer,
    // ));
    historicWidgets.add(CustomListTile(
      model: model,
      controller: managerHistoricController,
      historicController: controller,
      builders: this,
    ));
  }

  String verfifyApropriatedTitle(String date) {
    // caso seja o primeiro
    atualDateTime ??= managerHistoricController.getDateTime();
    return defineDate(atualDateTime!, date);
  }

  String defineDate(String atualDate, String modelDate) {
    List<String> atualDateAndHour = atualDate.split(' ');
    List<String> modelDateAndHour = modelDate.split(' ');

    List<String> atualDay = atualDateAndHour[0].split("-");
    List<String> modelDay = modelDateAndHour[0].split("-");

    if (int.parse(atualDay[2]) == int.parse(modelDay[2])) {
      return "Hoje";
    } else if (int.parse(atualDay[2]) == (int.parse(modelDay[2]) + 1)) {
      return "Ontem";
    } else {
      return "${modelDay[2]}/${modelDay[1]} de ${modelDay[0]}";
    }
  }

  static String getHour(String date) {
    List<String> modelDateAndHour = date.split(' ');

    List<String> modelHour = modelDateAndHour[1].split(":");

    return '${modelHour[0]}:${modelHour[1]}';
  }
}

class CustomListTile extends StatelessWidget {
  final HistoricModel model;
  final ManagerHistoricController controller;
  final HistoricProcessBuilders builders;
  final HistoricController historicController;
  const CustomListTile(
      {super.key,
      required this.model,
      required this.controller,
      required this.historicController,
      required this.builders});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  child: SizedBox(
                    width: 80,
                    height: 110,
                    child: CachedNetworkImage(
                      imageUrl: model.img,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width - 150),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name,
                      maxLines: 3,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Cap. ${model.chapter} - ${HistoricProcessBuilders.getHour(model.date)}',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 5.0,
                  right: 5.0,
                ),
                child: IconButton(
                    onPressed: () async {
                      bool res = await controller.removeFromHistoric(model);
                      builders.historicWidgets = [];
                      if (res) historicController.start(builders);
                    },
                    icon: const Icon(Icons.delete)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
