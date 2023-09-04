import 'package:dhwani_app_miniproject/models/card_model.dart';
import 'package:dhwani_app_miniproject/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CardModelAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const DhwaniApp_LoginPage(),
      theme: ThemeData(primarySwatch: Colors.orange),
    );
  }
}
