import 'package:app_web/chatScreen.dart';
import 'package:app_web/userProfileScreen.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () {
                    Navigator.pushNamed(context, UserProfilScreen.id);
                  }),
              Expanded(child: SizedBox()),
              Center(child: Text('دكتور محمد راتب النابلسي')),
              Expanded(child: SizedBox()),
              IconButton(
                  icon: Icon(Icons.chat),
                  onPressed: () {
                    Navigator.pushNamed(context, ChatScreen.id);
                  })
            ],
          ),
          body: WebView(
            initialUrl: 'https://nabulsi.com/web/',
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
      ),
    );
  }
}
