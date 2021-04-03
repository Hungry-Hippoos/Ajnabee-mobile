import 'package:memechat/helper/helperfunctions.dart';
import 'package:memechat/helper/theme.dart';
import 'package:memechat/services/auth.dart';
import 'package:memechat/services/database.dart';
import 'package:memechat/views/chatrooms.dart';
import 'package:memechat/widget/widget.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp(this.toggleView);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController usernameEditingController =
      new TextEditingController();

  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  singUp() async {

    if(formKey.currentState.validate()){
      setState(() {

        isLoading = true;
      });

      await authService.signUpWithEmailAndPassword(emailEditingController.text,
          passwordEditingController.text).then((result){
            if(result != null){

              Map<String,String> userDataMap = {
                "userName" : usernameEditingController.text,
                "userEmail" : emailEditingController.text
              };

              databaseMethods.addUserInfo(userDataMap);

              HelperFunctions.saveUserLoggedInSharedPreference(true);
              HelperFunctions.saveUserNameSharedPreference(usernameEditingController.text);
              HelperFunctions.saveUserEmailSharedPreference(emailEditingController.text);

              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => ChatRoom()
              ));
            }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF35629E),
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
      body: isLoading ? Container(child: Center(child: CircularProgressIndicator(),),) :  SafeArea(
              child: Container(
          padding: EdgeInsets.all( 20),
          decoration:  BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/signUpBack.jpg"),
            fit: BoxFit.cover,
          )),
          child: Column(
            children: [
             SizedBox(height: 50.0),
                CircleAvatar(
                  backgroundImage: AssetImage("assets/images/userlogo.jpg"),
                  radius: 50.0,
                ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        style: simpleTextStyle(),
                        controller: usernameEditingController,
                        validator: (val){
                          return val.isEmpty || val.length < 3 ? "Enter Username 3+ characters" : null;
                        },
                        decoration: textFieldInputDecoration("username"),
                      ),
                      TextFormField(
                        controller: emailEditingController,
                        style: simpleTextStyle(),
                        validator: (val){
                          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                              null : "Enter correct email";
                        },
                        decoration: textFieldInputDecoration("email"),
                      ),
                      TextFormField(
                        obscureText: true,
                        style: simpleTextStyle(),
                        decoration: textFieldInputDecoration("password"),
                        controller: passwordEditingController,
                        validator:  (val){
                          return val.length < 6 ? "Enter Password 6+ characters" : null;
                        },

                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: (){
                  singUp();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    color: Colors.white),
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    "Sign Up",
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
                    "Already have an account? ",
                    style: simpleTextStyle(),
                  ),
                  GestureDetector(
                    onTap: () {
                      widget.toggleView();
                    },
                    child: Text(
                      "SignIn now",
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
    );
    ;
  }
}
