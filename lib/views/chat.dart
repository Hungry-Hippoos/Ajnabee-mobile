import 'dart:io';
import 'package:memechat/helper/constants.dart';
import 'package:memechat/services/database.dart';
import 'package:memechat/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Chat extends StatefulWidget {
  final String chatRoomId;
  final String userName;

  Chat({this.chatRoomId, this.userName});
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  ScrollController _sc = ScrollController();

  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();
  QuerySnapshot searchResultSnapshot;
  Widget chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                controller: _sc,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapshot.data.documents[index].data["message"],
                    sendByMe: Constants.myName ==
                        snapshot.data.documents[index].data["sendBy"],
                  );
                })
            : Container();
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
        _sc.jumpTo(_sc.position.maxScrollExtent);
      });
    }
  }

  @override
  void initState() {
    DatabaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.yellow, width: 2),
                  shape: BoxShape.circle,
                  color: Colors.grey),
              child: Icon(
                Icons.person,
                size: 40,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              widget.userName,
              style: TextStyle(fontFamily: "Roboto", letterSpacing: 2.5),
            ),
            FlatButton(
              onPressed: () async {
                var list = [];
                await Firestore.instance
                    .collection("chatRoom")
                    .document("${widget.chatRoomId}")
                    .collection("chats")
                    .orderBy('time')
                    .getDocuments()
                    .then((value) => {
                          value.documents.forEach((f) {
                            var t1 = f.data['message'];
                            var t2 = f.data['sendBy'];
                            var t3 = f.data['time'];
                            list.add([t1, t2, t3]);
                          })
                        });

                print(list);

                dynamic request = {"data": list};

                http.Response response = await http.post(
                    "https://2c0275413087.ngrok.io/rtest/api/message",
                    body: json.encode(request),
                    headers: {"Content-Type": "application/json"});
                print(json.encode(request));

                if (response.statusCode == 200) {
                  print(response.body);
                } else {
                  print("error");
                }
              },
              child: Icon(
                Icons.account_box,
                size: 40,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFF3B743B),
        elevation: 0.0,
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessages(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        padding: MediaQuery.of(context).viewInsets,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: new Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  child: TextField(
                    onTap: () {
                      setState(() {
                        _sc.jumpTo(_sc.position.maxScrollExtent);
                      });
                    },
                    maxLines: 3,
                    minLines: 1,
                    style: TextStyle(fontSize: 20, color: Colors.black),
                    controller: messageEditingController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        hintText: "Type a message",
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                        border: InputBorder.none),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 16,
            ),
            GestureDetector(
              onTap: () {
                addMessage();
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                child: Icon(
                  Icons.message,
                  color: Colors.black,
                  size: 34,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8, bottom: 8, left: sendByMe ? 0 : 24, right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin:
            sendByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: sendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomLeft: Radius.circular(23))
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)),
          color: Colors.black,
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.yellow,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w400)),
      ),
    );
  }
}
