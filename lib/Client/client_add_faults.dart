import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class ClientAddFaultScreen extends StatefulWidget {
  const ClientAddFaultScreen({super.key});
  static const routeName = '/client_add_fault_screen';

  @override
  State<ClientAddFaultScreen> createState() => _ClientAddFaultScreenState();
}

class _ClientAddFaultScreenState extends State<ClientAddFaultScreen> {
  final _formKey = GlobalKey<FormState>();
  var isLoading = false;
  List<ValueItem> selectedDevices = [];
  List<String> DamagedDevces = [];
  final TextEditingController numDeviceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    final cId = args['clientId'] as String;
    final cOfficeBuilding = args['OfficeBuilding'] as String;
    final cOfficeNumber = args['OfficeNumber'] as String;
    final cPhoneNumber = args['PhoneNumber'] as String;
    final cFullName = args['clientFullName'] as String;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance Request Form'),
        backgroundColor: Colors.orange,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 20.0),
            const Text(
              'Select damaged device/s',
              style: TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 5.0),
            MultiSelectDropDown(
              showClearIcon: true,

              // controller: _controller,
              onOptionSelected: (options) {
                setState(() {
                  selectedDevices = options;
                });
                DamagedDevces =
                    selectedDevices.map((item) => item.label).toList();
              },
              options: const <ValueItem>[
                ValueItem(label: 'Desktop Computer', value: '1'),
                ValueItem(label: 'Laptop Computer', value: '2'),
                ValueItem(label: 'Printer', value: '3'),
                ValueItem(label: 'Scanner', value: '4'),
                ValueItem(label: 'Copy Machine', value: '5'),
              ],
              maxItems: 5,
              selectionType: SelectionType.multi,
              chipConfig: const ChipConfig(wrapType: WrapType.wrap),
              dropdownHeight: 250,
              optionTextStyle: const TextStyle(fontSize: 16),
              selectedOptionIcon: const Icon(Icons.check_circle),
            ),
            const SizedBox(height: 30.0),
            TextFormField(
              controller: numDeviceController,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Number of devices Damaged',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'value cannot be left empty';
                } else if (!RegExp("^[0-9]").hasMatch(value)) {
                  return 'value can only be a number';
                }
              },
              onChanged: (value) {},
            ),
            const SizedBox(height: 30.0),
            ElevatedButton(
                onPressed: () {
                  _submitData(context, cId, cOfficeBuilding, cOfficeNumber,
                      cPhoneNumber, cFullName);
                },
                child: const Text('Submit Request'))
          ],
        ),
      ),
    );
  }

  void _submitData(
    BuildContext context,
    String cId,
    String cOfficeBuilding,
    String cOfficeNumber,
    String cPhoneNumber,
    String cFullName,
  ) async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    DateTime uniqueDate;
    if (isValid) {
      try {
        setState(() {
          isLoading = true;
        });
        uniqueDate = DateTime.now();
        await FirebaseFirestore.instance
            .collection('faults')
            .doc('$cId${uniqueDate.toUtc().toString()}')
            .set({
          'faultId': '$cId${uniqueDate.toUtc().toString()}',
          'clientId': cId,
          'clientFullName': cFullName,
          'numOfDamagedDevice': numDeviceController.text,
          'DamagedDevces': DamagedDevces,

          'OfficeBuilding': cOfficeBuilding,
          'OfficeNumber': cOfficeNumber,
          'PhoneNumber': cPhoneNumber,
          'status': 'Delayed',
          'loggedOn': DateFormat('dd-MMM-yyyy hh:mm aaa').format(uniqueDate),

          // Upon approval
          'techId': 'none',
          'techFullName': 'none',
          'approvedOn': '00-00-00',

          // Upon Repaired
          'repairedOn': '00-00-00',
        });
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Request successfully sent!'),
            backgroundColor: Colors.blueAccent,
          ),
        );
      } on PlatformException catch (err) {
        //the name 'PlatformException' isn't a type and can't be used in an on-catch clause
        setState(() {
          isLoading = false;
        });
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
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(err.toString()),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
}
