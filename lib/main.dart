// ignore_for_file: prefer_const_constructors

import 'package:attendanceapp/homescreen.dart';
import 'package:attendanceapp/loginscreen.dart';
import 'package:attendanceapp/model/user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyBJr7-nt_kqDC1l_N3HD_Ykv-kWE-M5mJ0",
          appId: "1:629545315903:web:0ade52cd55b57ecf38528a",
          messagingSenderId: "629545315903",
          projectId: "attendanceapp-da681"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AttendanceApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: const LoginScreen(),
      //home: const HomeScreen(),
      home: AuthCheck(),
      //home: LoginScreen(),
    );
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);
  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool userAvailable = false;
  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() async {
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      if (sharedPreferences.getString('employeeId') != null) {
        setState(() {
          User.username = sharedPreferences.getString('employeeId')!;
          userAvailable = true;
        });
      }
    } catch (e) {
      setState(() {
        userAvailable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return userAvailable ? HomeScreen() : const LoginScreen();
  }
}
