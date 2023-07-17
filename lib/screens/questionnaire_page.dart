import 'dart:convert';

import 'package:dhwani_app_miniproject/screens/home_page.dart';
import 'package:flutter/material.dart';

import '../widgets/question_widget.dart';

class DhwaniApp_QuestionnairePage extends StatefulWidget {
  const DhwaniApp_QuestionnairePage({Key? key}) : super(key: key);

  @override
  _DhwaniApp_QuestionnairePageState createState() =>
      _DhwaniApp_QuestionnairePageState();
}

class _DhwaniApp_QuestionnairePageState extends State<DhwaniApp_QuestionnairePage> {
  List<Question> questions = [];
  List<List<String>> selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    String jsonContent = await DefaultAssetBundle.of(context).loadString('assets/dataFiles/questionnaire_Data.json');
    List<dynamic> jsonData = jsonDecode(jsonContent);

    setState(() {
      questions = jsonData.map((data) => Question(
        data['questionText'],
        List<String>.from(data['options']),
      )).toList();
      selectedAnswers = List<List<String>>.filled(questions.length, []);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Questionnaire")),
      body: ListView.builder(
          itemCount: questions.length,
          itemBuilder: (BuildContext context, int index) {
            return QuestionWidget(
              question: questions[index],
              onAnswerSelected: (List<String> selectedOptions) {
                setState(() {
                  selectedAnswers[index] = selectedOptions;
                });
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // on submitting the questionnaire
          print(selectedAnswers);

          // redirect to Home_Page
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DhwaniApp_HomePage(selectedAnswers: selectedAnswers)));
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
