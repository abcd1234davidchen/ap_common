import 'dart:io';

import 'package:ap_common/models/course_notify_data.dart';
import 'package:ap_common/utils/ap_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sprintf/sprintf.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

export 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationUtils {
  static const String androidResourceName = '@drawable/ic_stat_name';

  // Notification ID
  static const int bus = 100;
  static const int course = 101;
  static const int fcm = 200;

  static bool get isSupport =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isMacOS);

  static InitializationSettings get settings {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(androidResourceName);
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    const DarwinInitializationSettings initializationSettingsMacOS =
        DarwinInitializationSettings();
    return const InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS,
    );
  }

  //For taiwan week order
  /// [weekday] The day of the week [monday]..[sunday].
  ///
  /// In accordance with ISO 8601
  /// a week starts with Monday, which has the value 1.
  static Day getDay(int weekday) {
    if (weekday == 7) {
      return Day.sunday;
    } else {
      return Day.values[weekday];
    }
  }

  static TimeOfDay parseTime(String text, {int beforeMinutes = 0}) {
    final DateFormat formatter = DateFormat('HH:mm', 'zh');
    final DateTime dateTime = formatter.parse(text).add(
          Duration(minutes: -beforeMinutes),
        );
    return TimeOfDay(
      hour: dateTime.hour,
      minute: dateTime.minute,
    );
  }

  static DateTime getNextWeekdayDateTime(Day day, TimeOfDay time) {
    final DateTime now = DateTime.now();
    final DateTime dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    int diffDay = 7 - (now.weekday - day.value + 1);
    if (now.weekday + 1 == day.value && now.isBefore(dateTime)) diffDay = 0;
    return dateTime.add(
      Duration(days: diffDay),
    );
  }

  static Future<void> show({
    required int id,
    required String androidChannelId,
    required String androidChannelDescription,
    required String title,
    required String content,
    bool enableVibration = true,
    String androidResourceIcon = androidResourceName,
    InitializationSettings? settings,
    VoidCallback? onSelectNotification,
  }) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        androidChannelId,
        androidChannelDescription,
        channelDescription: androidChannelDescription,
        icon: androidResourceIcon,
        importance: Importance.max,
        enableVibration: enableVibration,
        styleInformation: BigTextStyleInformation(content),
      ),
      iOS: const DarwinNotificationDetails(presentAlert: true),
      macOS: const DarwinNotificationDetails(presentAlert: true),
    );
    flutterLocalNotificationsPlugin.initialize(
      settings ?? NotificationUtils.settings,
      // onSelectNotification: (String? text) async =>
      //     onSelectNotification?.call(),
    );
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      content,
      platformChannelSpecifics,
      payload: content,
    );
  }

  static Future<void> scheduleCourseNotify({
    required BuildContext context,
    required CourseNotify courseNotify,
    required Day day,
    bool enableVibration = true,
    int beforeMinutes = 10,
    String? androidResourceIcon = androidResourceName,
    InitializationSettings? settings,
    VoidCallback? onSelectNotification,
  }) async {
    final ApLocalizations ap = ApLocalizations.of(context);
    final String content = sprintf(
      ap.courseNotifyContent,
      <String?>[
        courseNotify.title,
        if (courseNotify.location == null || courseNotify.location!.isEmpty)
          ap.courseNotifyUnknown
        else
          courseNotify.location,
      ],
    );
    final TimeOfDay time =
        parseTime(courseNotify.startTime, beforeMinutes: beforeMinutes);
    await scheduleWeeklyNotify(
      id: courseNotify.id,
      title: ap.courseNotify,
      content: content,
      day: day,
      time: time,
      androidChannelId: '$course',
      androidChannelDescription: ap.courseNotify,
      settings: settings,
      onSelectNotification: onSelectNotification,
    );
  }

  static Future<void> scheduleWeeklyNotify({
    required int id,
    required String androidChannelId,
    required String androidChannelDescription,
    required Day day,
    required TimeOfDay time,
    required String title,
    required String content,
    String androidResourceIcon = androidResourceName,
    InitializationSettings? settings,
    VoidCallback? onSelectNotification,
  }) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        androidChannelId,
        androidChannelDescription,
        channelDescription: androidChannelDescription,
        icon: androidResourceIcon,
        importance: Importance.max,
        enableVibration: false,
        styleInformation: BigTextStyleInformation(content),
      ),
      iOS: const DarwinNotificationDetails(presentAlert: true),
      macOS: const DarwinNotificationDetails(presentAlert: true),
    );
    tz.initializeTimeZones();
    final tz.TZDateTime scheduleDateTime = tz.TZDateTime.from(
      getNextWeekdayDateTime(day, time),
      tz.local,
    );
    flutterLocalNotificationsPlugin.initialize(
      settings ?? NotificationUtils.settings,
      // onSelectNotification: (String? text) async =>
      //     onSelectNotification?.call(),
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      content,
      scheduleDateTime,
      platformChannelSpecifics,
      payload: content,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> schedule({
    required int id,
    required String androidChannelId,
    required String androidChannelDescription,
    required DateTime dateTime,
    required String title,
    required String content,
    String androidResourceIcon = androidResourceName,
    InitializationSettings? settings,
    VoidCallback? onSelectNotification,
  }) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        androidChannelId,
        androidChannelDescription,
        channelDescription: androidChannelDescription,
        icon: androidResourceIcon,
        importance: Importance.max,
        enableVibration: false,
        styleInformation: BigTextStyleInformation(content),
      ),
      iOS: const DarwinNotificationDetails(presentAlert: true),
      macOS: const DarwinNotificationDetails(presentAlert: true),
    );
    tz.initializeTimeZones();
    final tz.TZDateTime scheduleDateTime = tz.TZDateTime.from(
      dateTime,
      tz.local,
    );
    flutterLocalNotificationsPlugin.initialize(
      settings ?? NotificationUtils.settings,
      // onSelectNotification: (String? text) async =>
      //     onSelectNotification?.call(),
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      content,
      scheduleDateTime,
      platformChannelSpecifics,
      payload: content,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<bool?> requestPermissions({
    bool sound = true,
    bool alert = true,
    bool badge = true,
  }) async {
    if (!kIsWeb && Platform.isIOS) {
      return await FlutterLocalNotificationsPlugin()
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: sound,
            badge: badge,
            sound: sound,
          );
    } else if (!kIsWeb && Platform.isMacOS) {
      return await FlutterLocalNotificationsPlugin()
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: sound,
            badge: badge,
            sound: sound,
          );
    } else if (!kIsWeb && Platform.isAndroid) {
      return await FlutterLocalNotificationsPlugin()
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    } else {
      return null;
    }
  }

  static Future<void> cancelCourseNotify({
    required int id,
  }) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future<List<PendingNotificationRequest>>
      getPendingNotificationList() async {
    return FlutterLocalNotificationsPlugin().pendingNotificationRequests();
  }

  static Future<void> cancelAll() async {
    await FlutterLocalNotificationsPlugin().cancelAll();
  }
}
