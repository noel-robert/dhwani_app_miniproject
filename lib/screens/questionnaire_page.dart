import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive_flutter/hive_flutter.dart';

import '../models/card_model.dart';
import '../models/question_model.dart';
import '../screens/home_page.dart';
import '../widgets/question_widget.dart';


class DhwaniApp_QuestionnairePage extends StatefulWidget {
  const DhwaniApp_QuestionnairePage({super.key});

  @override
  _DhwaniApp_QuestionnairePageState createState() => _DhwaniApp_QuestionnairePageState();
}

class _DhwaniApp_QuestionnairePageState extends State<DhwaniApp_QuestionnairePage> {
  List<Question> questions = [];
  List<List<String>> selectedAnswers = [];
  Map<String, String> selectedAnswersMap = {};

  late Box<QuestionModel> questionBox;
  late Box answersBox;
  late Box<CardModel> cardBox;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadCardDataToHiveAndUpdate() async {
    final jsonString = await DefaultAssetBundle.of(context).loadString('assets/dataFiles/card_Data.json');
    final jsonData = jsonDecode(jsonString);

    cardBox = Hive.box('cards_HiveBox');
    cardBox.clear();

    // load card details to database
    for (final cardData in jsonData) {
      final cardTitle = cardData['title'];
      final isFav = selectedAnswersMap[cardTitle] == 'Yes';

      final card = CardModel(
        imagePath: cardData['imagePath'],
        title: cardTitle,
        // isFav: cardData['isFav'],
        isFav: isFav,
        description: cardData['description'],
        malluDescription: cardData['malluDescription'],
        tags: List<String>.from(cardData['tags']),
        clickCount: isFav ? 5 : 0,
      );
      cardBox.add(card);
    }

  }

  Future<void> _loadQuestions() async {
    final jsonString = await rootBundle.loadString('assets/dataFiles/questionnaire_Data.json');
    final jsonData = jsonDecode(jsonString);
    // print((jsonData[0])['questionText']);

    // final questionBox = await Hive.openBox<Question>('questions');
    questionBox = Hive.box('questions_HiveBox');
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
    answersBox = Hive.box('selectedAnswers_HiveBox');
    answersBox.clear();  // clear all data in answersBox

    List<String> selectedAnswer;
    for (selectedAnswer in selectedAnswers) {
      // print(selectedAnswer);
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
              selectedAnswersMap[questions[index].questionText] = selectedOptions.isNotEmpty ? selectedOptions[0] : '';
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: () {
        //   // on submitting the questionnaire
        //   _loadCardDataToHiveAndUpdateFavStatus();
        //   // print(selectedAnswers);
        //   _updateSelectedAnswers();
        //
        //   // redirect to Home_Page
        //   // Navigator.push(context, MaterialPageRoute(builder: (context) => DhwaniApp_HomePage()));
        //
        //   for (var i = 0; i < cardBox.length; i++) {
        //     final card = cardBox.getAt(i) as CardModel; // Assuming your model is named CardModel
        //     print('Card $i: ${card.title}, IsFav: ${card.isFav}');
        //   }
        // },
        onPressed: () async {
          // Load card data to Hive and set isFav based on selected answers
          print('Selected Answers Map: $selectedAnswersMap');
          await _loadCardDataToHiveAndUpdate();

          // Print contents of cardBox
          for (var i = 0; i < cardBox.length; i++) {
            final card = cardBox.getAt(i) as CardModel;
            // print('Card $i: ${card.title}, IsFav: ${card.isFav}');
          }

          // Update selected answers
          _updateSelectedAnswers();

          // Redirect to Home_Page
          Navigator.push(context, MaterialPageRoute(builder: (context) => DhwaniApp_HomePage()));
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}