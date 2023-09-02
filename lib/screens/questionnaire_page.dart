import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:path_provider/path_provider.dart';

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

  // void _updateCardData() async {
  //   // documents directory path
  //   Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
  //
  //   // paths for files
  //   String cardDataPath = 'assets/dataFiles/card_Data.json';
  //   String updatedCardDataPath = '$appDocumentsDirectory/card_Data_updated.json';
  //
  //   // copy contents from assets to app's document directory
  //   ByteData fileData = await rootBundle.load(cardDataPath);
  //   List<int> bytes = fileData.buffer.asUint8List(fileData.offsetInBytes, fileData.lengthInBytes);
  //   await File(updatedCardDataPath).writeAsBytes(bytes);
  //
  //   // read contents of card_Data.json
  //   String jsonContent = await File(updatedCardDataPath).readAsString();
  //   List<dynamic> jsonData = jsonDecode(jsonContent);
  //
  //   // update isFav value in new file
  //   for (int i=0; i<jsonData.length; i++) {
  //     Map<String, dynamic> cardData = jsonData[i];
  //     String cardTitle = cardData['title'];
  //     bool isFav =  selectedAnswers.any((answers) => answers.contains(cardTitle));
  //     cardData['isFav'] = isFav;
  //   }
  //
  //   // create new copy of file with updated data from questionnaire
  //   String updatedJsonContent = jsonEncode(jsonData);
  //   print(updatedJsonContent);
  //   await File(updatedCardDataPath).writeAsString(updatedJsonContent, flush: true);
  // }
  void _updateCardData() async {
    // Get the path to the app's document directory
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String cardDataPath = '${documentsDirectory.path}/card_Data.json';
    String updatedCardDataPath = '${documentsDirectory.path}/card_Data_updated.json';

    // Check if the card_Data.json file already exists in the document directory
    bool cardDataExists = await File(cardDataPath).exists();
    if (!cardDataExists) {
      // If the file doesn't exist, copy it from the assets folder to the document directory
      ByteData cardDataAsset = await rootBundle.load('assets/dataFiles/card_Data.json');
      List<int> bytes = cardDataAsset.buffer.asUint8List();
      await File(cardDataPath).writeAsBytes(bytes);
    }

    // Read the content of card_Data.json
    File cardDataFile = File(cardDataPath);
    String jsonContent = await cardDataFile.readAsString();
    List<dynamic> jsonData = jsonDecode(jsonContent);

    // Update the isFav value in jsonData based on selectedAnswers
    for (int i = 0; i < jsonData.length; i++) {
      Map<String, dynamic> cardData = jsonData[i];
      String cardTitle = cardData['title'];
      bool isFav = selectedAnswers.any((answers) => answers.contains(cardTitle));
      cardData['isFav'] = isFav;
    }

    // Create a new copy of card_Data.json with updated values
    String updatedJsonContent = jsonEncode(jsonData);
    // print(updatedJsonContent);
    await File(updatedCardDataPath).writeAsString(updatedJsonContent, flush: true);
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
          _updateCardData();

          // redirect to Home_Page
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DhwaniApp_HomePage(selectedAnswers: selectedAnswers)));
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
