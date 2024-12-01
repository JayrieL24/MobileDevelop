import 'package:flutter_riverpod/flutter_riverpod.dart';

final hospitalPartnerProvider = StateNotifierProvider<HospitalPartnerNotifier, List<Map<String, dynamic>>>(
  (ref) => HospitalPartnerNotifier(),
);

class HospitalPartnerNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  HospitalPartnerNotifier() : super(_initialHospitals);

  static final List<Map<String, dynamic>> _initialHospitals = [
    {
      "name": "City Hospital",
      "address": "123 Main St, City",
      "bloodAvailable": {
        "A+": 10,
        "A-": 5,
        "B+": 8,
        "B-": 4,
        "O+": 12,
        "O-": 6,
        "AB+": 7,
        "AB-": 3,
      }
    },
    {
      "name": "General Medical Center",
      "address": "456 Medical Ave, City",
      "bloodAvailable": {
        "A+": 15,
        "A-": 7,
        "B+": 10,
        "B-": 6,
        "O+": 20,
        "O-": 8,
        "AB+": 9,
        "AB-": 4,
      }
    },
  ];

  // Method to add a new hospital partnership
  void addHospital(String name, String address, Map<String, int> bloodAvailable) {
    state = [
      ...state,
      {
        "name": name,
        "address": address,
        "bloodAvailable": bloodAvailable,
      }
    ];
  }
}
