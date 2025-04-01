import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:gen/gen.dart';
import 'package:hive/hive.dart';
import 'package:packpal/generated/locale_keys.g.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettingsIOS = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTapped,
    );
  }

  void onNotificationTapped(NotificationResponse notificationResponse) {
    // Handle notification tap
    // This can be used to navigate to specific screens when notifications are tapped
  }

  Future<void> requestPermissions() async {
    // Request notifications permission on iOS
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    // Request permissions on Android for API 33+
    final androidPlugin =
        _notificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
    }
  }

  Future<void> schedulePackingReminder(PackingList packingList) async {
    if (packingList.departureDate == null) {
      return; // No departure date set, can't schedule reminder
    }

    // Calculate reminder time - 1 day before departure
    final reminderDate = tz.TZDateTime.from(
      packingList.departureDate!.subtract(const Duration(days: 1)),
      tz.local,
    );

    // Check if reminder date is in the future
    final now = tz.TZDateTime.now(tz.local);
    if (reminderDate.isBefore(now)) {
      return; // Don't schedule past reminders
    }

    await _notificationsPlugin.zonedSchedule(
      packingList.id.hashCode, // Use hash of ID as unique notification ID
      LocaleKeys.notifications_packing_reminder_title.tr(),
      LocaleKeys.notifications_packing_reminder_body.tr(
        namedArgs: {'trip_name': packingList.name},
      ),
      reminderDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'packing_reminders',
          LocaleKeys.notifications_channel_packing_reminders.tr(),
          channelDescription: LocaleKeys.notifications_channel_description.tr(),
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'packing_list:${packingList.id}',
    );
  }

  Future<void> cancelPackingReminder(PackingList packingList) async {
    await _notificationsPlugin.cancel(packingList.id.hashCode);
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  /// Schedule notifications for all existing packing lists
  /// Use this after permissions have been granted in onboarding
  Future<void> scheduleAllPackingReminders() async {
    final packingLists = Hive.box<PackingList>('packing_lists').values.toList();
    for (final packingList in packingLists) {
      if (packingList.departureDate != null) {
        await schedulePackingReminder(packingList);
      }
    }
  }
}
