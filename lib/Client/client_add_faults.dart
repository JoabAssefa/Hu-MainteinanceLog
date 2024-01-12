import 'package:flutter/material.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class ClientAddFaultScreen extends StatefulWidget {
  const ClientAddFaultScreen({super.key});
  static const routeName = '/client_add_fault_screen';

  @override
  State<ClientAddFaultScreen> createState() => _ClientAddFaultScreenState();
}

class _ClientAddFaultScreenState extends State<ClientAddFaultScreen> {
  final TextEditingController numDeviceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance Request Form'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20.0),
          const Text(
            'Select damaged device/s',
            style: TextStyle(fontSize: 20.0),
          ),
          const SizedBox(height: 5.0),
          MultiSelectDropDown(
            showClearIcon: true,
            //controller: _controller,
            onOptionSelected: (options) {
              debugPrint(options.toString());
            },
            options: const <ValueItem>[
              ValueItem(label: 'Desktop Computer', value: '1'),
              ValueItem(label: 'Laptop Computer', value: '2'),
              ValueItem(label: 'Printer', value: '3'),
              ValueItem(label: 'Scanner', value: '4'),
              ValueItem(label: 'Copy Machine', value: '5'),
            ],
            maxItems: 2,
            disabledOptions: const [ValueItem(label: 'Option 1', value: '1')],
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
          ElevatedButton(onPressed: () {}, child: const Text('Submit Request'))
        ],
      ),
    );
  }
}
