import 'package:flutter/material.dart';

class StatusTawaranMahasiswaAdmin extends StatelessWidget {
  final String nrp;
  final String namaProject;
  final String namaPerusahaan;
  final String status;
  final ValueChanged<String> onStatusChanged; // Callback function

  const StatusTawaranMahasiswaAdmin({
    required this.nrp,
    required this.namaProject,
    required this.namaPerusahaan,
    required this.status,
    required this.onStatusChanged, // Callback function required
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String dropdownValue = getStatusText(); // Helper function to get dropdown value

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        alignment: Alignment.center,
        width: 400,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(1.0, 1.0),
              blurRadius: 10.0,
              spreadRadius: 0.1,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(namaProject, style: TextStyle(fontSize: 15, color: Colors.black)),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(namaPerusahaan, style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: DropdownButton<String>(
                  value: dropdownValue,
                  onChanged: (String? newValue) {
                    // Call the callback function with the new value
                    onStatusChanged(newValue ?? ''); // Pass empty string as fallback
                  },
                  items: <String>[
                    'Applied',
                    'Interviewed',
                    'Approved',
                    'Rejected',
                    'Canceled',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getStatusText() {
    switch (status) {
      case '1':
        return 'Applied';
      case '2':
        return 'Interviewed';
      case '3':
        return 'Approved';
      case '4':
        return 'Rejected';
      case '5':
        return 'Canceled';
      default:
        return 'Unknown';
    }
  }
}
