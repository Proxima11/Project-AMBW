import 'package:flutter/material.dart';
import 'mahasiswa/homepage_mhs.dart';
import 'login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: "AIzaSyDvSq9VEbe2bMlb0PJAw5_MaqNebU3PCcQ",
    authDomain: "ambw-leap.firebaseapp.com",
    databaseURL: "https://ambw-leap-default-rtdb.firebaseio.com/",
    appId: '1:369888078407:android:7d6e45d4abc60326041f62',
    projectId: 'ambw-leap',
    messagingSenderId: '369888078407',
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
      // routes: {
      //   './mahasiswa/homepage': (context) => HomePage(),
      // },
    );
  }
}
