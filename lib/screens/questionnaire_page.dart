import 'package:dhwani_app_miniproject/screens/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/question_widget.dart';

class DhwaniApp_QuestionnairePage extends StatefulWidget {
  const DhwaniApp_QuestionnairePage({Key? key}) : super(key: key);

  @override
  _DhwaniApp_QuestionnairePageState createState() =>
      _DhwaniApp_QuestionnairePageState();
}

class _DhwaniApp_QuestionnairePageState
    extends State<DhwaniApp_QuestionnairePage> {
  List<Question> questions = [
    Question(
      'Question 1',
      ['Option 1.1', 'Option 1.2', 'Option 1.3', 'Option 1.4'],
    ),
    Question(
      'Question 2',
      ['Option 2.1', 'Option 2.2', 'Option 2.3', 'Option 2.4'],
    ),
    Question(
      'Question 3',
      ['Option 3.1', 'Option 3.2', 'Option 3.3', 'Option 3.4'],
    ),
    Question(
      'Question 4',
      ['Option 4.1', 'Option 4.2', 'Option 4.3', 'Option 4.4'],
    ),
    Question(
      'Question 5',
      ['Option 5.1', 'Option 5.2', 'Option 5.3', 'Option 5.4'],
    ),
    Question(
      'Question 6',
      ['Option 6.1', 'Option 6.2', 'Option 6.3', 'Option 6.4'],
    ),
    Question(
      'Question 7',
      ['Option 7.1', 'Option 7.2', 'Option 7.3', 'Option 7.4'],
    ),
    Question(
      'Question 8',
      ['Option 8.1', 'Option 8.2', 'Option 8.3', 'Option 8.4'],
    ),
    Question(
      'Question 9',
      ['Option 9.1', 'Option 9.2', 'Option 9.3', 'Option 9.4'],
    ),
    Question(
      'Question 10',
      ['Option 10.1', 'Option 10.2', 'Option 10.3', 'Option 10.4'],
    ),
  ];

  List<List<String>> selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    selectedAnswers = List<List<String>>.filled(questions.length, []);
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
          // submit the questionnaire
          print(selectedAnswers);

          // redirect to Home_Page
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DhwaniApp_HomePage()));
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
