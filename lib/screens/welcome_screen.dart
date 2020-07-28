

import 'package:testt/screens/login_screen.dart';
import 'package:testt/screens/registration_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testt/component/RoundedButton.dart';


class WelcomeScreen extends StatefulWidget {
  static String id='welcome';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation anim;
  @override
  void initState(){
    super.initState();
    controller=AnimationController(
      duration: Duration (seconds: 1),
      vsync: this,

    );
//    anim=CurvedAnimation(
//      parent: controller,
//      curve: Curves.decelerate,
//    );
    anim=ColorTween(
      begin: Colors.grey,
      end: Colors.white,
    ).animate(controller);

    controller.forward();
    controller.addListener((){
      setState(() {
      });

    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: anim.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(

                  child: Container(
                    child: Image.asset('images/logo2.png'),
                    height: 60,
                  ), tag: 'logo',
                ),
                Text(
                  'SocialApp',
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              Color.fromRGBO(73, 183, 251, 1),
                'Log In',
                  () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
                Color.fromRGBO(0, 86, 201, 1),

                'Register',

               () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}


