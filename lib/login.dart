import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rollebased/Client/client_add_faults.dart';
import 'package:rollebased/Client/client_tab_screen.dart';

import 'admin/admin_tab_screen.dart';
// import 'technician/technician_tab_screen.dart';
import 'package:rollebased/Technician/technician_tab_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/';

  const LoginScreen({super.key});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure3 = true;
  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ));
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(),
      child: Stack(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.black, Colors.black12],
              begin: Alignment.bottomCenter,
              end: Alignment.center,
            ).createShader(bounds),
            blendMode: BlendMode.darken,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/image/HU012230.jpg'),
                  fit: BoxFit.cover,
                  colorFilter:
                      ColorFilter.mode(Colors.black45, BlendMode.darken),
                ),
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _logo(),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              Column(children: [
                                SizedBox(height: 60),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          const Color.fromRGBO(117, 117, 117, 1)
                                              .withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: TextFormField(
                                      controller: emailController,
                                      decoration: const InputDecoration(
                                        contentPadding:
                                            EdgeInsets.symmetric(vertical: 12),
                                        border: InputBorder.none,
                                        hintText: 'Email',
                                        hintStyle: TextStyle(
                                          fontSize: 18,
                                          color: Color.fromARGB(
                                              255, 221, 220, 220),
                                        ),
                                        prefixIcon: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Icon(
                                            FontAwesomeIcons.solidEnvelope,
                                            color: Color.fromARGB(
                                                255, 236, 220, 220),
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 221, 220, 220),
                                      ),
                                      validator: (value) {
                                        if (value!.length == 0) {
                                          return "Email cannot be empty";
                                        }
                                        if (!RegExp(
                                                "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                            .hasMatch(value)) {
                                          return ("Please enter a valid email");
                                        } else {
                                          return null;
                                        }
                                      },
                                      onSaved: (value) {
                                        emailController.text = value!;
                                      },
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(
                                            117, 117, 117, 1)
                                        .withOpacity(
                                            0.5), //error the method 'withOpacity'can't be unconditionally invocked because the reciver can be'null'
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: TextFormField(
                                    controller: passwordController,
                                    obscureText: _isObscure3,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                          icon: Icon(
                                            _isObscure3 //error Invalid constant value
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Color.fromARGB(
                                                255, 207, 206, 206),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _isObscure3 = !_isObscure3;
                                            });
                                          }),
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 12),
                                      border: InputBorder.none,
                                      hintText: 'Password',
                                      hintStyle: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Color.fromARGB(255, 221, 220, 220),
                                      ),
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Icon(
                                          FontAwesomeIcons.lock,
                                          color: Color.fromARGB(
                                              255, 236, 220, 220),
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 221, 220, 220),
                                    ),
                                    validator: (value) {
                                      RegExp regex = new RegExp(r'^.{6,}$');
                                      if (value!.isEmpty) {
                                        return "Password cannot be empty";
                                      }
                                      if (!regex.hasMatch(value)) {
                                        return ("please enter valid password min. 6 character");
                                      } else {
                                        return null;
                                      }
                                    },
                                    onSaved: (value) {
                                      passwordController.text = value!;
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                              ]),
                              Column(
                                children: [
                                  SizedBox(height: 100),
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: TextButton(
                                        onPressed: () {
                                          setState(() {
                                            visible = true;
                                          });
                                          signIn(emailController.text,
                                              passwordController.text);
                                        },
                                        child: Text(
                                          'Login',
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: Color.fromARGB(
                                                255, 221, 220, 220),
                                          ),
                                        )),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: visible,
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.all(10),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('Admins')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('rool') == "Admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AdminTabScreen(),
            ),
          );
        }
      }
    });

    FirebaseFirestore.instance
        .collection('Clients')
        .where('clientId', isEqualTo: user.uid)
        .get()
        .then((value) {
      for (var element in value.docs) {
        Navigator.of(context)
            .pushReplacementNamed(ClientTabScreen.routeName, arguments: {
          'clientId': user.uid,
          'clientFullName': element['clientFullName'],
          'OfficeBuilding': element['OfficeBuilding'],
          'OfficeNumber': element['OfficeNumber'],
          'phoneNumber': element['phoneNumber'],
        });
      }
    });

    FirebaseFirestore.instance
        .collection('Technicians')
        .where('technicianId', isEqualTo: user.uid)
        .get()
        .then((value) {
      for (var element in value.docs) {
        Navigator.of(context)
            .pushReplacementNamed(TechnicianTabScreen.routeName, arguments: {
          'technicianId': user.uid,
        });
      }
    });
  }

  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        final userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        route();
      } on FirebaseAuthException catch (e) {
        String errorMessage = '';

        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password.';
        } else {
          errorMessage = 'Error: Wrong Email or Password.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
              style: TextStyle(fontSize: 14, color: Colors.red),
            ),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Widget _logo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 150,
          child: Image.asset('assets/image/logo.png'),
        ),
      ],
    );
  }
}
