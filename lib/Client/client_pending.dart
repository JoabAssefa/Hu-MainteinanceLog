import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ClientPending extends StatefulWidget {
  final String uId;
  ClientPending(this.uId);
  @override
  State<ClientPending> createState() => _ClientPendingState();
}

class _ClientPendingState extends State<ClientPending> {
  void showDetails(
    BuildContext context,
    String faultId,
    String uId,
    String uFName,
    String numOfDamagedDevices,
    List<dynamic> DamagedDevces,
    String cOfficeBuilding,
    String cOfficeNumber,
    String status,
    String loggedDate,
    String techId,
    String techFName,
    String approvedOn,
  ) {
    // ...
    Navigator.of(context).pushNamed(
      ClientPendingDetailsScreen.routeName,
      arguments: {
        'faultId': faultId,
        'clientId': uId,
        'clientFName': uFName,
        'numOfDamagedDevices': numOfDamagedDevices,
        'DamagedDevces': DamagedDevces.join(', '),
        'OfficeBuilding': cOfficeBuilding,
        'OfficeNumber': cOfficeNumber,
        'status': status,
        'loggedOn': loggedDate,
        'techId': techId,
        'techFName': techFName,
        'approvedOn': approvedOn,
        'isApproved': false,
        'isRepaired': false,
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
            .where(
              'status',
              isEqualTo: 'Pending',
            )
            .where(
              'clientId',
              isEqualTo: widget.uId,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            Fluttertoast.showToast(
              msg: 'An error occurred!',
              backgroundColor: Colors.redAccent,
            );
          }
          return !snapshot.hasData
              ? const Center(
                  child: Text('No new pending task  found!'),
                )
              : ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (c, index) {
                    return Card(
                      elevation: 5,
                      child: ListTile(
                        onTap: () => showDetails(
                            c,
                            snapshot.data!.docs[index]['faultId'],
                            snapshot.data!.docs[index]['clientId'],
                            snapshot.data!.docs[index]['clientFullName'],
                            snapshot.data!.docs[index]['numOfDamagedDevice'],
                            snapshot.data!.docs[index]['DamagedDevces'],
                            snapshot.data!.docs[index]['OfficeBuilding'],
                            snapshot.data!.docs[index]['OfficeNumber'],
                            snapshot.data!.docs[index]['status'],
                            snapshot.data!.docs[index]['loggedOn'],
                            snapshot.data!.docs[index]['techId'],
                            snapshot.data!.docs[index]['techFullName'],
                            snapshot.data!.docs[index]['approvedOn']),
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'No. of Damaged Devices: ${snapshot.data!.docs[index]['numOfDamagedDevice']}',
                            ),
                            Text(
                              'Logged on: ${snapshot.data!.docs[index]['loggedOn']}',
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

class ClientPendingDetailsScreen extends StatelessWidget {
  static const routeName = '/client_pending_details_screen';
  // var loopUpdate = true;

  void approveRepaired({
    required BuildContext context,
    required String techFName,
    required String techId,
    required String faultId,
  }) {
    // ...
    var isAvailabile = true;

    try {
      // -- Gets the technician availability status --

      FirebaseFirestore.instance.collection('faults').doc(faultId).update(
        {
          'repairedOn':
              DateFormat('dd-MMM-yyyy hh:mm aaa').format(DateTime.now()),
          'status': 'Repaired',
        },
      ).then((value) {
        FirebaseFirestore.instance
            .collection('Technicians')
            .where('techId', isEqualTo: techId)
            .get()
            .then((value) {
          value.docs.forEach((element) {
            isAvailabile = true;
          });
          FirebaseFirestore.instance
              .collection('Technicians')
              .doc(techId)
              .update({
            'isAvailabile': isAvailabile,
          });

          // -- Navigate to DelayedScreen--
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.blueAccent,
              content: Text(
                'Yay! Fault has been repaired!',
              ),
            ),
          );
        }).onError((error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to approve'),
              backgroundColor: Colors.redAccent,
            ),
          );
        });
      });
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
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    print('Value of args: $args');
    final cId = args['clientId'] as String;
    final faultId = args['faultId'] as String;
    final cFName = args['clientFName'] as String;
    final numOfDamagedDevices = args['numOfDamagedDevices'] as String;
    final DamagedDevces =
        args['DamagedDevces'] != null ? args['DamagedDevces'].toString() : '';

    final OfficeBuilding = args['OfficeBuilding'] as String;
    final cOfficeNumber = args['OfficeNumber'] as String;
    final status = args['status'] as String;
    final loggedOn = args['loggedOn'] as String;
    final approvedOn = args['approvedOn'] as String;
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
            height: 400,
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
                    Text(
                      numOfDamagedDevices,
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Damage Devices:'),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      DamagedDevces,
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('OfficeNumber:'),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      cOfficeNumber,
                    ),
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
                    const Text('Status:'),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      status,
                    ),
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
                          Text(
                            approvedOn,
                          ),
                        ],
                      )
                    : const SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        approveRepaired(
                          context: context,
                          techFName: techFName,
                          techId: techId,
                          faultId: faultId,
                        );
                      },
                      child: const Text(
                        'Approve Repaired',
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
