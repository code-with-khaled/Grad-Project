// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase must be initialized
  await Firebase.initializeApp();

  // You can save the notification to Hive here later
  print("🔔 Background Notification: ${message.notification?.title}");
}
