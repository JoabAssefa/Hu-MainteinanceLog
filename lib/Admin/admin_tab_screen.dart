import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pandabar/main.view.dart';
import 'package:pandabar/pandabar.dart';
import 'package:rollebased/Admin/addmin_delete_account/admin_delete_account_homepage.dart';
import 'package:rollebased/Admin/admin_add_account.dart';
import 'package:rollebased/Admin/admin_requested.dart';
import 'package:rollebased/Admin/admin_pending.dart';
import 'package:rollebased/Admin/admin_completed.dart';
import 'package:rollebased/session_listener.dart';
import '../login.dart';
import 'package:flutter/services.dart';

class AdminTabScreen extends StatefulWidget {
  static const routeName = '/admin_tab_screen';
  @override
  _AdminTabScreenState createState() => _AdminTabScreenState();
}

class _AdminTabScreenState extends State<AdminTabScreen> {
  String page = 'Blue';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Make status bar transparent
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return SessionTimeOutListener(
      duration: Duration(seconds: 1200),
      onTimeOut: () {
        print('timeout');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Admin"),
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
        drawer: const NavigationDrawer(),
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
                return AdminPending();
              case 'Blue':
                return AdminRequested();
              case 'Red':
                return AdminCompleted();
              case 'Yellow':
                return Container(color: Colors.yellow.shade700);
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }
}

Widget buildHeader(BuildContext context) => Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/image/HU012230.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      child: Column(children: [
        CircleAvatar(
          radius: 52,
          backgroundImage: Image.asset(
            'assets/image/logo.png',
            fit: BoxFit.cover,
          ).image,
        ),
        SizedBox(height: 12),
        Text(
          'EMMS',
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
      ]),
    );

Widget buildMenuItems(BuildContext context) => Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add account'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AdminAddAccount(),
            )),
          ),
          ListTile(
            leading: const Icon(Icons.delete_rounded),
            title: const Text('Delete accounts'),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AdminDeleteAccountHomePage(),
            )),
          ),
        ],
      ),
    );

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
