import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _indexPrestasiController = TextEditingController();
  final TextEditingController _nrpController = TextEditingController();

  Future<void> _register() async {
    final url = Uri.https('ambw-leap-default-rtdb.firebaseio.com', 'account/mahasiswa.json');
    final url2 = Uri.https('ambw-leap-default-rtdb.firebaseio.com', 'dataMahasiswa.json');
    final response = await http.get(url);
    final response2 = await http.get(url2);

    if (response2.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response2.body) ?? {};
      final String newUserKey = 'dataMahasiswa' + (data.length + 1).toString();

      data[newUserKey] = {
        'indexPrestasi': int.parse(_indexPrestasiController.text),
        'nrp': _nrpController.text,
        'status' : 1,
        'username': _usernameController.text,
      };

     await http.put(url2, body: json.encode(data));
    }

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body) ?? {};
      final String newUserKey = 'mahasiswa' + (data.length + 1).toString();

      data[newUserKey] = {
        'username': _usernameController.text,
        'password': _passwordController.text,
      };

      final updateResponse = await http.put(url, body: json.encode(data));

      if (updateResponse.statusCode == 200) {
        debugPrint('Registration successful');
        _showDialog('Registration successful');
      } else {
        debugPrint('Failed to register: ${updateResponse.statusCode}');
        debugPrint('Response body: ${updateResponse.body}');
        _showDialog('Failed to register');
      }
    } else {
      debugPrint('Failed to load data: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      _showDialog('Failed to load data');
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration Status'),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                if (message == 'Registration successful') {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.3),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.3),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Create an Account',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: _usernameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.person, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.lock, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _nrpController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    labelText: 'NRP',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.assignment_ind, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _indexPrestasiController,
                  style: TextStyle(color: Colors.white),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Hanya memperbolehkan karakter angka
                  ],
                  keyboardType: TextInputType.number, // Keyboard tipe angka
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    labelText: 'Index Prestasi',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(Icons.school, color: Colors.white),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'Register',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
