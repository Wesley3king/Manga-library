import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  ///checks/requests permissions to display notifications
  static void checkPermissions() async {
    final bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    } else {
      // caso tenha permissão removera todas as notificações
      removeAllNotifications();
    }
  }

  static void removeAllNotifications() {
    AwesomeNotifications().cancelAll();
  }

  void updateProgressBar(
      {required int id,
      required int progress,
      required String bookAndChapter}) {
    if (progress == 100) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: id,
              channelKey: 'downloads_progress_bar_channel',
              title: 'Download finalizado',
              body: bookAndChapter,
              category: NotificationCategory.Progress,
              // payload: {
              //   'file': 'filename.txt',
              //   'path': '-rmdir c://ruwindows/system32/huehuehue'
              // },
              locked: false));
    } else {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: id,
              channelKey: 'downloads_progress_bar_channel',
              title: '$progress% - Download em andamento',
              body: bookAndChapter,
              category: NotificationCategory.Progress,
              // payload: {
              //   'file': 'filename.txt',
              //   'path': '-rmdir c://ruwindows/system32/huehuehue'
              // },
              notificationLayout: NotificationLayout.ProgressBar,
              progress: progress,
              locked: true));
    }
  }

  void errorProgressBar({required int id, required String bookAndChapter}) {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: 'downloads_progress_bar_channel',
            title: 'Falha no download',
            body: bookAndChapter,
            category: NotificationCategory.Progress,
            // payload: {
            //   'file': 'filename.txt',
            //   'path': '-rmdir c://ruwindows/system32/huehuehue'
            // },
            locked: false));
  }

  void removeNotification(int id) {
    AwesomeNotifications().cancel(id);
  }
}

class DownloadNotification {
  /// service
  final NotificationService service = NotificationService();

  /// variables
  late final int id;
  late final String bookAndChapter;
  late final int maxPages;
  late int currentPage;
  int progress = 0;
  DownloadNotification(
      {required this.id,
      required this.bookAndChapter,
      required this.maxPages,
      required this.currentPage});

  /// atualiza o valor da notificação
  set updateProgress(int downloadedPageIndex) {
    currentPage = downloadedPageIndex;
    setProgress();
    updateNotification();
  }

  /// configures an error message that indicates the download failed
  void setThisAnError() {
    service.errorProgressBar(id: id, bookAndChapter: bookAndChapter);
  }

  void setProgress() => currentPage == maxPages
      ? progress = 100
      : progress = ((100 * currentPage) / maxPages).round();

  void updateNotification() {
    service.updateProgressBar(
        id: id, progress: progress, bookAndChapter: bookAndChapter);
  }

  void removeNotification() {
    service.removeNotification(id);
  }
}
