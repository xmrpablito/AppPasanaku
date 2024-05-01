import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pasana/controllers/auth_service.dart';
import 'package:pasana/controllers/crud_service.dart';
import 'package:pasana/main.dart';

class PushNotifications {
  static final _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //Solicitar permiso de notificación
  static Future init() async {
    await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: true,
        provisional: false,
        sound: true);
  }

  static Future getDeviceToken() async {
    final token = await _firebaseMessaging.getToken();
    print("Token de dispositivo: $token");

    bool isUserLoggedIn = await AuthService.isLoggedIn();
    if (isUserLoggedIn) {
      await CRUDService.saveUserToken(token!);
      print("Token guardado en Firestore");
    }
    //También guardado si cambia el token
    _firebaseMessaging.onTokenRefresh.listen((event) async {
      if (isUserLoggedIn) {
        await CRUDService.saveUserToken(token!);
        print("Token guardado en Firestore");
      }
    });
  }

  //Iniciar notificaciones locales
  static Future localNotInit() async {
//Inicializar el plugin app_icon debe agregarse como un recurso de diseño
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );

    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Abrir Notificacion');

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);

    //Solicitar permisos de notificación para Android 13 o superior
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  //Notificación local de On Tap en primer plano
  static void onNotificationTap(NotificationResponse notificationResponse) {
    navigatorKey.currentState!
        .pushNamed("/message", arguments: notificationResponse);
  }

  //Mostrar una notificacion simple
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('Tu ID de canal', 'El nombre de tu canal',
            channelDescription: 'Descripción de tu canal',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }
}
