import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobiledev_finals/notifierprovider/blood_bank_notifier.dart';

class DonationRequestPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final donors = ref.watch(bloodBankProvider.notifier).getAllDonors();

    return Scaffold(
      appBar: AppBar(
        title: Text("Donate Page"),
        backgroundColor: Colors.red.shade700,
      ),
      body: donors.isEmpty
          ? Center(child: Text("No donors available."))
          : ListView.builder(
              itemCount: donors.length,
              itemBuilder: (context, index) {
                final donor = donors[index];
                return ListTile(
                  title: Text('Name: ${donor["name"]}'),
                  subtitle: Text('Age: ${donor["age"]}, Blood Type: ${donor["bloodType"]}'),
                );
              },
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () => _showDonateDialog(context, ref),
            heroTag: "donateButton",
            backgroundColor: Colors.red,
            icon: Icon(Icons.volunteer_activism),
            label: Text('Donate'),
          ),
        ],
      ),
    );
  }

  void _showDonateDialog(BuildContext context, WidgetRef ref) {
    String? name = '';
    String? age = '';
    String? selectedType;
    String units = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Donate Blood'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Name'),
                onChanged: (value) => name = value,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                onChanged: (value) => age = value,
              ),
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
                decoration: InputDecoration(labelText: 'Units to Donate'),
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
                if (name != null && age != null && selectedType != null && units.isNotEmpty) {
                  final donatedUnits = int.tryParse(units) ?? 0;

                  ref.read(bloodBankProvider.notifier).donateBlood(
                    type: selectedType!,
                    units: donatedUnits,
                  );

                  ref.read(bloodBankProvider.notifier).addDonor(name!, age!, selectedType!);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Donation successful!')),
                  );

                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill out all fields.')),
                  );
                }
              },
              child: Text('Donate'),
            ),
          ],
        );
      },
    );
  }
}
