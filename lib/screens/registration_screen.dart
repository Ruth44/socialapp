import 'package:flutter/material.dart';
import 'package:testt/component/RoundedButton.dart';
import 'package:testt/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testt/screens/chat_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {

  static String id='register';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
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
              //  obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
               password=value;
                },
                decoration: kInputTextDecoration.copyWith(
                hintText: 'Enter your password',
              ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  Color.fromRGBO(0, 86, 201, 1),
                      'Register',
                    () async {
                    setState(() {
                      spinning=true;
                    });
                      try {
                        final newUser = await _auth
                            .createUserWithEmailAndPassword(
                            email: email,
                            password: password);
                        if(newUser!=null){
                          Navigator.pushNamed(context, ChatScreen.id);
                        }
                        setState(() {
                          spinning=false;
                        });
                      }
                      catch (e) {
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
