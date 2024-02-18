import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClientRequested extends StatefulWidget {
  final String uId;
  ClientRequested(this.uId);
  @override
  State<ClientRequested> createState() => _ClientRequestedState();
}

class _ClientRequestedState extends State<ClientRequested> {
  void showDetails(
    BuildContext ctx,
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
    String repairedOn,
  ) {
    // ...
    Navigator.of(ctx).pushNamed(
      ClientRequestedDetails.routeName,
      arguments: {
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
        'repairedOn': repairedOn,
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
              isEqualTo: 'Delayed',
            )
            .where(
              'clientId',
              isEqualTo: widget.uId,
            )
            .snapshots(),
        builder: (ctx, snapshot) {
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
                          c,
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
                          snapshot.data!.docs[index]['approvedOn'],
                          snapshot.data!.docs[index]['repairedOn'],
                        ),
                        leading: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'No. of Damaged Devices: ${snapshot.data!.docs[index]['numOfDamagedDevice']}',
                                style: TextStyle(color: Colors.white)),
                            Text(
                                'Logged on: ${snapshot.data!.docs[index]['loggedOn']}',
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

class ClientRequestedDetails extends StatelessWidget {
  const ClientRequestedDetails({super.key});
  static const routeName = '/client_requested';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    final cFName = args['clientFName'] as String;
    final numOfDamagedDevices = args['numOfDamagedDevices'] as String;
    final damagedDevces = args['DamagedDevces'].toString();
    final cOfficeBuilding = args['OfficeBuilding'] as String;
    final cOfficeNumber = args['OfficeNumber'] as String;
    final status = args['status'] as String;
    final loggedOn = args['loggedOn'] as String;
    final techFName = args['techFName'] as String;
    final approvedOn = args['approvedOn'] as String;
    final repairedOn = args['repairedOn'] as String;

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
                    const Text('No. Damaged Devices:',
                        style: TextStyle(color: Colors.white)),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(numOfDamagedDevices,
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
                Row(
                  children: [
                    const Text('Selected Device:',
                        style: TextStyle(color: Colors.white)),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(damagedDevces, style: TextStyle(color: Colors.white)),
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
                    const Text('OfficeBuilding:',
                        style: TextStyle(color: Colors.white)),
                    const SizedBox(
                      width: 5,
                    ),
                    Text('$cOfficeBuilding ',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
                Row(
                  children: [
                    const Text('Office Number:',
                        style: TextStyle(color: Colors.white)),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 100,
                      padding: const EdgeInsets.all(5),
                      child: Text(cOfficeNumber,
                          style: TextStyle(color: Colors.white)),
                    ),
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
                isApproved
                    ? Row(
                        children: [
                          const Text('Assigned Technician:',
                              style: TextStyle(color: Colors.white)),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: 100,
                            padding: const EdgeInsets.all(5),
                            child: Text(techFName,
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      )
                    : const SizedBox(),
                isApproved
                    ? Row(
                        children: [
                          const Text('Approved on:',
                              style: TextStyle(color: Colors.white)),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(approvedOn,
                              style: TextStyle(color: Colors.white)),
                        ],
                      )
                    : const SizedBox(),
                isRepaired
                    ? Row(
                        children: [
                          const Text('Repaired on:',
                              style: TextStyle(color: Colors.white)),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(repairedOn,
                              style: TextStyle(color: Colors.white)),
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
