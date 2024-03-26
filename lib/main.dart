import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
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
  //runApp(const MyApp());
  runApp(
    ChangeNotifierProvider(
      create: (context) => SharedPrefsProvider(),
      child: const MyApp(), // Your main app widget
    ),
  );
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: const DhwaniApp_LoginPage(),
//       theme: ThemeData(primarySwatch: Colors.teal),
//     );
//   }
// }
class SharedPrefsProvider extends ChangeNotifier {
  late SharedPreferences prefs;

  Future<void> initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
    notifyListeners(); // Notify listeners when prefs are initialized
  }
}
// Getter methods for accessing data (same as before)

// Setter methods for storing data (same as before)

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
    final prefsProvider = Provider.of<SharedPrefsProvider>(context);
    prefsProvider.initializePrefs();
    return MaterialApp(
      home: const DhwaniApp_LoginPage(),
      theme: ThemeData(primarySwatch: Colors.teal),
    );
  }
}
