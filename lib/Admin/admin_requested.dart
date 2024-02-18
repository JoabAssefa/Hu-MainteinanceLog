import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AdminRequested extends StatefulWidget {
  @override
  State<AdminRequested> createState() => _AdminRequestedState();
}

class _AdminRequestedState extends State<AdminRequested> {
  List<String> availableTechnicians = [];
  @override
  @override
  void initState() {
    super.initState();
    fetchAvailableTechnicians();
  }

  void fetchAvailableTechnicians() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('Technicians')
          .where('isAvailabile', isEqualTo: true)
          .get();

      setState(() {
        availableTechnicians = snapshot.docs
            .map((element) => element['techFullName'] as String)
            .toList();
      });
    } catch (error) {
      print('Error fetching technicians: $error');
    }
  }

  void showDetails(
      BuildContext ctx,
      String faultId,
      String cId,
      String cFName,
      String numOfDamagedDevice,
      List<dynamic> DamagedDevces,
      String OfficeBuilding,
      String OfficeNumber,
      String PhoneNumber,
      String status,
      String loggedDate) {
    // ...
    Navigator.of(ctx).pushNamed(
      AdminRequestedDetailsScreen.routeName,
      arguments: {
        'faultId': faultId,
        'clientId': cId,
        'clientFName': cFName,
        'numOfDamagedDevices': numOfDamagedDevice,
        'DamagedDevces': DamagedDevces.join(', '),
        'OfficeBuilding': OfficeBuilding,
        'OfficeNumber': OfficeNumber,
        'PhoneNumber': PhoneNumber,
        'status': status,
        'loggedOn': loggedDate,
        'availableTechnicians': availableTechnicians,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Container(
      padding: const EdgeInsets.all(10),
      height: mediaQuery.size.height - mediaQuery.padding.top,
      width: double.infinity,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('faults')
            .where('status', isEqualTo: 'Delayed')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            Fluttertoast.showToast(msg: 'Loading');
          }
          if (snapshot.hasError) {
            Fluttertoast.showToast(
              msg: 'An error occurred!',
              backgroundColor: Colors.redAccent,
            );
          }
          return !snapshot.hasData
              ? const Center(
                  child: Text('No new faults found!'),
                )
              : ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (c, index) {
                    // snapshot.data!.docs[index]['fieldName'];
                    return Card(
                      color: Colors.orange,
                      elevation: 5,
                      child: ListTile(
                        onTap: () => showDetails(
                          context,
                          snapshot.data!.docs[index]['faultId'],
                          snapshot.data!.docs[index]['clientId'],
                          snapshot.data!.docs[index]['clientFullName'],
                          snapshot.data!.docs[index]['numOfDamagedDevice'],
                          snapshot.data!.docs[index]['DamagedDevces'],
                          snapshot.data!.docs[index]['OfficeBuilding'],
                          snapshot.data!.docs[index]['OfficeNumber'],
                          snapshot.data!.docs[index]['PhoneNumber'],
                          snapshot.data!.docs[index]['status'],
                          snapshot.data!.docs[index]['loggedOn'],
                        ),
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Requested by: ${snapshot.data!.docs[index]['clientFullName']}',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                                'No. of Damaged Devices: ${snapshot.data!.docs[index]['numOfDamagedDevice']}',
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    );
                  });
        },
      ),
    );
  }
}

class AdminRequestedDetailsScreen extends StatefulWidget {
  static const routeName = '/admin_requested_details_screen';

  @override
  State<AdminRequestedDetailsScreen> createState() =>
      _AdminRequestedDetailsScreenState();
}

class _AdminRequestedDetailsScreenState
    extends State<AdminRequestedDetailsScreen> {
  String? _selectedTechnician;
  String techId = '';

  List<Widget> getFormWidget(List<String> availableTechnicians) {
    List<Widget> formWidget = [];

    if (availableTechnicians.isEmpty) {
      _selectedTechnician = '-- Select Technician --';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              'No available Technicians',
            ),
            duration: Duration(seconds: 5),
          ),
        );
      });
    }

    formWidget.add(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Shadow color
              spreadRadius: 2, // Spread radius
              blurRadius: 5, // Blur radius
              offset: Offset(0, 3), // Offset of the shadow
            ),
          ],
        ),
        child: DropdownButton<String>(
          dropdownColor: Colors.white,
          focusColor: Colors.white,
          hint: const Text(
            'Choose a Technician',
            style: TextStyle(color: Colors.black),
          ),
          value: _selectedTechnician,
          items: availableTechnicians.map((String valuex) {
            return DropdownMenuItem<String>(
              value: valuex,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  valuex,
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedTechnician = value.toString();
            });
          },
          isExpanded: true,
          icon: Icon(Icons.arrow_drop_down,
              color: Colors.black), // Change dropdown icon color
          underline: SizedBox.shrink(), // Remove default underline
        ),
      ),
    );
    formWidget.add(
      const SizedBox(
        height: 10,
      ),
    );
    return formWidget;
  }

  void approveRequest({
    required BuildContext context,
    required String faultId,
    required String? techFName,
  }) {
    // ...
    var isAvailabile = true;

    try {
      // -- Gets the technician id --

      FirebaseFirestore.instance
          .collection('Technicians')
          .where('techFullName', isEqualTo: techFName)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          techId = element['technicianId'] as String;

          isAvailabile = false;

          //////////////////////////////////////////////////////////////////////

          FirebaseFirestore.instance.collection('faults').doc(faultId).update(
            {
              'approvedOn':
                  DateFormat('dd-MMM-yyyy hh:mm aaa').format(DateTime.now()),
              'techId': techId,
              'status': 'Pending',
              'techFullName': techFName,
            },
          ).then((value) {
            FirebaseFirestore.instance
                .collection('Technicians')
                .doc(techId)
                .update({
                  'isAvailabile': isAvailabile,
                })
                .then(
                  (value) {},
                )
                .catchError(
                  (err) {},
                );

            // -- Navigate to DelayedScreen--
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.blueAccent,
                content: Text(
                  'Request Approved!',
                ),
              ),
            );
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.redAccent,
                content: Text(
                  'Failed to approve request!',
                ),
              ),
            );
          });

          /////////////////////////////////////////////////////////////////////
        });
      }).catchError((err) {
        return;
      });

      // -- Updates the fault status --
    } on PlatformException catch (err) {
      var message = 'An error occured, please check your inputs';

      if (err.message != null) {
        message = err.message as String;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.redAccent,
        ),
      );
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err.toString()),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, Object>;

    final faultId = args['faultId'] as String;
    final cId = args['clientId'] as String;
    final cFullName = args['clientFName'] as String;
    final numOfDamagedDevices = args['numOfDamagedDevices'] as String?;
    final DamagedDevces = args['DamagedDevces'] as String;
    final OfficeBuilding = args['OfficeBuilding'] as String;
    final OfficeNumber = args['OfficeNumber'] as String;
    final PhoneNumber = args['PhoneNumber'] as String;
    final status = args['status'] as String;
    final loggedOn = args['loggedOn'] as String;
    final availableTechnicians = args['availableTechnicians'] as List<String>;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Details',
        ),
      ),
      body: SingleChildScrollView(
        child: Card(
          color: Colors.orange,
          margin: const EdgeInsets.all(10),
          elevation: 5,
          child: Container(
            height: 500,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    const Text('Requested by:',
                        style: TextStyle(color: Colors.white)),
                    const SizedBox(
                      width: 5,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        color: Colors.black,
                        child: Text(
                          cFullName,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('No. Damaged Devices:',
                        style: TextStyle(color: Colors.white)),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(numOfDamagedDevices ?? 'Default Value',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
                Row(
                  children: [
                    const Text('Damaged Devices:',
                        style: TextStyle(color: Colors.white)),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(DamagedDevces, style: TextStyle(color: Colors.white)),
                  ],
                ),
                Row(
                  children: [
                    const Text('OfficeBuilding:',
                        style: TextStyle(color: Colors.white)),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 100,
                      padding: const EdgeInsets.all(5),
                      child: Text(OfficeBuilding,
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Requestee Phone Number:',
                        style: TextStyle(color: Colors.white)),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(PhoneNumber, style: TextStyle(color: Colors.white)),
                  ],
                ),
                Row(
                  children: [
                    const Text('Status:',
                        style: TextStyle(color: Colors.white)),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(status, style: TextStyle(color: Colors.white)),
                  ],
                ),
                Row(
                  children: [
                    const Text('Logged on:',
                        style: TextStyle(color: Colors.white)),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(loggedOn, style: TextStyle(color: Colors.white)),
                  ],
                ),
                Row(
                  children: [
                    const Text('OfficeNumber :',
                        style: TextStyle(color: Colors.white)),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(OfficeNumber, style: TextStyle(color: Colors.white)),
                  ],
                ),
                ...getFormWidget(availableTechnicians),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        approveRequest(
                          context: context,
                          faultId: faultId,
                          techFName: _selectedTechnician,
                        );
                      },
                      child: const Text(
                        'Approve',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
