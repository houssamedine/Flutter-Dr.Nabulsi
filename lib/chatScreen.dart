import 'package:app_web/chat.dart';
import 'package:app_web/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static const id = 'ChatScreen';
  final String senderName;
  final String senderAvatar;

  ChatScreen({
    this.senderAvatar,
    this.senderName,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: CurvedBottomClipper(),
                  child: Container(
                    color: Colors.blue,
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25),
                  child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
                SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.asset(
                            'assets/images/NabulsiRounded.png',
                            width: 65,
                            height: 65,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
                child: Chat(
              senderName: widget.senderName,
              senderAvatar: widget.senderAvatar,
            )),
          ],
        ),
      ),
    );
  }
}
