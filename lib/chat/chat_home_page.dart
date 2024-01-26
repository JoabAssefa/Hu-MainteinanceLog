import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rollebased/chat/chat_page.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({super.key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  //instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
            child: Text(
          'Chat Page',
          style: TextStyle(color: Colors.white),
        )),
        backgroundColor: Colors.orange,
      ),
      body: _buildUserList(),
    );
  }

  //build a List of users except for the user logged in user logged in users
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('faults')
          .where(
            'status',
            isEqualTo: 'Pending',
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }
        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  //build individual user list items
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    // display all users except current user
    if (_auth.currentUser!.uid == data['clientId']) {
      return ListTile(
        title: Text(data['techFullName']),
        onTap: () {
          //pass the clicked user's UID to the chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiveruserFullName: data['techFullName'],
                receiverUserID: data['techId'],
              ),
            ),
          );
        },
      );
    } else if (_auth.currentUser!.uid == data['techId']) {
      return ListTile(
        title: Text(data['clientFullName']),
        onTap: () {
          //pass the clicked user's UID to the chat page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiveruserFullName: data['clientFullName'],
                receiverUserID: data['clientId'],
              ),
            ),
          );
        },
      );
    } else {
      //return black container
      return Container();
    }
  }
}
