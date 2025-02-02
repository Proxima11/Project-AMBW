import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'admin/homepage_admin.dart';
import 'mahasiswa/homepage_mhs.dart';
import 'teacher/homepage_teach.dart';
import 'employeer/homepage_employer.dart';
import 'admin/RegisterPage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailCController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String _selectedRole = 'admin';

  Future<void> _login() async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      final url = Uri.https('ambw-leap-default-rtdb.firebaseio.com',
          'account/$_selectedRole.json');
      final response = await http.get(url);
      bool authenticated = false;
      var username = "";

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        data.forEach((key, value) {
          if (value['email'] == _emailCController.text &&
              value['password'] == _passwordController.text) {
            authenticated = true;
            username = value['username'];
          }
        });
      }

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailCController.text,
        password: _passwordController.text,
      );

      if (userCredential.user != null && authenticated) {
        debugPrint('Login successful as $_selectedRole');
        _showDialog('Login successful', true, _selectedRole, username);
      } else {
        debugPrint('Invalid credentials');
        _showDialog('Invalid credentials', false, _selectedRole, username);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      }
      _showDialog('Invalid credentials', false, _selectedRole, '');
    } catch (e) {
      debugPrint('Failed to load data: $e');
      _showDialog('Failed to load data', false, _selectedRole, '');
    }
  }

  void _showDialog(String message, bool success, String role, String username) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Status'),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                if (success) {
                  _redirectToRolePage(role, username);
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _redirectToRolePage(String role, String username) {
    Widget destinationPage = LoginPage();
    switch (role) {
      case 'admin':
        destinationPage = HomePageAdmin(data: username);
        break;
      case 'dosen':
        destinationPage = HomePageTeach(data: username);
        break;
      case 'employer':
        destinationPage = HomepageEmployer(data: username);
        break;
      case 'mahasiswa':
        destinationPage = HomePage(data: username);
        break;
      default:
        break;
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => destinationPage),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWideScreen = constraints.maxWidth > 800;
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      if (isWideScreen)
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("lib/assets/background_projectamw.jpg"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      Expanded(
                        flex: isWideScreen ? 1 : 2,
                        child: Container(
                          color: Colors.black.withOpacity(0.7),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Welcome Back!',
                                style: TextStyle(
                                  fontSize: isWideScreen ? 36 : 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 30),
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: isWideScreen ? 400 : double.infinity,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: _emailCController,
                                            style: const TextStyle(color: Colors.white),
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white.withOpacity(0.1),
                                              labelText: 'Email',
                                              labelStyle: const TextStyle(color: Colors.white),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              prefixIcon: const Icon(Icons.mail, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: Colors.white),
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: _selectedRole,
                                              dropdownColor: Colors.black,
                                              style: const TextStyle(color: Colors.white),
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
                                              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    TextField(
                                      controller: _passwordController,
                                      obscureText: !_isPasswordVisible,
                                      style: const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(0.1),
                                        labelText: 'Password',
                                        labelStyle: const TextStyle(color: Colors.white),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
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
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              ElevatedButton(
                                onPressed: _login,
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: Colors.blueAccent,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
