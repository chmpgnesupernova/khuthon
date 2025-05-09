import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void initialize() {
    FirebaseMessaging.onMessage.listen((message) {
      print('New notification: ${message.notification?.title}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Notification clicked: ${message.data['route']}');
    });
  }
}
