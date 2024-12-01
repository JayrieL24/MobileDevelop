import 'package:flutter_riverpod/flutter_riverpod.dart';

final bloodBankProvider = StateNotifierProvider<BloodBankNotifier, List<Map<String, dynamic>>>(
  (ref) => BloodBankNotifier(),
);

class BloodBankNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  BloodBankNotifier() : super(_initialBloodData) {
    // Adding 3 sample donors on initialization
    _addSampleDonors();
  }

  static final List<Map<String, dynamic>> _initialBloodData = [
    {"type": "A+", "units": 5},
    {"type": "A-", "units": 3},
    {"type": "B+", "units": 7},
    {"type": "B-", "units": 2},
    {"type": "O+", "units": 8},
    {"type": "O-", "units": 1},
    {"type": "AB+", "units": 6},
    {"type": "AB-", "units": 4},
  ];

  bool requestBlood({required String type, required int units}) {
    bool success = false;

    // Map through the blood types to deduct units
    state = state.map((blood) {
      if (blood["type"] == type) {
        if (blood["units"] >= units) {
          success = true;
          return {"type": type, "units": blood["units"] - units};
        }
      }
      return blood;
    }).toList();

    return success;  // Return success or failure
  }

  List<Map<String, String>> donors = [];

  // Adding 3 sample donors
  void _addSampleDonors() {
    donors.addAll([
      {
        "name": "John Doe",
        "age": "29",
        "bloodType": "O+",
      },
      {
        "name": "Jane Smith",
        "age": "34",
        "bloodType": "A+",
      },
      {
        "name": "Robert Brown",
        "age": "41",
        "bloodType": "B+",
      },
    ]);
  }

  // Method to add a donor's information
  void addDonor(String name, String age, String bloodType) {
    donors.add({
      "name": name,
      "age": age,
      "bloodType": bloodType,
    });
  }

  // Method to get all donors (for display purposes)
  List<Map<String, String>> getAllDonors() {
    return donors;
  }

  // Method to donate blood and increase units
  void donateBlood({required String type, required int units}) {
    state = state.map((blood) {
      if (blood["type"] == type) {
        return {"type": type, "units": blood["units"] + units};
      }
      return blood;
    }).toList();
  }
}
