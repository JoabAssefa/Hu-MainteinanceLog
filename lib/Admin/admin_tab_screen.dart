// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import 'login.dart';

// class Admin extends StatefulWidget {
//   const Admin({super.key});

//   @override
//   State<Admin> createState() => _AdminState();
// }

// class _AdminState extends State<Admin> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Admin"),
//         backgroundColor: Colors.blue,
//         actions: [
//           IconButton(
//             onPressed: () {
//               logout(context);
//             },
//             icon: Icon(
//               Icons.logout,
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   Future<void> logout(BuildContext context) async {
//     CircularProgressIndicator();
//     await FirebaseAuth.instance.signOut();
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => LoginPage(),
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pandabar/main.view.dart';
import 'package:pandabar/pandabar.dart';
import 'package:rollebased/Admin/admin_add_account.dart';
import '../login.dart';

class AdminTabScreen extends StatefulWidget {
  static const routeName = '/admin_tab_screen';
  @override
  _AdminTabScreenState createState() => _AdminTabScreenState();
}

class _AdminTabScreenState extends State<AdminTabScreen> {
  String page = 'Blue';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin"),
        backgroundColor: Colors.blue,
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
            icon: Icons.dashboard,
            title: 'Requested',
          ),
          PandaBarButtonData(id: 'Green', icon: Icons.book, title: 'Assigned'),
          PandaBarButtonData(
              id: 'Red', icon: Icons.check_box_outlined, title: 'Completed'),
          PandaBarButtonData(
              id: 'Yellow', icon: Icons.settings, title: 'Settings'),
        ],
        onChange: (id) {
          setState(() {
            page = id;
          });
        },
        fabIcon: Icon(Icons.notifications),
        onFabButtonPressed: () {
          showCupertinoDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  content: Text('Fab Button Pressed!'),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text('Close'),
                      isDestructiveAction: true,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                );
              });
        },
      ),
      body: Builder(
        builder: (context) {
          switch (page) {
            case 'Green':
              return Container(color: Colors.green.shade500);
            case 'Blue':
              return Container(color: Colors.blue.shade900);
            case 'Red':
              return Container(color: Colors.red.shade900);
            case 'Yellow':
              return Container(color: Colors.yellow.shade700);
            default:
              return Container();
          }
        },
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
      color: Colors.blue.shade700,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      child: Column(children: [
        CircleAvatar(
          radius: 52,
          backgroundImage: NetworkImage(''),
        ),
        SizedBox(height: 12),
        Text(
          'Logo',
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
            leading: const Icon(Icons.account_box),
            title: const Text('Add account'),
            onTap: () =>
                Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => AdminAddAccount(),
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
