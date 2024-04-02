import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../models/card_model.dart';
import 'package:huggingface_dart/huggingface_dart.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class CreateCardPage extends StatefulWidget {
  const CreateCardPage({Key? key}) : super(key: key);

  @override
  _CreateCardPageState createState() => _CreateCardPageState();
}

class _CreateCardPageState extends State<CreateCardPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final hf = HfInference('your token here');

  String tag = 'None';
  bool isFav = false;
  File? imageFile;
  String? imagePath;

  bool isLoading = false;

  Future<void> _assignTag() async {
    setState(() {
      isLoading = true;
    });

    var result = await hf.zeroShotClassification(
      inputs: [descriptionController.text],
      parameters: {
        "candidate_labels": [
          'food',
          'drinks',
          'numbers',
          'play',
          'weather',
          'animals'
        ]
      },
      model: "facebook/bart-large-mnli",
    );
    var labels = result[0]['labels'];
    var scores = result[0]['scores'];
    var maxScore = scores.reduce((curr, next) => curr > next ? curr : next);
    var maxScoreIndex = scores.indexOf(maxScore);
    setState(() {
      tag = labels[maxScoreIndex];
      isLoading = false;
    });
  }

  Future<String> _translateToMalayalam(String text) async {
    var result = await hf.translate(
      inputs: [text],
      model: "Helsinki-NLP/opus-mt-en-ml",
    );
    return result[0]['translation_text'];
  }

  Future<void> _getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final Directory appDirectory = await getApplicationDocumentsDirectory();
      String newPath =
          '${appDirectory.path}/${DateTime.now().toIso8601String()}.png';
      imageFile = File(pickedImage.path);
      await imageFile!.copySync(newPath);
      setState(() {
        imagePath = newPath;
      });
    }
  }

  Future<void> _createCard() async {
    setState(() {
      isLoading = true;
    });

    String malluDescription =
        await _translateToMalayalam(descriptionController.text);
    var decodedDescription = utf8.decode(malluDescription.runes.toList());
    int clickCount = isFav ? 5 : 0;

    CardModel newCard = CardModel(
      title: titleController.text,
      description: descriptionController.text,
      tags: [tag],
      imagePath: imagePath!,
      isFav: isFav,
      malluDescription: decodedDescription,
      clickCount: clickCount,
      emotion: [],
    );

    var box = await Hive.openBox<CardModel>('cards_HiveBox');
    await box.add(newCard);

    setState(() {
      isLoading = false;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Card'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: ElevatedButton(
                      child: Text('Generate Tag'),
                      onPressed: _assignTag,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(11.7),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Tag: $tag',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                CheckboxListTile(
                  title: Text('Favorite', style: TextStyle(fontSize: 18)),
                  value: isFav,
                  onChanged: (value) {
                    setState(() {
                      isFav = value!;
                    });
                  },
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: _getImage,
                    child: Text('Upload Image'),
                  ),
                ),
                Center(
                  child: imagePath == null
                      ? Image.asset(
                          'assets/PNG/logomask.png',
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(imagePath!),
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed:
                        imagePath != null && !isLoading ? _createCard : null,
                    child: Text('Create Card'),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
