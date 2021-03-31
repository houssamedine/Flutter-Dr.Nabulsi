import 'package:app_web/chatScreen.dart';
import 'package:app_web/homeScreen.dart';
import 'package:app_web/loginScreen.dart';
import 'package:app_web/userProfileScreen.dart';
import 'package:app_web/welcomeScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(WebApp());
}

class WebApp extends StatefulWidget {
  @override
  _WebAppState createState() => _WebAppState();
}

class _WebAppState extends State<WebApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'موسوعة النابلسي',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        UserProfilScreen.id: (context) => UserProfilScreen(),
        LoginScreen.id: (context) => LoginScreen(),
      },
    );
  }
}
