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
                            ),
                            Text(
                              'No. of Damaged Devices: ${snapshot.data!.docs[index]['numOfDamagedDevice']}',
                            ),
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

    if (availableTechnicians.isNotEmpty) {
      _selectedTechnician = availableTechnicians[0];
    } else {
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
      DropdownButton<String>(
        borderRadius: BorderRadius.circular(15),
        hint: const Text('Choose a Technician'),
        value: _selectedTechnician,
        items: availableTechnicians.map((String valuex) {
          return DropdownMenuItem<String>(
            value: valuex,
            child: Text(
              valuex,
              style: const TextStyle(fontSize: 14),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _selectedTechnician = value.toString();
          });
        },
        isExpanded: true,
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
                    const Text('Requested by:'),
                    const SizedBox(
                      width: 5,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        color: Colors.blue,
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
                    const Text('No. Damaged Devices:'),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(numOfDamagedDevices ?? 'Default Value'),
                  ],
                ),
                Row(
                  children: [
                    const Text('Damaged Devices:'),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(DamagedDevces),
                  ],
                ),
                Row(
                  children: [
                    const Text('OfficeBuilding:'),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 100,
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        OfficeBuilding,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Requestee Phone Number:'),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(PhoneNumber),
                  ],
                ),
                Row(
                  children: [
                    const Text('Status:'),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(status),
                  ],
                ),
                Row(
                  children: [
                    const Text('Logged on:'),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      loggedOn,
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('OfficeNumber :'),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(OfficeNumber),
                  ],
                ),
                ...getFormWidget(availableTechnicians),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        String? trimmed = _selectedTechnician;

                        if (trimmed == '-- Select Technician --') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.redAccent,
                              content: Text(
                                'Select Technician',
                              ),
                            ),
                          );
                        } else {
                          approveRequest(
                            context: context,
                            faultId: faultId,
                            techFName: trimmed,
                          );
                        }
                      },
                      child: const Text(
                        'Approve',
                        style: TextStyle(
                          color: Colors.green,
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
