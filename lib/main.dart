import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rollebased/Admin/addmin_delete_account/admin_delete_account_homepage.dart';
import 'package:rollebased/Client/client_tab_screen.dart';
import 'package:rollebased/Client/client_add_faults.dart';
import 'package:rollebased/Client/client_requested.dart';
import 'package:rollebased/Client/client_view_status.dart';
import 'package:rollebased/Client/client_pending.dart';
import 'package:rollebased/Client/client_completed.dart';
import 'package:rollebased/Technician/technician_tab_screen.dart';
import 'package:rollebased/Technician/technician_pending.dart';
import 'package:rollebased/Technician/technician_completed.dart';
import 'package:rollebased/Admin/admin_add_account.dart';
import 'package:rollebased/Admin/admin_tab_screen.dart';
import 'package:rollebased/Admin/admin_requested.dart';
import 'package:rollebased/Admin/admin_pending.dart';
import 'package:rollebased/Admin/admin_completed.dart';
import 'package:rollebased/chat/chat_page.dart';
import 'package:rollebased/session_listener.dart';
import 'login.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Make status bar transparent
      statusBarIconBrightness: Brightness.light,
    ),
  );

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
      home: SessionTimeOutListener(
          duration: Duration(seconds: 60),
          onTimeOut: () {
            print('timeout');
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => LoginScreen()),
            // );
          },
          child: LoginScreen()),
      routes: {
        TechnicianTabScreen.routeName: (context) => TechnicianTabScreen(),
        TechnicianPendingDetailsScreen.routeName: (context) =>
            TechnicianPendingDetailsScreen(),
        TechnicianCompletedDetailsScreen.routeName: (context) =>
            TechnicianCompletedDetailsScreen(),
        ClientTabScreen.routeName: (context) => ClientTabScreen(),
        ClientAddFaultScreen.routeName: (context) => ClientAddFaultScreen(),
        ClientRequestedDetails.routeName: (context) => ClientRequestedDetails(),
        ClientPendingDetailsScreen.routeName: (context) =>
            ClientPendingDetailsScreen(),
        ClientCompletedDetailsScreen.routeName: (context) =>
            ClientCompletedDetailsScreen(),
        ViewStatus.routeName: (context) => ViewStatus(),
        AdminAddAccount.routeName: (context) => AdminAddAccount(),
        AdminTabScreen.routeName: (context) => AdminTabScreen(),
        AdminRequestedDetailsScreen.routeName: (context) =>
            AdminRequestedDetailsScreen(),
        AdminPendingDetailsScreen.routeName: (context) =>
            AdminPendingDetailsScreen(),
        AdminCompletedDetailsScreen.routeName: (context) =>
            AdminCompletedDetailsScreen(),
        AdminDeleteAccountHomePage.routeName: (context) =>
            AdminDeleteAccountHomePage(),
        ChatPage.routeName: (context) =>
            ChatPage(receiveruserFullName: '', receiverUserID: ''),
      },
    );
  }
}
