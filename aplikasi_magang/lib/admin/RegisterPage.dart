import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedRole = 'mahasiswa';
  final List<String> _roles = ['mahasiswa', 'dosen', 'employer', 'admin'];

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ipkController = TextEditingController();
  final TextEditingController _nrpController = TextEditingController();

  bool _showIpkField = false;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _selectedRole = 'mahasiswa';
    _showIpkField = true;
  }

  Future<void> _register() async {
    if (_passwordController.text.length < 6) {
      _showDialog('Minimum 6 characters!');
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint(e.code);
      Navigator.pop(context);
      _showDialog(e.code);
      return;
    }

    try {
      final url = Uri.https(
          'ambw-leap-default-rtdb.firebaseio.com', 'account/$_selectedRole.json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body) ?? {};
        final String newUserKey =
            '$_selectedRole' + (data.length + 1).toString();

        data[newUserKey] = {
          'username': _usernameController.text,
          'email': _emailController.text,
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

      if (_selectedRole == "mahasiswa") {
        final url2 = Uri.https('ambw-leap-default-rtdb.firebaseio.com', 'dataMahasiswa.json');
        final response2 = await http.get(url2);

        if (response2.statusCode == 200) {
          final Map<String, dynamic> data_2 = json.decode(response2.body) ?? {};
          final String newUserKey =
              'dataMahasiswa' + (data_2.length + 1).toString();

          final dummyData = {
            'id': 'dummyId',
            'id_tawaran': 'dummyIdTawaran',
            'status_tawaran': 0,
          };

          final newData = {
            'indexPrestasi': int.parse(_ipkController.text),
            'nrp': _nrpController.text,
            'status': 0,
            'status_terima': false,
            'tawaranPilihan': {'dummy': dummyData}, // Include dummy data here
            'username': _usernameController.text,
          };

          data_2[newUserKey] = newData;

          debugPrint('New dataMahasiswa entry with dummy data: ${json.encode(newData)}');

          final updateResponse2 = await http.put(url2, body: json.encode(data_2));

          if (updateResponse2.statusCode == 200) {
            debugPrint('Mahasiswa data update successful');
            //_showDialog('Mahasiswa data update successful');
          } else {
            debugPrint('Failed to update mahasiswa data: ${updateResponse2.statusCode}');
            debugPrint('Response body: ${updateResponse2.body}');
            _showDialog('Failed to update mahasiswa data');
          }
        } else {
          debugPrint('Failed to load mahasiswa data: ${response2.statusCode}');
          debugPrint('Response body: ${response2.body}');
          _showDialog('Failed to load mahasiswa data');
        }
      }
    } catch (e) {
      debugPrint(e.toString());
      Navigator.pop(context);
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedRole,
                items: _roles.map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Role'),
                onChanged: (newValue) {
                  setState(() {
                    _selectedRole = newValue;
                    _showIpkField = newValue ==
                        'mahasiswa'; // Show IPK field only for Mahasiswa
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a role';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              if (_showIpkField)
                TextFormField(
                  controller: _nrpController,
                  decoration: InputDecoration(
                    labelText: 'NRP',
                    prefixIcon: const Icon(Icons.numbers, color: Colors.black),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your NRP';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 10),
              if (_showIpkField)
                TextFormField(
                  controller: _ipkController,
                  decoration: InputDecoration(
                    labelText: 'IPK',
                    prefixIcon: const Icon(Icons.grade, color: Colors.black),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your IPK';
                    }
                    return null;
                  },
                ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  prefixIcon: const Icon(Icons.person, color: Colors.black),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.mail, color: Colors.black),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock, color: Colors.black),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: _register,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
