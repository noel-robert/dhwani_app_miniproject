// ignore_for_file: camel_case_types

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive_flutter/hive_flutter.dart';

import '../models/card_model.dart';
import '../models/question_model.dart';
import '../screens/home_page.dart';
import '../widgets/question_widget.dart';

class DhwaniApp_QuestionnairePage2 extends StatefulWidget {
  final List<List<String>> selectedFavourites;
  const DhwaniApp_QuestionnairePage2({super.key, required this.selectedFavourites});

  @override
  State<DhwaniApp_QuestionnairePage2> createState() => DhwaniApp_QuestionnairePage2State();
}

class DhwaniApp_QuestionnairePage2State extends State<DhwaniApp_QuestionnairePage2> {
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

  // Future<void> _updateCardData() async {
  //   final jsonString = await rootBundle.loadString('assets/dataFiles/questionnaire2.json');
  //   final jsonData = jsonDecode(jsonString);
  //
  //   cardBox = Hive.box('cards_HiveBox');
  //   if (cardBox.isEmpty) { print('The box is empty'); }
  //   List<CardModel> cards = cardBox.values.toList();
  //   print(cards.length);
  //
  //   // load card details to database - debug
  //   int index = 0;
  //   for (final questionData in jsonData) {
  //     String questionEmotion = questionData['questionText'].split(' ').last.trimRight();
  //     // print(questionEmotion);
  //     List<String> currentAnswerList = selectedAnswers[index];
  //
  //     // TODO: iterate through things in currentAnswerList and assign emotion for it
  //     for (String searchValue in currentAnswerList) {
  //       // print(searchValue);
  //       for (CardModel card in cards) {
  //         // print(card.title.toLowerCase());
  //         if (card.title.toLowerCase().contains(searchValue.toLowerCase())) {
  //           int cardIndex = cards.indexWhere((element) => element == card);
  //           var updatedCard = cardBox.getAt(cardIndex) as CardModel;
  //           updatedCard.emotion.add(questionEmotion);
  //           cardBox.putAt(cardIndex, updatedCard);
  //
  //           print(updatedCard.emotion);
  //         }
  //       }
  //     }
  //
  //     index++;
  //   }
  // }

  Future<void> _loadCardDataToHiveAndUpdate() async {
    final jsonString = await DefaultAssetBundle.of(context).loadString('assets/dataFiles/card_Data.json');
    final jsonData = jsonDecode(jsonString);
    // print(jsonData);

    cardBox = Hive.box('cards_HiveBox');
    cardBox.clear();

    // load card details to database - debug
    for (final cardData in jsonData) {
      // instead of below two lines, do this - if cardTitle in List<List<String>> selectedAnswers, then set a boolean variable to true
      final cardTitle = cardData['title'];
      final isFav = widget.selectedFavourites.any((answer) => answer.contains(cardTitle)) ? true : false;

      final card = CardModel(
        imagePath: cardData['imagePath'],
        title: cardTitle,
        isFav: isFav,
        description: cardData['description'],
        malluDescription: cardData['malluDescription'],
        tags: List<String>.from(cardData['tags']),
        clickCount: isFav ? 5 : 0,
        emotion: [],
      );
      cardBox.add(card);
    }

    print("Length of cardbox: ${cardBox.length}");



    final jsonStringQuestionnaire2 = await rootBundle.loadString('assets/dataFiles/questionnaire2.json');
    final jsonDataQuestionnaire2 = jsonDecode(jsonStringQuestionnaire2);

    // cardBox = Hive.box('cards_HiveBox');
    if (cardBox.isEmpty) { print('The box is empty'); }
    List<CardModel> cards = cardBox.values.toList();
    // print('Debug imp: ${cards.length}');

    // load card details to database - debug
    int index = 0;
    for (final questionData in jsonDataQuestionnaire2) {
      String questionEmotion = questionData['questionText'].split(' ').last.trimRight();
      questionEmotion = questionEmotion.substring(0, questionEmotion.length-1);
      print(questionEmotion);
      List<String> currentAnswerList = selectedAnswers[index];

      // TODO: iterate through things in currentAnswerList and assign emotion for it
      for (String searchValue in currentAnswerList) {
        // print(searchValue);
        for (CardModel card in cards) {
          // print(card.title.toLowerCase());
          if (card.title.toLowerCase().contains(searchValue.toLowerCase())) {
            int cardIndex = cards.indexWhere((element) => element == card);
            var updatedCard = cardBox.getAt(cardIndex) as CardModel;
            updatedCard.emotion.add(questionEmotion);
            cardBox.putAt(cardIndex, updatedCard);

            print(updatedCard.emotion);
          }
        }
      }

      index++;
    }
  }

  Future<void> _loadQuestions() async {
    final jsonString =
        await rootBundle.loadString('assets/dataFiles/questionnaire2.json');
    final jsonData = jsonDecode(jsonString);
    // print((jsonData[0])['questionText']);

    // final questionBox = await Hive.openBox<Question>('questions');
    questionBox = Hive.box('questions_HiveBox');
    questionBox.clear(); // clear all data in questionBox

    for (final questionData in jsonData) {
      final questionModelTyped = QuestionModel(
          questionText: questionData['questionText'],
          options: List<String>.from(questionData['options']));

      // final question = Question(
      //   questionModelTyped.questionText,
      //   questionModelTyped.options,
      // );
      // print(questionData['questionText']);
      // print(List<String>.from(questionData['options']));

      questionBox.add(questionModelTyped); // added using index as key - automatically
      // print(question.questionText);
      // print(question.options);
    }

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
              selectedAnswersMap[questions[index].questionText] =
                  selectedOptions.isNotEmpty ? selectedOptions[0] : '';
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Load card data to Hive and set isFav based on selected answers
          // print('Selected Answers Map: $selectedAnswersMap');
          await _loadCardDataToHiveAndUpdate();

          // Print contents of cardBox
          // for (var i = 0; i < cardBox.length; i++) {
          //   final card = cardBox.getAt(i) as CardModel;
          //   print('Card $i: ${card.title}, IsFav: ${card.isFav}');
          // }

          // Redirect to Home_Page

          Navigator.push(context, MaterialPageRoute(builder: (context) => const DhwaniApp_HomePage()));
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
