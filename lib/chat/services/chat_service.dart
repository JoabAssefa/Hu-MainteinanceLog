import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rollebased/chat/model/message.dart';

class ChatService extends ChangeNotifier {
  //get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  // send message
  Future<void> sendMessage(String receiverId, String message) async {
    // get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    String currentUserFullName = '';
    // Fetch currentUserFullName from Firestore based on conditions
    await _fireStore
        .collection('faults')
        .where('status', isEqualTo: 'Pending')
        .where(
          _firebaseAuth.currentUser!.uid == 'techId' ? 'techId' : 'clientId',
          isEqualTo: _firebaseAuth.currentUser!.uid,
        )
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic> data =
            snapshot.docs.first.data() as Map<String, dynamic>;
        String techId = data['techId'];
        String clientId = data['clientId'];
        if (techId == currentUserId) {
          currentUserFullName = data['techFullName'];
        } else if (clientId == currentUserId) {
          currentUserFullName = data['clientFullName'];
        }
      }
    });

    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
      senderId: currentUserId,
      senderFullName: currentUserFullName,
      receiverId: receiverId,
      timestamp: timestamp,
      message: message,
    );
    //construct chat room ud frin current user id and receiver id (sorted to ensure uniquness)
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); // sort the ids (this ensures the chat room id is always the same for the pair of users)
    String chatRoomId = ids.join(
        "_"); // combine the ids into a single strings to use as a chatroomId

    //add new message to database
    await _fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  //get message
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    // construct chat room id from user ids (sortedd to ensure it matches the id when sending messages)
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
