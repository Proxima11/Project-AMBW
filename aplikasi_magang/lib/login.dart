import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'admin/homepage_admin.dart';
import 'mahasiswa/homepage_mhs.dart';
import 'teacher/homepage_teach.dart';
import 'employeer/homepage_employer.dart';
import 'RegisterPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String _selectedRole = 'mahasiswa';

  Future<void> _login() async {
    final url = Uri.https(
        'ambw-leap-default-rtdb.firebaseio.com', 'account/$_selectedRole.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      bool authenticated = false;

      data.forEach((key, value) {
        if (value['username'] == _usernameController.text &&
            value['password'] == _passwordController.text) {
          authenticated = true;
        }
      });

      if (authenticated) {
        debugPrint('Login successful as $_selectedRole');
        _showDialog('Login successful', true, _selectedRole);
      } else {
        debugPrint('Invalid credentials');
        _showDialog('Invalid credentials', false, '');
      }
    } else {
      debugPrint('Failed to load data');
      _showDialog('Failed to load data', false, '');
    }
  }

  void _showDialog(String message, bool success, String role) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Status'),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                if (success) {
                  _redirectToRolePage(role);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _redirectToRolePage(String role) {
    switch (role) {
      case 'admin':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePageAdmin()),
        );
        break;
      case 'dosen':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePageTeach()),
        );
        break;
      case 'employer':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomepageEmployer()),
        );
        break;
      case 'mahasiswa':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/assets/background_projectamw.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
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
                      'Welcome Back!',
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
                      obscureText: !_isPasswordVisible,
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
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    DropdownButton<String>(
                      value: _selectedRole,
                      dropdownColor: Colors.black,
                      style: TextStyle(color: Colors.white),
                      items: <String>['admin', 'dosen', 'employer', 'mahasiswa']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedRole = newValue!;
                        });
                      },
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
