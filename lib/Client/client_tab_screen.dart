import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rollebased/session_listener.dart';
import 'client_add_faults.dart';
import 'client_view_status.dart';

import '../login.dart';

class ClientTabScreen extends StatefulWidget {
  const ClientTabScreen({super.key});
  static const routeName = '/client_tab_screen';

  @override
  State<ClientTabScreen> createState() => _ClientTabScreenState();
}

class _ClientTabScreenState extends State<ClientTabScreen> {
  late Color myColor;
  late Size mediaSize;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ));
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final cId = args['clientId'] as String;
    final cFullName = args['clientFullName'] as String;
    final cOfficeBuilding = args['OfficeBuilding'] as String;
    final cphoneNumber = args['phoneNumber'] as String;
    final cOfficeNumber = args['OfficeNumber'] as String;

    myColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(),
      child: Scaffold(
          body: Container(
        decoration: BoxDecoration(
          color: myColor,
          image: DecorationImage(
            image: const AssetImage('assets/image/HU012230.jpg'),
            fit: BoxFit.cover,
            colorFilter:
                ColorFilter.mode(myColor.withOpacity(0.3), BlendMode.dstATop),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(children: [
            Positioned(top: 80, child: _buildTop()),
            Positioned(
                bottom: 0,
                child: SizedBox(
                  width: mediaSize.width,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome to HU maintenance log",
                            style: TextStyle(
                                color: myColor,
                                fontSize: 32,
                                fontWeight: FontWeight.w500),
                          ),
                          _buildGreyText("Please what can we help you?"),
                          const SizedBox(height: 10),
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(
                                  color: Color.fromARGB(255, 4, 0, 17),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  ClientAddFaultScreen.routeName,
                                  arguments: {
                                    'clientId': cId,
                                    'OfficeBuilding': cOfficeBuilding,
                                    'OfficeNumber': cOfficeNumber,
                                    'PhoneNumber': cphoneNumber,
                                    'clientFullName': cFullName
                                  });
                            },
                            child: Row(children: [
                              Icon(Icons.settings_input_component),
                              Text(' Request Maintence',
                                  style: TextStyle(
                                      color: myColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ]),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(
                                  color: Color.fromARGB(255, 0, 10, 19),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(ViewStatus.routeName, arguments: {
                                'clientId': cId,
                              });
                            },
                            child: Row(children: [
                              Icon(Icons.phonelink_ring_rounded),
                              Text(' View Status',
                                  style: TextStyle(
                                      color: myColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: Icon(Icons.logout, color: Colors.white),
                onPressed: () => logout(context),
              ),
            )
          ]),
        ),
      )),
    );
  }

  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person_2_sharp,
            size: 100,
            color: Colors.white,
          ),
          Text(
            'Client',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 40,
                letterSpacing: 2),
          )
        ],
      ),
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey),
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
