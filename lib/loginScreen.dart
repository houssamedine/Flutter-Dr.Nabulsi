import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_web/homeScreen.dart';
import 'components.dart';
import 'fireBaseService.dart';

class LoginScreen extends StatefulWidget {
  static const id = "loginScreen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseService firebaseService = FirebaseService();
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
                  )),
              Positioned(
                  bottom: 0,
                  left: 0,
                  child: Image.asset(
                    'assets/images/main_bottom.png',
                    width: size.width * 0.2,
                  )),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(),
                    ),
                    Image.asset(
                      'assets/images/NabulsiRounded.png',
                      width: size.width * 0.5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'محمد راتب النابلسي',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Text(
                      'تسجيل الدخول باستخدام:',
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.purple,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    RoundedButton(
                      onPressed: () {
                        print('Phone Login Method');
                      },
                      colour: Colors.teal,
                      textColor: Colors.white,
                      title: 'Login with Phone',
                      buttonIcon: FontAwesomeIcons.phone,
                      iconColor: Colors.white,
                    ),
                    RoundedButton(
                      onPressed: () {
                        firebaseService.googleSignIn(context);
                      },
                      colour: Colors.amber,
                      textColor: Colors.white,
                      title: 'Login with Google',
                      buttonIcon: FontAwesomeIcons.google,
                      iconColor: Colors.white,
                    ),
                    RoundedButton(
                      onPressed: () {
                        print('Apple Login Method');
                      },
                      colour: Colors.white,
                      textColor: Colors.black,
                      title: 'Login with Apple',
                      buttonIcon: FontAwesomeIcons.apple,
                      iconColor: Colors.black,
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    FlatButton(
                      child: Text('تخطي'),
                      onPressed: () {
                        Navigator.pushNamed(context, HomeScreen.id);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
