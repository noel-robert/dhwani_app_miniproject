import 'package:dhwani_app_miniproject/screens/login_page.dart';
import 'package:dhwani_app_miniproject/screens/signup_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DhwaniApp_LoginPage(),
      theme: ThemeData(primarySwatch: Colors.orange),
    );
  }
}
