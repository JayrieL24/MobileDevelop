import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobiledev_finals/notifierprovider/hospital_provider.dart';

class PartnershipPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hospitals = ref.watch(hospitalPartnerProvider);  

    return Scaffold(
      appBar: AppBar(
        title: Text("Hospital Partnerships"),  
        backgroundColor: Colors.green.shade700,
      ),
      body: hospitals.isEmpty
          ? Center(child: Text("No hospital partnerships available."))
          : ListView.builder(
              itemCount: hospitals.length,
              itemBuilder: (context, index) {
                final hospital = hospitals[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(hospital["name"]),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Address: ${hospital["address"]}"),
                        SizedBox(height: 8),
                        Text("Blood Available:"),
                        ...hospital["bloodAvailable"].entries.map((entry) {
                          return Text("${entry.key}: ${entry.value} units");
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddHospitalDialog(context, ref),
        icon: Icon(Icons.local_hospital),
        label: Text("Partnership"),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Dialog to handle adding a new hospital partnership
  void _showAddHospitalDialog(BuildContext context, WidgetRef ref) {
    String? name = '';
    String? address = '';
    Map<String, int> bloodAvailable = {
      "A+": 0,
      "A-": 0,
      "B+": 0,
      "B-": 0,
      "O+": 0,
      "O-": 0,
      "AB+": 0,
      "AB-": 0,
    };

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Hospital Partnership'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // TextField to input hospital name
              TextField(
                decoration: InputDecoration(labelText: 'Hospital Name'),
                onChanged: (value) => name = value,
              ),
              // TextField to input hospital address
              TextField(
                decoration: InputDecoration(labelText: 'Hospital Address'),
                onChanged: (value) => address = value,
              ),
              // TextFields for blood reserve quantities
              for (String bloodType in bloodAvailable.keys)
                TextField(
                  decoration: InputDecoration(labelText: 'Units of $bloodType'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    bloodAvailable[bloodType] = int.tryParse(value) ?? 0;
                  },
                ),
            ],
          ),
          actions: [
            // Cancel button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            // Add button
            TextButton(
              onPressed: () {
                if (name != null && address != null && bloodAvailable.values.every((unit) => unit >= 0)) {
                  ref.read(hospitalPartnerProvider.notifier).addHospital(name!, address!, bloodAvailable);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Hospital partnership added!')),
                  );

                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill out all fields correctly.')),
                  );
                }
              },
              child: Text('Add Partnership'),
            ),
          ],
        );
      },
    );
  }
}
