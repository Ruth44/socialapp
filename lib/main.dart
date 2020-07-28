import 'package:flutter/material.dart';
import 'package:testt/screens/welcome_screen.dart';
import 'package:testt/screens/login_screen.dart';
import 'package:testt/screens/registration_screen.dart';
import 'package:testt/screens/chat_screen.dart';

void main() => runApp(SocialApp());

class SocialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      theme: ThemeData.dark().copyWith(
//        textTheme: TextTheme(
//          body1: TextStyle(color: Colors.black54),
//        ),
 //     ),
      initialRoute: WelcomeScreen.id,
      routes: {

        LoginScreen.id : (context) => LoginScreen(),
        ChatScreen.id: (context) => ChatScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
      },

    );
  }
}
