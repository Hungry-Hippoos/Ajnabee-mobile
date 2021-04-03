import 'package:flutter/material.dart';
import 'package:memechat/quiz/quiz_brain.dart';
import 'package:memechat/quiz/components/option_card.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:memechat/views/chatrooms.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memechat/services/database.dart';

QuizBrain quizBrain = QuizBrain();

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<int> rorschach = [];

  int _value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Image.asset(
                    'assets/images/image${quizBrain.getQuestionNumber() + 1}.jpg'),
              ),
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: 11,
                    itemBuilder: (BuildContext context, int index) {
                      return OptionCard(
                          optionText: quizBrain.getOptionsList()[index],
                          radioButtonValue: index + 1,
                          groupValue: _value,
                          selectedOptionCallback: (int value) {
                            setState(() {
                              _value = value;
                            });
                          });
                    }),
              ),
              TextButton(
                onPressed: () async {
                  if (_value == null) {
                    Alert(
                            context: context,
                            title: "Alert!",
                            desc: "Please select an option")
                        .show();
                  } else {
                    if (quizBrain.isFinished()) {
                      rorschach.add(_value);
                      final FirebaseUser user =
                          await FirebaseAuth.instance.currentUser();
                      final String uid = user.email;
                      print(user);
                      print(uid);
                      var ob = DatabaseMethods();
                      var temp1 = await ob.getUserInfo(uid);
                      var temp2;

                      var newuser;
                      final userDoc = await Firestore.instance
                          .collection('users')
                          .where('userEmail', isEqualTo: uid)
                          .limit(1)
                          .getDocuments();

                      if (userDoc.documents.length != 0) {
                        newuser = userDoc.documents[0];
                      }

                      temp2 = newuser.data['userName'];

                      print(temp2);

                      dynamic abc = {
                        'username': '$temp2',
                        'options': rorschach,
                      };

                      http.Response response = await http.post(
                          "https://e094513681ab.ngrok.io/rtest/api/rtest/all",
                          body: json.encode(abc),
                          headers: {"Content-Type": "application/json"});
                      print(json.encode(abc));

                      if (response.statusCode == 200) {
                        print(response.body);
                      } else {
                        print("error");
                      }

                      Alert(
                              context: context,
                              title: "Finished!",
                              desc: "You\'ve reached the end of the quiz.")
                          .show();

                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => ChatRoom()));
                    } else {
                      rorschach.add(_value);
                      _value = null;
                      setState(() {
                        quizBrain.nextQuestion();
                      });
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Color(0xff21C38A),
                  ),
                  width: 150.0,
                  height: 40.0,
                  padding: EdgeInsets.all(5.0),
                  child: Center(
                    child: Text(
                      'Continue',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
