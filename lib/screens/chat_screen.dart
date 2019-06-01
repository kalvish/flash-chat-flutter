import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;
  FirebaseUser _loggedInUser;
  String messageText;
  final messageTextController = TextEditingController();

  getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        _loggedInUser = user;
        print((user.email));
      }
    } on Exception catch (e) {
      // TODO
      print(e);
    }
  }

//  getMessages() async {
//    final messages = await _firestore.collection('messages').getDocuments();
//    List<DocumentSnapshot> documents = messages.documents;
//    for (var document in documents) {
//      print(document.data);
//    }
//  }
//
//  getStreamMessages() async {
//    await for (var snapshot in _firestore.collection('messages').snapshots()) {
//      List<DocumentSnapshot> documents = snapshot.documents;
//      for (var document in documents) {
//        print(document.data);
//      }
//    }
//  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                //Implement logout functionality
                await _auth.signOut();
                Navigator.pop(context);
////                getMessages();
//                getStreamMessages();
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(
              firestore: _firestore,
              userEmail: _loggedInUser.email,
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      //Implement send functionality.
                      if (_loggedInUser != null) {
                        _firestore.collection('messages').add({
                          'text': messageText,
                          'sender': _loggedInUser.email
                        });
                      } else {
                        print('user is not logged in.');
                      }
                      messageTextController.clear();
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

class MessageStream extends StatelessWidget {
  final String userEmail;
  final firestore;

  MessageStream({this.userEmail, this.firestore});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final documents = snapshot.data.documents.reversed;
        List<MessageBubble> messageWidgets = [];
        for (var document in documents) {
          print(document.data);
          final messageText = document.data['text'];
          final messageSender = document.data['sender'];
          final messageWidget = MessageBubble(
            loggedinUserEmail: userEmail,
            messageSender: messageSender,
            messageText: messageText,
          );
//                      Text('$messageText from $messageSender');
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

class MessageBubble extends StatelessWidget {
  final String loggedinUserEmail;
  final String messageText;
  final String messageSender;
  bool isUser;
  MessageBubble(
      {this.loggedinUserEmail, this.messageSender, this.messageText}) {
    isUser = loggedinUserEmail == messageSender ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: <Widget>[
          Material(
            borderRadius: BorderRadius.only(
                topLeft: isUser ? Radius.circular(0.0) : Radius.circular(25.0),
                topRight: isUser ? Radius.circular(25.0) : Radius.circular(0.0),
                bottomLeft: Radius.circular(25.0),
                bottomRight: Radius.circular(25.0)),
            elevation: 5.0,
            color: isUser ? Colors.white : Colors.lightBlueAccent,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '$messageText',
                    style:
                        TextStyle(color: isUser ? Colors.black : Colors.black),
                  ),
                  Text(
                    '$messageSender',
                    style: TextStyle(color: Colors.teal),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
