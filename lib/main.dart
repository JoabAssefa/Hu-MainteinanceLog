import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rollebased/Client/client_tab_screen.dart';
import 'package:rollebased/Client/client_add_faults.dart';
import 'package:rollebased/Technician/technician_tab_screen.dart';
import 'package:rollebased/Admin/admin_add_account.dart';
import 'package:rollebased/Admin/admin_tab_screen.dart';
import 'login.dart';

import 'Admin/admin_add_account.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue[900],
      ),
      home: LoginScreen(),
      routes: {
        TechnicianTabScreen.routeName: (context) => TechnicianTabScreen(),
        ClientTabScreen.routeName: (context) => ClientTabScreen(),
        ClientAddFaultScreen.routeName: (context) => ClientAddFaultScreen(),
        AdminAddAccount.routeName: (context) => AdminAddAccount(),
        AdminTabScreen.routeName: (context) => AdminTabScreen(),
      },
    );
  }
}
