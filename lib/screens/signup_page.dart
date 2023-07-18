import 'package:dhwani_app_miniproject/screens/login_page.dart';
import 'package:flutter/material.dart';

class DhwaniApp_SignupPage extends StatefulWidget {
  const DhwaniApp_SignupPage({Key? key}) : super(key: key);

  @override
  _DhwaniApp_SignupPageState createState() => _DhwaniApp_SignupPageState();
}

class _DhwaniApp_SignupPageState extends State<DhwaniApp_SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DhwaniApp SignUp Page'),
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
                'SignUp',
                style: TextStyle(fontSize: 32),
              ),
            ),
            Text("Sign-Up Parameters"),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                child: const Text('SignUp'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DhwaniApp_LoginPage()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}