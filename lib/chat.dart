import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'appBrain.dart';
import 'package:intl/intl.dart';
import 'fUser.dart';
import 'firebaseService.dart';

class Chat extends StatefulWidget {
  final String senderAvatar;
  final String senderName;

  Chat({
    this.senderAvatar,
    this.senderName,
  });

  @override
  State createState() =>
      ChatState(senderAvatar: senderAvatar, senderName: senderName);
}

class ChatState extends State<Chat> {
  FirebaseService _firebaseService = FirebaseService();
  ChatState({
    this.senderAvatar,
    this.senderName,
  });
  String senderAvatar = avatarPlaceholderURL;
  String senderName = '';
  bool hideChat = false;
  String id;

  List<QueryDocumentSnapshot> listMessage = new List.from([]);
  int _limit = 20;
  final int _limitIncrement = 20;
  bool isLoading;
  bool isShowSticker;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("reach the bottom");
      setState(() {
        print("reach the bottom");
        _limit += _limitIncrement;
      });
    }
    if (listScrollController.offset <=
            listScrollController.position.minScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("reach the top");
      setState(() {
        print("reach the top");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);
    isLoading = false;
    isShowSticker = false;
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  Widget buildItem(int index, DocumentSnapshot doc) {
    if (doc.data()['idFrom'] == userUID) {
      // Right (my message)
      return GestureDetector(
        onLongPress: () {
          if (doc.get('idFrom') == userUID) {
            print('its from me');
          }
          print(doc.id);
        },
        child: Column(
          children: [
            Row(
              children: <Widget>[
                Container(
                  child: Text(
                    doc.data()['content'],
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(
                      bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                      right: 10.0),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Image.network(
                    doc.data()['senderAvatar'],
                    height: 50.0,
                    width: 50.0,
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                isLastMessageRight(index)
                    ? Container(
                        child: Text(
                          DateFormat('dd MMM kk:mm').format(
                            DateTime.fromMillisecondsSinceEpoch(
                              int.parse(doc.data()['messageTime']),
                            ),
                          ),
                          style: TextStyle(
                              color: greyColor,
                              fontSize: 12.0,
                              fontStyle: FontStyle.italic),
                        ),
                        margin:
                            EdgeInsets.only(right: 50.0, top: 5.0, bottom: 5.0),
                      )
                    : Container(),
              ],
            )
          ],
        ),
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 60),
                  child: Text(
                    doc.data()['senderName'],
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: Image.network(
                    doc.data()['senderAvatar'],
                    height: 50.0,
                    width: 50.0,
                  ),
                ),
                Container(
                  child: Text(
                    doc.data()['content'],
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(left: 10.0),
                ),
              ],
            ),
            // Time
            Container(
              child: Text(
                DateFormat('dd MMM kk:mm').format(
                  DateTime.fromMillisecondsSinceEpoch(
                    int.parse(doc.data()['messageTime']),
                  ),
                ),
                style: TextStyle(
                    color: greyColor,
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic),
              ),
              margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1].data()['idFrom'] == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1].data()['idFrom'] != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .update({'chattingWith': null});
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              buildListMessage(),
              // Input content
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: buildInput(),
              ),
            ],
          ),

          // Loading
          buildLoading()
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? CircularProgressIndicator() : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: TextField(
                  onSubmitted: (value) {
                    onSendMessage(textEditingController.text, 0);
                  },
                  style: TextStyle(color: Colors.blue, fontSize: 18.0),
                  controller: textEditingController,
                  decoration: InputDecoration.collapsed(
                    hintText: 'اكتب رسالتك هنا ...',
                    hintStyle: TextStyle(color: greyColor),
                  ),
                  focusNode: focusNode,
                ),
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(
                  Icons.send,
                  color: Colors.blue,
                ),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: Colors.blue,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: greyColor2, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: StreamBuilder(
        stream: _firebaseService.db
            .collection('messages')
            .orderBy('timeStamp', descending: true)
            .limit(_limit)
            .snapshots(),
        builder: (context, stream) {
          if (stream.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (stream.hasError) {
            return Center(child: Text(stream.error.toString()));
          }
          listMessage.addAll(stream.data.docs);
          return ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemBuilder: (context, index) =>
                buildItem(index, stream.data.docs[index]),
            itemCount: stream.data.docs.length,
            reverse: true,
            controller: listScrollController,
          );
        },
      ),
    );
  }

  //functions
  void onSendMessage(String content, int type) {
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = _firebaseService.db
          .collection('messages')
          .doc(DateTime.now().microsecondsSinceEpoch.toString());
      _firebaseService.db.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'content': content,
            'idFrom': userUID,
            'senderName': userDisplayName,
            'senderAvatar': userPhotoUrl,
            'messageTime': DateTime.now().millisecondsSinceEpoch.toString(),
            'timeStamp': DateTime.now()
          },
        );
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }
}
