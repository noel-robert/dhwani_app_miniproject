import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/card_model.dart';
import 'package:huggingface_dart/huggingface_dart.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CreateCardPage extends StatefulWidget {
  const CreateCardPage({Key? key}) : super(key: key);

  @override
  _CreateCardPageState createState() => _CreateCardPageState();
}

class _CreateCardPageState extends State<CreateCardPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final hf = HfInference('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');

  String tag = 'none'; // Default tag is none
  bool isFav = false; // Default value for isFav
  File? imageFile; // File to store the picked image

  Future<void> _assignTag() async {
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
    });
  }

  Future<String> _translateToMalayalam(String text) async {
    var result = await hf.translate(
      inputs: [text],
      model: "Helsinki-NLP/opus-mt-en-ml",
    );
    return result[0]['translation_text'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Card'),
      ),
      body: Padding(
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
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _assignTag,
            ),
            Text('Tag: $tag'),
            CheckboxListTile(
              title: Text('Favorite'),
              value: isFav,
              onChanged: (value) {
                setState(() {
                  isFav = value!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String malluDescription =
                    await _translateToMalayalam(descriptionController.text);

                // Ensure proper encoding for Malayalam text
                var decodedDescription =
                    utf8.decode(malluDescription.runes.toList());

                // Set clickCount based on whether the card is marked as favorite
                int clickCount = isFav ? 5 : 0;

                CardModel newCard = CardModel(
                  title: titleController.text,
                  description: descriptionController.text,
                  tags: [tag],
                  imagePath: 'assets/PNG/noodles.png',
                  isFav: isFav,
                  malluDescription: decodedDescription,
                  clickCount: clickCount,
                  emotion: [],
                );

                // Open the Hive box
                var box = await Hive.openBox<CardModel>('cards_HiveBox');

                // Add the new card to the box
                await box.add(newCard);

                // Navigate back to the home page
                Navigator.pop(context);
              },
              child: Text('Create Card'),
            ),
          ],
        ),
      ),
    );
  }
}
