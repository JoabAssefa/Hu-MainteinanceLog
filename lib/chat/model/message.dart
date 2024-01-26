import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Message {
  final String senderId;
  final String senderFullName;
  final String receiverId;
  final String message;
  final Timestamp timestamp;

  Message(
      {required this.senderId,
      required this.senderFullName,
      required this.receiverId,
      required this.timestamp,
      required this.message});

  //convert to a map
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderFullName': senderFullName,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
