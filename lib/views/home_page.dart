import 'package:flutter/material.dart';
import 'package:pasana/controllers/auth_service.dart';
import 'package:pasana/controllers/notification_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    PushNotifications.getDeviceToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenido a Pasanaku"),
        actions: [
          IconButton(
              onPressed: () async {
                await AuthService.logout();
                Navigator.pushReplacementNamed(context, "/login");
              },
              icon: Icon(Icons.logout))
        ],
      ),
    );
  }
}
