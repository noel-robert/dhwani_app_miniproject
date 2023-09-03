import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:dhwani_app_miniproject/screens/home_page.dart';
import '../widgets/question_widget.dart';


class DhwaniApp_QuestionnairePage extends StatefulWidget {
  const DhwaniApp_QuestionnairePage({Key? key}) : super(key: key);

  @override
  _DhwaniApp_QuestionnairePageState createState() => _DhwaniApp_QuestionnairePageState();
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
    final jsonString = await rootBundle.loadString('assets/dataFiles/questionnaire_Data.json');
    final jsonData = jsonDecode(jsonString);

    final questionBox = await Hive.openBox<Question>('questions');
    questionBox.clear();  // clear all data in questionBox

    for (final questionData in jsonData) {
      final question = Question(questionData['questionText'], List<String>.from(questionData['options']),);
      questionBox.add(question);
    }

    setState(() {
      questions = questionBox.values.toList();
      selectedAnswers = List<List<String>>.filled(questions.length, []);
    });
  }

  void _updateCardData() async {
    final answersBox = await Hive.openBox<List<String>>('selected_answers');
    answersBox.clear();  // clear all data in answersBox

    for (final selectedAnswer in selectedAnswers) {
      answersBox.add(selectedAnswer);
    }
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
              selectedAnswers[index] = selectedOptions;
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // on submitting the questionnaire
          print(selectedAnswers);
          _updateCardData();

          // redirect to Home_Page
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DhwaniApp_HomePage(selectedAnswers: selectedAnswers)));
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}