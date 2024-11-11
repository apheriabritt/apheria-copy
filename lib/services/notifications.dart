//flutter

import 'dart:async';

//packages

//firebase
import 'package:firebase_messaging/firebase_messaging.dart';

//other
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//project

//data

//home pages

//services

//widgets

//other

String? pushToken = '';

//local notifications causing errors

class NotificationService { //LOCAL NOTIFS
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('notification');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});

          await  firebaseMessagingSetup();
        
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  } 

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

Future<void> firebaseMessagingSetup() async {
  //FIREBASE NOTIFS

  ///get token and print -- maybe save somewhere?
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  late FirebaseMessaging messaging;
/* this is causing crashlytics crash:
try{
   messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value){
        print(value);
        ///do something with this value?
        pushToken=value; ///print when click bell on home page and show in push notification
        });}
        catch(e){
          pushToken='no_value';
        }
        */
  //foreground messages

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage event) {
NotificationService()
              .showNotification(
  title:event.notification!.title,
   body: event.notification!.body,

);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
NotificationService()
              .showNotification(
  title:message.notification!.title,
   body: message.notification!.body,

);
  });
}
}