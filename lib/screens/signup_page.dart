import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'package:dhwani_app_miniproject/screens/login_page.dart';
import 'package:dhwani_app_miniproject/screens/questionnaire_page.dart';
import 'package:dhwani_app_miniproject/models/userData_model.dart';


class DhwaniApp_SignupPage extends StatefulWidget {
  const DhwaniApp_SignupPage({Key? key}) : super(key: key);

  @override
  _DhwaniApp_SignupPageState createState() => _DhwaniApp_SignupPageState();
}

class _DhwaniApp_SignupPageState extends State<DhwaniApp_SignupPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController guardiannameController = TextEditingController();
  TextEditingController guardianrelationController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordconfirmationController = TextEditingController();
  TextEditingController disabilitytypeController = TextEditingController();
  TextEditingController bloodgroupController = TextEditingController();
  TextEditingController contactnumberController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  String? selectedGender = '-select-';
  String? selectedBloodGroup = '-select-';

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    Hive.close(); // close HIVE box
    super.dispose();
  }

  Future<void> _initializeHive() async {
    final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
  }

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _handleSignUp() async {
    if(_formKey.currentState!.validate()) {
      final username = usernameController.text;
      final password = passwordController.text;
      final email = emailController.text;
      final gender = selectedGender;
      final bloodGroup = selectedBloodGroup;
      final contactNumber = contactnumberController.text;
      final disabilityType = disabilitytypeController.text;
      final guardianName = guardiannameController.text;
      final guardianRelation = guardianrelationController.text;

      final userData = UserData(
        username: username,
        password: password,
        email: email,
        gender: gender,
        bloodGroup: bloodGroup,
        contactNumber: contactNumber,
        disabilityType: disabilityType,
        guardianName: guardianName,
        guardianRelation: guardianRelation,
      );

      // check is a user with same username already exists
      final userBox = await Hive.openBox('users');
      if (userBox.containsKey(username)) {
        // username already exists
        BuildContext currentContext = context;
        showDialog(
          context: currentContext,
          builder: (context) {
            return AlertDialog(
              title: const Text('Signup Failed'),
              content: const Text('Username already exists'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(currentContext).pop(); // Dismiss the dialog box
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        userBox.put(username, userData.toMap()); // add user to database

        // goto questionnaire page
        Navigator.push(context, MaterialPageRoute(builder: (context) => DhwaniApp_QuestionnairePage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DhwaniApp SignUp Page'),
        elevation: 8,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text('SignUp', style: TextStyle(fontSize: 32)),
              ),

              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'UserName',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter username';
                    return null;
                  },
                ),
              ),

              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                  validator: (value) {
                    // validate email
                    return null;
                  },
                ),
              ),

              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
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
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter password';
                    return null;
                  },
                ),
              ),

              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  obscureText: !isConfirmPasswordVisible,
                  controller: passwordconfirmationController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password',
                    suffixIcon: IconButton(
                      icon: Icon(isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value != passwordController.text) return 'Passwords do not match';
                    return null;
                  },
                ),
              ),

              DropdownButtonFormField<String>(
                value: selectedGender,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Gender',
                ),
                items: <String>['-select-', 'Male', 'Female', 'Other']
                    .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        )
                    ).toList(),
                onChanged: (String? value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty || value == '-select-') return 'Please select a gender';
                  return null;
                },
              ),

              DropdownButtonFormField<String>(
                value: selectedBloodGroup,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Blood Group',
                ),
                items: <String>['-select-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                    .map<DropdownMenuItem<String>>(
                        (String value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        )
                    ).toList(),
                onChanged: (String? value) {
                  setState(() {
                    selectedBloodGroup = value;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty || value == '-select-') return 'Please select a blood group';
                  return null;
                },
              ),

              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: contactnumberController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Contact Number',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter a contact number';
                    return null;
                  },
                ),
              ),

              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: disabilitytypeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Disability type',
                  ),
                  validator: (value) {
                    // disability type validator
                    return null;
                  },
                ),
              ),

              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: guardiannameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Guardian Name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter name of guardian';
                    return null;
                  },
                ),
              ),

              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: guardianrelationController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'How is Guardian related to the user?',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter relation of guardian';
                    return null;
                  },
                ),
              ),

              Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  onPressed: _handleSignUp, // store data onto the HIVE database
                  child: const Text('SignUp'),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text('Already have an account?'),
                  TextButton(
                      child: const Text('Login', style: TextStyle(fontSize: 20),),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => DhwaniApp_LoginPage()));
                      })
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}