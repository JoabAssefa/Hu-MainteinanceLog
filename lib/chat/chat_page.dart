import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rollebased/chat/components/chat_buuble.dart';
import 'package:rollebased/chat/components/my_text_field.dart';
import 'package:rollebased/chat/services/chat_service.dart';

class ChatPage extends StatefulWidget {
  static const routeName = '/chat_page';
  final String receiveruserFullName;
  final String receiverUserID;

  const ChatPage({
    super.key,
    required this.receiveruserFullName,
    required this.receiverUserID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    //only send message if there is something to send
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserID, _messageController.text);
      // clear the text controller after sendign the message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.receiveruserFullName,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.orange,
        ),
        body: Column(
          children: [
            // messages
            Expanded(
              child: _buildMessageList(),
            ),
            // user input
            _buildMessageInput(),

            const SizedBox(
              height: 25,
            )
          ],
        ));
  }

  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.receiverUserID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // align the maessages to the right if the senderis the current user, otherwise to the left
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    // Determine chat bubble color based on sender
    var bubbleColor = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Colors.grey
        : Colors.orange;

    // Determine if the message is from the sender
    var isSender = (data['senderId'] == _firebaseAuth.currentUser!.uid);

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
            crossAxisAlignment:
                (data['senderId'] == _firebaseAuth.currentUser!.uid)
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            children: [
              Text(data['senderFullName']),
              const SizedBox(
                height: 5,
              ),
              ChatBubble(
                message: data['message'],
                bubbleColor: bubbleColor,
                isSender: isSender,
              ),
            ]),
      ),
    );
  }

  // build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          // textfield
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: 'Enter message',
              obscureText: false,
            ),
          ),
          //send button
          IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_upward,
                size: 40,
              ))
        ],
      ),
    );
  }
}
