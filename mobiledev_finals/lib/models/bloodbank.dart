import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobiledev_finals/notifierprovider/blood_bank_notifier.dart';

class BloodBankPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bloodData = ref.watch(bloodBankProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Bank'),
        backgroundColor: Colors.red[800],
      ),
      body: ListView.builder(
        itemCount: bloodData.length,
        itemBuilder: (context, index) {
          final blood = bloodData[index];
          return ListTile(
            leading: Icon(Icons.bloodtype, color: Colors.red),
            title: Text('Type: ${blood["type"]}'),
            subtitle: Text('Units: ${blood["units"]}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showRequestBloodDialog(context, ref),
        backgroundColor: Colors.red,
        icon: Icon(Icons.bloodtype),
        label: Text('Request'),
      ),
    );
  }

  void _showRequestBloodDialog(BuildContext context, WidgetRef ref) {
    String? selectedType;
    String units = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Request Blood'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedType,
                onChanged: (value) => selectedType = value,
                hint: Text('Select Blood Type'),
                items: [
                  "A+", "A-", "B+", "B-", "O+", "O-", "AB+", "AB-"
                ].map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Units to Request'),
                keyboardType: TextInputType.number,
                onChanged: (value) => units = value,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (selectedType != null && units.isNotEmpty) {
                  final requestedUnits = int.tryParse(units) ?? 0;
                  final success = ref.read(bloodBankProvider.notifier).requestBlood(
                    type: selectedType!,
                    units: requestedUnits,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: success
                          ? Text('Request successful!')
                          : Text('Insufficient units available!'),
                    ),
                  );

                  Navigator.pop(context);
                }
              },
              child: Text('Request'),
            ),
          ],
        );
      },
    );
  }
}
