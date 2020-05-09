import 'dart:async';
import 'dart:io';

import 'package:ap_common/config/ap_constants.dart';
import 'package:ap_common/utils/notification_utils.dart';
import 'package:ap_common_firebase/utils/firebase_analytics_utils.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

export 'package:firebase_analytics/firebase_analytics.dart';
export 'package:firebase_analytics/observer.dart';

class FirebaseUtils {
  static const NOTIFY_ID = 9919;
  static const NOTIFY_ANDROID_CHANNEL_ID = '1000';
  static String androidChannelDescription = 'FCM';

  static FirebaseAnalytics init() {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      FirebaseAnalyticsUtils.analytics = FirebaseAnalytics();
      initFcm();
      return FirebaseAnalyticsUtils.analytics;
    }
    return null;
  }

  static initFcm() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    await Future.delayed(Duration(seconds: 2));
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        if (ApConstants.isInDebugMode) print("onMessage: $message");
        NotificationUtils.show(
          id: NOTIFY_ID,
          androidChannelId: NOTIFY_ANDROID_CHANNEL_ID,
          androidChannelDescription: androidChannelDescription,
          title: message['notification']['title'] ?? '',
          content: message['notification']['body'] ?? '',
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        if (ApConstants.isInDebugMode) print("onLaunch: $message");
        //_navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        if (ApConstants.isInDebugMode) print("onResume: $message");
      },
    );
    firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    firebaseMessaging.getToken().then((String token) {
      if (token != null && ApConstants.isInDebugMode) {
        print("Push Messaging token: $token");
      }
    });
  }
}
