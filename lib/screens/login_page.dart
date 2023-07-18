import 'package:dhwani_app_miniproject/screens/home_page.dart';
import 'package:dhwani_app_miniproject/screens/questionnaire_page.dart';
import 'package:dhwani_app_miniproject/screens/signup_page.dart';
import 'package:flutter/material.dart';

class DhwaniApp_LoginPage extends StatefulWidget {
  const DhwaniApp_LoginPage({Key? key}) : super(key: key);

  @override
  _DhwaniApp_LoginPageState createState() => _DhwaniApp_LoginPageState();
}

class _DhwaniApp_LoginPageState extends State<DhwaniApp_LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                //forgot password screen
              },
              child: const Text(
                'Forgot Password',
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                child: const Text('Login'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DhwaniApp_QuestionnairePage()));
                },
              ),
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