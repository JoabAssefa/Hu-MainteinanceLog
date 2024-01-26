import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminCompleted extends StatefulWidget {
  @override
  State<AdminCompleted> createState() => _AdminCompletedState();
}

class _AdminCompletedState extends State<AdminCompleted> {
  void showDetails(
      BuildContext context,
      String cId,
      String cFName,
      String numOfDamagedDevice,
      List<dynamic> DamagedDevces,
      String OfficeBuilding,
      String OfficeNumber,
      String PhoneNumber,
      String status,
      String loggedDate,
      String techId,
      String techFName,
      String approvedOn,
      String repairedOn) {
    // ...
    Navigator.of(context).pushNamed(
      AdminCompletedDetailsScreen.routeName,
      arguments: {
        'clientId': cId,
        'clientFName': cFName,
        'numOfDamagedDevices': numOfDamagedDevice,
        'DamagedDevces': DamagedDevces.join(', '),
        'OfficeBuilding': OfficeBuilding,
        'OfficeNumber': OfficeNumber,
        'PhoneNumber': PhoneNumber,
        'status': status,
        'loggedOn': loggedDate,
        'techId': techId,
        'techFName': techFName,
        'approvedOn': approvedOn,
        'repairedOn': repairedOn,
        'isApproved': true,
        'isRepaired': true,
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
            .where('status', isEqualTo: 'Repaired')
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
                  child: Text('No new completed task found!'),
                )
              : ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (c, index) {
                    // snapshot.data!.docs[index]['fieldName'];
                    return Card(
                      elevation: 5,
                      child: ListTile(
                        onTap: () => showDetails(
                          c,
                          snapshot.data!.docs[index]['clientId'],
                          snapshot.data!.docs[index]['clientFullName'],
                          snapshot.data!.docs[index]['numOfDamagedDevice'],
                          snapshot.data!.docs[index]['DamagedDevces'],
                          snapshot.data!.docs[index]['OfficeBuilding'],
                          snapshot.data!.docs[index]['OfficeNumber'],
                          snapshot.data!.docs[index]['PhoneNumber'],
                          snapshot.data!.docs[index]['status'],
                          snapshot.data!.docs[index]['loggedOn'],
                          snapshot.data!.docs[index]['techId'],
                          snapshot.data!.docs[index]['techFullName'],
                          snapshot.data!.docs[index]['approvedOn'],
                          snapshot.data!.docs[index]['repairedOn'],
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

class AdminCompletedDetailsScreen extends StatelessWidget {
  static const routeName = '/admin_completed_details_screen';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    final cId = args['clientId'] as String;
    final cFName = args['clientFName'] as String;
    final numOfDamagedDevices = args['numOfDamagedDevices'] as String;
    final damagedDevces = args['DamagedDevces'] as String;
    final OfficeBuilding = args['OfficeBuilding'] as String;
    final OfficeNumber = args['OfficeNumber'] as String;
    final PhoneNumber = args['PhoneNumber'] as String;
    final status = args['status'] as String;
    final loggedOn = args['loggedOn'] as String;
    final approvedOn = args['approvedOn'] as String;
    final repairedOn = args['repairedOn'] as String;
    final techId = args['techId'] as String;
    final techFName = args['techFName'] as String;

    final isApproved = args['isApproved'] as bool;
    final isRepaired = args['isRepaired'] as bool;

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
                          cFName,
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
                    Text(numOfDamagedDevices),
                  ],
                ),
                Row(
                  children: [
                    const Text('Damage Devices:'),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(damagedDevces),
                  ],
                ),
                Row(
                  children: [
                    const Text('Office Building:'),
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
                    Text(loggedOn),
                  ],
                ),
                Row(
                  children: [
                    const Text('Office Number:'),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(OfficeNumber),
                  ],
                ),
                isApproved
                    ? Row(
                        children: [
                          const Text('Assigned Technician:'),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: 100,
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              techFName,
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
                isApproved
                    ? Row(
                        children: [
                          const Text('Approved on:'),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(approvedOn),
                        ],
                      )
                    : const SizedBox(),
                isRepaired
                    ? Row(
                        children: [
                          const Text('Repaired on:'),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(repairedOn),
                        ],
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
