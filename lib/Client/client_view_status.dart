import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pandabar/main.view.dart';
import 'package:pandabar/pandabar.dart';
import 'package:rollebased/chat/chat_home_page.dart';
import 'package:rollebased/session_listener.dart';
import 'client_requested.dart';
import 'client_pending.dart';
import 'client_completed.dart';
import '../login.dart';

class ViewStatus extends StatefulWidget {
  static const routeName = '/client_view_status';
  @override
  _ViewStatusState createState() => _ViewStatusState();
}

class _ViewStatusState extends State<ViewStatus> {
  final formKey = GlobalKey<FormState>();
  String page = 'Blue';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    final cId = args['clientId'] as String;

    return Scaffold(
      appBar: AppBar(
        title: Text("Status Log"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      extendBody: true,
      bottomNavigationBar: PandaBar(
        buttonData: [
          PandaBarButtonData(
            id: 'Blue',
            icon: Icons.pending_actions,
            title: 'Requested',
          ),
          PandaBarButtonData(
              id: 'Green', icon: Icons.pending, title: 'Pending'),
          PandaBarButtonData(
              id: 'Red', icon: Icons.check_box_outlined, title: 'Completed'),
          PandaBarButtonData(
              id: 'Yellow', icon: Icons.message, title: 'Message'),
        ],
        onChange: (id) {
          setState(() {
            page = id;
          });
        },
        fabIcon: null,
        onFabButtonPressed: () {
          // showCupertinoDialog(
          //     context: context,
          //     builder: (context) {
          //       return CupertinoAlertDialog(
          //         content: Text('Fab Button Pressed!'),
          //         actions: <Widget>[
          //           CupertinoDialogAction(
          //             child: Text('Close'),
          //             isDestructiveAction: true,
          //             onPressed: () {
          //               Navigator.pop(context);
          //             },
          //           )
          //         ],
          //       );
          //     });
        },
      ),
      body: Builder(
        builder: (context) {
          switch (page) {
            case 'Green':
              return ClientPending(cId);
            case 'Blue':
              return ClientRequested(cId);
            case 'Red':
              return ClientCompleted(cId);
            case 'Yellow':
              return ChatHomePage();
            default:
              return Container();
          }
        },
      ),
    );
  }
}

Future<void> logout(BuildContext context) async {
  CircularProgressIndicator();
  await FirebaseAuth.instance.signOut();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => LoginScreen(),
    ),
  );
}
