import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../login.dart';
// import 'model.dart';

class AdminAddAccount extends StatefulWidget {
  static const routeName = '/admin_add_account';
  @override
  _AdminAddAccountState createState() => _AdminAddAccountState();
}

class _AdminAddAccountState extends State<AdminAddAccount> {
  _AdminAddAccountState();

  bool showProgress = false;
  bool visible = false;

  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController confirmpassController =
      new TextEditingController();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController officeNumberControllere =
      new TextEditingController();
  final TextEditingController phoneNumber = new TextEditingController();
  bool _isObscure = true;
  bool _isObscure2 = true;
  File? file;
  var options = [
    'Client',
    'Admin',
    'Technician',
  ];
  var _currentItemSelected = "Client";
  var rool = "Client";
  var buildingList = [
    'President office',
    'Former president office',
    'Finance office',
    'Registration office',
    'Academic office building',
    'Main store',
    'Police station',
    'Student service office'
  ];
  var _currentSelectedItem = "President office";
  var building = "President office";

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ));
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(),
      child: Scaffold(
        backgroundColor: Colors.orange[900],
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.orange[700],
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(12),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 80,
                          ),
                          Text(
                            "Create Account",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 40,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Full Name',
                              enabled: true,
                              contentPadding: const EdgeInsets.only(
                                  left: 14.0, bottom: 8.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.white),
                                borderRadius: new BorderRadius.circular(20),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: new BorderSide(color: Colors.white),
                                borderRadius: new BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Email',
                              enabled: true,
                              contentPadding: const EdgeInsets.only(
                                  left: 14.0, bottom: 8.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.white),
                                borderRadius: new BorderRadius.circular(20),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: new BorderSide(color: Colors.white),
                                borderRadius: new BorderRadius.circular(20),
                              ),
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
                            onChanged: (value) {},
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            obscureText: _isObscure,
                            controller: passwordController,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  icon: Icon(_isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  }),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Password',
                              enabled: true,
                              contentPadding: const EdgeInsets.only(
                                  left: 14.0, bottom: 8.0, top: 15.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.white),
                                borderRadius: new BorderRadius.circular(20),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: new BorderSide(color: Colors.white),
                                borderRadius: new BorderRadius.circular(20),
                              ),
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
                            onChanged: (value) {},
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            obscureText: _isObscure2,
                            controller: confirmpassController,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  icon: Icon(_isObscure2
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure2 = !_isObscure2;
                                    });
                                  }),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Confirm Password',
                              enabled: true,
                              contentPadding: const EdgeInsets.only(
                                  left: 14.0, bottom: 8.0, top: 15.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.white),
                                borderRadius: new BorderRadius.circular(20),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: new BorderSide(color: Colors.white),
                                borderRadius: new BorderRadius.circular(20),
                              ),
                            ),
                            validator: (value) {
                              if (confirmpassController.text !=
                                  passwordController.text) {
                                return "Password did not match";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {},
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Choose Office Building  : ",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    DropdownButton<String>(
                                      dropdownColor: Colors.white,
                                      isDense: true,
                                      isExpanded: false,
                                      iconEnabledColor: Colors.white,
                                      focusColor: Colors.white,
                                      items: buildingList
                                          .map((String dropDownStringItem) {
                                        return DropdownMenuItem<String>(
                                          value: dropDownStringItem,
                                          child: Text(
                                            dropDownStringItem,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (newValueSelected) {
                                        setState(() {
                                          _currentSelectedItem =
                                              newValueSelected!;
                                          building = newValueSelected;
                                        });
                                      },
                                      value: _currentSelectedItem,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: officeNumberControllere,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Office Number',
                              enabled: true,
                              contentPadding: const EdgeInsets.only(
                                  left: 14.0, bottom: 8.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.white),
                                borderRadius: new BorderRadius.circular(20),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: new BorderSide(color: Colors.white),
                                borderRadius: new BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: phoneNumber,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'phoneNumber',
                              enabled: true,
                              contentPadding: const EdgeInsets.only(
                                  left: 14.0, bottom: 8.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.white),
                                borderRadius: new BorderRadius.circular(20),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: new BorderSide(color: Colors.white),
                                borderRadius: new BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Role : ",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              DropdownButton<String>(
                                dropdownColor: Colors.blue[900],
                                isDense: true,
                                isExpanded: false,
                                iconEnabledColor: Colors.white,
                                focusColor: Colors.white,
                                items: options.map((String dropDownStringItem) {
                                  return DropdownMenuItem<String>(
                                    value: dropDownStringItem,
                                    child: Text(
                                      dropDownStringItem,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValueSelected) {
                                  setState(() {
                                    _currentItemSelected = newValueSelected!;
                                    rool = newValueSelected;
                                  });
                                },
                                value: _currentItemSelected,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(20.0))),
                                elevation: 5.0,
                                height: 40,
                                onPressed: () {
                                  setState(() {
                                    showProgress = true;
                                  });
                                  signUp(
                                      nameController.text,
                                      emailController.text,
                                      passwordController.text,
                                      building,
                                      officeNumberControllere.text,
                                      phoneNumber.text,
                                      rool);
                                },
                                child: Text(
                                  "Create Account",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                color: Colors.white,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signUp(String name, String email, String password, String building,
      String officeNumber, String phoneNumber, String rool) async {
    CircularProgressIndicator();
    if (_formkey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                postDetailsToFirestore(
                    name, email, building, officeNumber, phoneNumber, rool)
              })
          .catchError((e) {});
    }
  }

  postDetailsToFirestore(String name, String email, String building,
      String officeNumber, String phoneNumber, String rool) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    if (rool == "Client") {
      FirebaseFirestore.instance.collection("Clients").doc(user!.uid).set({
        'clientId': user.uid,
        'rool': rool,
        'clientFullName': name,
        'email': emailController.text,
        'OfficeBuilding': building,
        'OfficeNumber': officeNumberControllere.text,
        'phoneNumber': phoneNumber,
      });
    } else if (rool == "Technician") {
      FirebaseFirestore.instance.collection("Technicians").doc(user!.uid).set({
        'technicianId': user.uid,
        'rool': rool,
        'techFullName': name,
        'email': emailController.text,
        'OfficeBuilding': building,
        'OfficeNumber': officeNumberControllere.text,
        'phoneNumber': phoneNumber,
        'isAvailabile': true,
      });
    } else {
      FirebaseFirestore.instance.collection("Admins").doc(user!.uid).set({
        'adminId': user.uid,
        'rool': rool,
        'name': name,
        'email': emailController.text,
        'OfficeBuilding': building,
        'OfficeNumber': officeNumberControllere.text,
        'phoneNumber': phoneNumber,
      });
    }
    showSuccessSnackBar(context);
    // Navigator.pop(context);
    // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //   content: Text('Account Created Successfully'),
    // ));
  }
}

void showSuccessSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Account Created Successfully'),
    ),
  );
}

void closeCurrentScreen(BuildContext context) {
  Navigator.pop(context);
}
