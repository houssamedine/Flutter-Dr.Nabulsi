import 'package:app_web/fireBaseService.dart';
import 'package:app_web/homeScreen.dart';
import 'package:app_web/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class WelcomeScreen extends StatefulWidget {
  static const id = 'welcomeScreen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    Firebase.initializeApp();
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      if (_auth.currentUser != null) {
        Navigator.pushNamed(context, HomeScreen.id);
      } else {
        Navigator.pushNamed(context, LoginScreen.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Container(
            height: size.height,
            width: double.infinity,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  child: Image.asset(
                    'assets/images/main_top.png',
                    width: size.width * 0.3,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Image.asset(
                    'assets/images/main_bottom.png',
                    width: size.width * 0.4,
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'محمد راتب النابلسي',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Image.asset(
                        'assets/images/NabulsiRounded.png',
                        width: size.width * 0.5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
