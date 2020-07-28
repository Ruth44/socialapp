import 'package:testt/constants.dart';
import 'package:flutter/material.dart';
import 'package:testt/component/RoundedButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testt/screens/chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
class LoginScreen extends StatefulWidget {
 static String id='login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth=FirebaseAuth.instance;
  String email,password;
  bool spinning=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: spinning,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo2.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email=value;
                },
                decoration: kInputTextDecoration.copyWith(
                    hintText: 'Enter your email',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                 password=value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your password.',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.lightBlue, width: 1.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.lightBlue, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                  ),
                ),
              ),


              RoundedButton(
                Color.fromRGBO(73, 183, 251, 1),
                  'Log In',
                    ()async {
                  setState(() {
                    spinning=true;
                  });

                  try{
                  final checkUsr= await _auth.signInWithEmailAndPassword(
                      email: email,
                      password: password);
                  if(checkUsr!=null){
                    Navigator.pushNamed(context, ChatScreen.id);
                  }
                  setState(() {
                    spinning=false;
                  });
                  }
                    catch(e){
                    print(e);
                      }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
