import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pasana/controllers/auth_service.dart';
import 'package:pasana/controllers/notification_service.dart';
import 'package:pasana/firebase_options.dart';
import 'package:pasana/views/home_page.dart';
import 'package:pasana/views/login_page.dart';
import 'package:pasana/views/message.dart';
import 'package:pasana/views/signup_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();

//función para lisen a los cambios en segundo plano
Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("Alguna notificación recibida en segundo plano...");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Inicializar Firebase Messaging
  await PushNotifications.init();

  //Iniciar notificaciones locales
  await PushNotifications.localNotInit();

  //Escuchar notificaciones en segundo plano
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

  //Al tocar la notificación en segundo plano
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      print("Notificación en segundo plano pulsada...");
      navigatorKey.currentState!.pushNamed("/message");
    }
  });
  //Para controlar las notificaciones en primer plano
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String payloadData = jsonEncode(message.data);
    print("Tengo un mensaje en primer plano");
    if (message.notification != null) {
      PushNotifications.showSimpleNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload: payloadData);
    }
  });
  //para la entrega en estado terminado
  final RemoteMessage? message =
      await FirebaseMessaging.instance.getInitialMessage();
  if (message != null) {
    print("Lanzado desde el estado terminado");
    Future.delayed(Duration(seconds: 1), () {
      navigatorKey.currentState!.pushNamed("/message", arguments: message);
    });
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey,
      routes: {
        "/": (context) => CheckUser(),
        "/signup": (context) => SignUpPage(),
        "/login": (context) => LoginPage(),
        "/home": (context) => HomePage(),
        "/message": (context) => Message()
      },
    );
  }
}

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  void initState() {
    AuthService.isLoggedIn().then((value) {
      if (value) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
