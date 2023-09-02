import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:dhwani_app_miniproject/screens/home_page.dart';
import 'package:dhwani_app_miniproject/screens/signup_page.dart';


class DhwaniApp_LoginPage extends StatefulWidget {
  const DhwaniApp_LoginPage({Key? key}) : super(key: key);

  @override
  _DhwaniApp_LoginPageState createState() => _DhwaniApp_LoginPageState();
}

class _DhwaniApp_LoginPageState extends State<DhwaniApp_LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPasswordVisible = false;

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
                    icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off),
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
                final username = usernameController.text;
                final password = passwordController.text;

                // verify from HIVE database
                final userBox = await Hive.openBox('users');
                if (userBox.containsKey(username) && userBox.get(username) == password) {
                  // authorized user
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DhwaniApp_HomePage()));
                } else {
                  // unauthorized access
                  BuildContext currentContext = context;
                  showDialog(
                    context: currentContext, // Use the captured context
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Login Failed'),
                        content: const Text('Invalid username or password.'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(currentContext).pop(); // Dismiss the dialog
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => DhwaniApp_SignupPage()));
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