import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:manga_library/app/my_app.dart';
import 'package:manga_library/configs/hive/hive_congig.dart';

import 'app/controllers/system_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /// set the edge fullscreen
  // await FullScreenController().startScreenApp();
  await HiveConfig.start();
  AwesomeNotifications().initialize(
  // set the icon to null if you want to use the default app icon
  'resource://drawable/splash',
  [
    NotificationChannel(
        channelGroupKey: 'downloads_progress_bar_channel',
        channelKey: 'downloads_progress_bar_channel',
        channelName: 'Download Progress notifications',
        channelDescription: 'Notification channel for downloads',
        defaultColor: const Color.fromARGB(255, 80, 221, 92),
        ledColor: Colors.white)
  ],
  // Channel groups are only visual and are not required
  channelGroups: [
    NotificationChannelGroup(
        channelGroupKey: 'downloads_progress_bar_channel',
        channelGroupName: 'Download progress')
  ],
  debug: true
);
  await SystemController().start();
  runApp(const MyApp());
}
