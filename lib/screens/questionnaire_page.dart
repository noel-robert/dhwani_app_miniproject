import 'dart:convert';

import 'package:dhwani_app_miniproject/models/question_model.dart';
import 'package:dhwani_app_miniproject/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive_flutter/hive_flutter.dart';

import '../widgets/question_widget.dart';


class DhwaniApp_QuestionnairePage extends StatefulWidget {
  const DhwaniApp_QuestionnairePage({super.key});

  @override
  _DhwaniApp_QuestionnairePageState createState() => _DhwaniApp_QuestionnairePageState();
}

class _DhwaniApp_QuestionnairePageState extends State<DhwaniApp_QuestionnairePage> {
  List<Question> questions = [];
  List<List<String>> selectedAnswers = [];

  late Box questionBox;
  late Box answersBox;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  @override
  void dispose() {
    questionBox.close();
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    final jsonString = await rootBundle.loadString('assets/dataFiles/questionnaire_Data.json');
    final jsonData = jsonDecode(jsonString);
    // print((jsonData[0])['questionText']);

    // final questionBox = await Hive.openBox<Question>('questions');
    questionBox = await Hive.openBox('questions');
    questionBox.clear();  // clear all data in questionBox

    for (final questionData in jsonData) {
      final questionModelTyped = QuestionModel(
          questionText: questionData['questionText'],
          options: List<String>.from(questionData['options'])
      );

      final question = Question(
        questionModelTyped.questionText,
        questionModelTyped.options,
      );
      // print(questionData['questionText']);
      // print(List<String>.from(questionData['options']));

      questionBox.add(questionModelTyped);  // added using index as key - automatically
      // print(question.questionText);
      // print(question.options);
    }

    // setState(() {
    //   questions = questionBox.values.toList();
    //   selectedAnswers = List<List<String>>.filled(questions.length, []);
    // });
    // print((questions[0]).questionText);
    setState(() {
      questions = questionBox.values.map((dynamic questionModelTyped) {
        return Question(
          questionModelTyped.questionText,
          questionModelTyped.options,
        );
      }).toList();
      selectedAnswers = List<List<String>>.filled(questions.length, []);
    });
  }

  void _updateSelectedAnswers() async {
    answersBox = await Hive.openBox('selected_answers');
    answersBox.clear();  // clear all data in answersBox

    List<String> selectedAnswer;
    for (selectedAnswer in selectedAnswers) {
      print(selectedAnswer);
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
            // modifications needed here
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
          // print(selectedAnswers);
          _updateSelectedAnswers();

          // redirect to Home_Page
          Navigator.push(context, MaterialPageRoute(builder: (context) => DhwaniApp_HomePage()));
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}