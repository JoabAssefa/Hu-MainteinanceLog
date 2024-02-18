import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pandabar/main.view.dart';
import 'package:pandabar/pandabar.dart';
import 'package:rollebased/Technician/technician_pending.dart';
import 'package:rollebased/Technician/technician_completed.dart';
import 'package:rollebased/chat/chat_home_page.dart';

import '../login.dart';

class TechnicianTabScreen extends StatefulWidget {
  static const routeName = '/technician_tab_screen';
  @override
  _TechnicianTabScreenState createState() => _TechnicianTabScreenState();
}

class _TechnicianTabScreenState extends State<TechnicianTabScreen> {
  String page = 'Blue';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    final techId = args['technicianId'] as String;
    return Scaffold(
      appBar: AppBar(
        title: Text("Technician"),
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
      bottomNavigationBar: PandaBar(
        buttonData: [
          PandaBarButtonData(id: 'Blue', icon: Icons.pending, title: 'Pending'),
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
            case 'Blue':
              return TechnicianPending(techId);
            case 'Red':
              return TechnicianCompleted(techId);
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
