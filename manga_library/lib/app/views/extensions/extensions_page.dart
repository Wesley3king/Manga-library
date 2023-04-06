import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:manga_library/app/extensions/extensions.dart';
import 'package:manga_library/app/models/globais.dart';

class ExtensionsPage extends StatefulWidget {
  const ExtensionsPage({super.key});

  @override
  State<ExtensionsPage> createState() => _ExtensionsPageState();
}

class _ExtensionsPageState extends State<ExtensionsPage> {
  @override
  Widget build(BuildContext context) {
    List<int> keys = mapOfExtensions.keys.toList();
    return ListView.builder(
        itemCount: keys.length,
        itemBuilder: (context, index) {
          if (!mapOfExtensions[keys[index]]!.isAnDeprecatedExtension && ((GlobalData.settings.nSFWContent &&
                  GlobalData.settings.showNSFWInList &&
                  mapOfExtensions[keys[index]]!.nsfw) ||
              !mapOfExtensions[keys[index]]!.nsfw)) {
            return ListTile(
              title: Text(mapOfExtensions[keys[index]]!.nome),
              leading: SizedBox(
                width: 20,
                height: 20,
                child: Image.asset(
                  'assets/extesion_posters/${mapOfExtensions[keys[index]]!.extensionPoster}',
                  fit: BoxFit.contain,
                ),
              ),
              onTap: () =>
                  GoRouter.of(context).push('/extensionpage/${keys[index]}'),
            );
          }
          return Container();
        });
  }
}
