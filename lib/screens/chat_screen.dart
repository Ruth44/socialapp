import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testt/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore=Firestore.instance;
class ChatScreen extends StatefulWidget {
 static String id='chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}
FirebaseUser current;
class _ChatScreenState extends State<ChatScreen> {
final textController= TextEditingController();
  final _auth=FirebaseAuth.instance;

  String message;
  @override
  void initState(){
    super.initState();
    getUser();
  }

  getUser() async{
    try{
    final user=await _auth.currentUser();
    if(user!=null){
      current=user;

    }
    }
    catch(e) {
      print(e);
    }
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.lock),
              onPressed: () {
               _auth.signOut();
               Navigator.pop(context);
              }),




        ],
        title: Text('Chat'),
        backgroundColor: Colors.lightBlue,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
          MessageStream() ,
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textController,
                      onChanged: (value) {
                       message=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      textController.clear();
                      _firestore.collection('Messages').add({
                       'text': message,
                        'sender': current.email,
                        'timestamp': DateTime.now()
});
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class MessageBubble extends StatelessWidget {
final bool isMe;
  final String text;
  final String sender;
  final Function delete;
  final Function edit;
  MessageBubble (this.text,this.sender,this.isMe,this.delete,this.edit);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: isMe? CrossAxisAlignment.end: CrossAxisAlignment.start,
        children: <Widget>[
          Text(sender ?? "Unknown",
          style: TextStyle(
            fontSize: 12,
            color:  Colors.black,
          ),),
          Material(
            color:isMe? Colors.lightBlue: Colors.blueGrey,
            borderRadius:isMe? BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight : Radius.circular(10),
            ):
            BorderRadius.only(
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight : Radius.circular(10),
            ),
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 12.0),
              child: Row(
                mainAxisAlignment: isMe? MainAxisAlignment.end: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                      text ?? "Unknown",
                      style: TextStyle(
                      color: Colors.white,
                      fontSize: 15
                    ),
                  ),
              IconButton(
                  icon: Icon(Icons.delete_outline),
                  onPressed: delete,
                color: Colors.white,

                   ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    color: Colors.white,
                    onPressed: edit,
                  ),
    ],
    ),
    ),
    ),
    ],
    ),
    );

  }
}
class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('Messages').orderBy("timestamp", descending: true).snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlue,
            ),
          );
        }
        final messages=snapshot.data.documents;
 

        List<MessageBubble> messageWidgets=[];
        for(var message in messages){
          final txt=message.data['text'];
          final sender=message.data['sender'];

          final currentUser= current.email;
          String newText;
          final messageWidget=MessageBubble(
              txt,sender, currentUser==sender,
              (){
                Firestore.instance.collection("Messages").document(message.documentID).delete();
              },
              (){
                showBottomSheet(
                    context: context,
                    builder: (context) => Container(
                      color: Colors.lightBlue,
                      height: 250,
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Enter New Message",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextField(
                            textAlign: TextAlign.center,
                            onChanged:(value){
                             newText=value;
                            },
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              contentPadding:
                              EdgeInsets.symmetric(vertical: 10.0, horizontal: 70.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.white, width: 1.0),
                                borderRadius: BorderRadius.all(Radius.circular(32.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                BorderSide(color: Colors.white, width: 2.0),
                                borderRadius: BorderRadius.all(Radius.circular(32.0)),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.done,
                              color: Colors.white,
                            ),
                            onPressed: (){
                              Firestore.instance.collection("Messages").document(message.documentID).updateData(
                                {
                                  "text": newText
                                }
                              );
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    ));
              }
          );
          messageWidgets.add(messageWidget);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            children: messageWidgets,

          ),
        );
      },
    );
  }
}

