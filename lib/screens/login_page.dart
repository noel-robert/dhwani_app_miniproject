import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/userData_model.dart';
import '../screens/home_page.dart';
import '../screens/signup_page.dart';


class DhwaniApp_LoginPage extends StatefulWidget {
  const DhwaniApp_LoginPage({super.key});

  @override
  State<DhwaniApp_LoginPage> createState() => DhwaniApp_LoginPageState();
}

class DhwaniApp_LoginPageState extends State<DhwaniApp_LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;
  late Box<UserDataModel> userBox;

  // bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _openBox() {
    userBox = Hive.box('users_HiveBox');
  }

  Future<bool> _performLogin() async {
    final username = usernameController.text;
    final password = passwordController.text;

    var userData = userBox.get(username);
    // print(userData);
    var userData_Password =
        userBox.containsKey(username) ? userData?.password : null;

    if (userData_Password == password) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('DhwaniApp Login Page'),
        elevation: 8,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 32),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: !isPasswordVisible,
                controller: passwordController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                final currentContext = context;
                if (await _performLogin()) {
                  Navigator.push(
                      currentContext,
                      MaterialPageRoute(
                          builder: (context) => DhwaniApp_HomePage()));
                } else {
                  showDialog(
                    context: currentContext, // Use the captured context
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Login Failed'),
                        content: const Text('Invalid username or password.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(currentContext)
                                  .pop(); // Dismiss the dialog
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Login'),
              // child: isLoading ? const CircularProgressIndicator() : const Text('Login'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Do not have account?'),
                TextButton(
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DhwaniApp_SignupPage()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
