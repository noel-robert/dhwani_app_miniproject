import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'models/card_model.dart';
import 'models/question_model.dart';
import 'models/userData_model.dart';
import 'screens/login_page.dart';


void main() async {
  await Hive.initFlutter();

  // register all adapters
  Hive.registerAdapter(UserDataModelAdapter());
  Hive.registerAdapter(CardModelAdapter());
  Hive.registerAdapter(QuestionModelAdapter());

  // open all boxes
  await Hive.openBox<UserDataModel>('users_HiveBox');
  await Hive.openBox<CardModel>('cards_HiveBox');
  await Hive.openBox<QuestionModel>('questions_HiveBox');
  await Hive.openBox('selectedAnswers_HiveBox');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const DhwaniApp_LoginPage(),
      theme: ThemeData(primarySwatch: Colors.teal),
    );
  }
}