import 'dart:ffi';

import 'package:memechat/helper/helperfunctions.dart';
import 'package:memechat/helper/theme.dart';
import 'package:memechat/services/auth.dart';
import 'package:memechat/services/database.dart';
import 'package:memechat/views/chatrooms.dart';
import 'package:memechat/views/forgot_password.dart';
import 'package:memechat/widget/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn(this.toggleView);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();

  AuthService authService = new AuthService();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  signIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authService
          .signInWithEmailAndPassword(
              emailEditingController.text, passwordEditingController.text)
          .then((result) async {
        if (result != null)  {
          QuerySnapshot userInfoSnapshot =
              await DatabaseMethods().getUserInfo(emailEditingController.text);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              userInfoSnapshot.documents[0].data["userName"]);
          HelperFunctions.saveUserEmailSharedPreference(
              userInfoSnapshot.documents[0].data["userEmail"]);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        } else {
          setState(() {
            isLoading = false;
            //show snackbar
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Color(0xff36B6C5),
        title: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                height: 40,
                width: 40,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          "assets/images/Applogo.png",
                        )),
                  ),
                ),
              ),
            ),
            Text(
              "DIscuss!",
              style: TextStyle(fontFamily: "Roboto", letterSpacing: 2.5),
            )
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SafeArea(
                      child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/images/loginBack.jpg"),
              fit: BoxFit.cover,
            ),),
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 50.0),
                CircleAvatar(
                  backgroundImage: AssetImage("assets/images/usergreen.jpg"),
                  radius: 50,
                ),
                SizedBox(height: 30,),
                      
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val)
                                    ? null
                                    : "Please Enter Correct Email";
                              },
                              controller: emailEditingController,
                              style: simpleTextStyle(),
                              decoration: textFieldInputDecoration("email"),
                            ),
                            TextFormField(
                              obscureText: true,
                              validator: (val) {
                                return val.length > 6
                                    ? null
                                    : "Enter Password 6+ characters";
                              },
                              style: simpleTextStyle(),
                              controller: passwordEditingController,
                              decoration: textFieldInputDecoration("password"),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgotPassword()));
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Text(
                                  "Forgot Password?",
                                  style: simpleTextStyle(),
                                )),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          signIn();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white
                              ),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Login",
                            
                            style: TextStyle(color: Colors.black,fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have account? ",
                            style: simpleTextStyle(),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggleView();
                            },
                            child: Text(
                              "Register now",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
              ),
          ),
            floatingActionButton: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 30),
          child: FloatingActionButton(
            onPressed: () {
                widget.toggleView();
            },
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle, // circular shape
                gradient: LinearGradient(
                  colors: [Color.fromRGBO(25, 146, 155, 1), Colors.teal[900]],
                ),
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 50,
              ),
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      // ),
    );
    
  }
}
