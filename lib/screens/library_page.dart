import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dhwani_app_miniproject/main.dart';
import '../controllers/bottom_bar_controller.dart';
import '../models/card_model.dart';
import '../screens/search_page.dart';
import '../screens/camera_page.dart';
import '../widgets/custom_card_widget.dart';

class DhwaniApp_LibraryPage extends StatefulWidget {
  const DhwaniApp_LibraryPage({super.key});

  @override
  State<DhwaniApp_LibraryPage> createState() => DhwaniApp_LibraryPageState();
}

class DhwaniApp_LibraryPageState extends State<DhwaniApp_LibraryPage> {
  late Box<CardModel> cardBox;
  List<String> categories = [
    'Food',
    'Drinks',
    'Snack',
    'Activity',
    'Emotion',
    'Body',
    'Clothing',
    'Kitchen',
    'School',
    'Animals',
    'Technology',
    'Weather',
    'Plants',
    'Sports',
    'Transport',
    'Places',
    'Toys',
    'Actions',
    'Questions',
    'Hygiene',
    'Number'
  ];

  bool showFilteredCards = false; // State variable to show filtered cards
  List<CardModel> filteredCardList = []; // List to store filtered cards
  List<CardModel> selectedCardTexts = [];

  List<String> combinedSentence = [];
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _openCardBox();
  }

  void _openCardBox() {
    cardBox = Hive.box('cards_HiveBox');
  }

  // generate the different categories
  Widget _buildCategoriesList() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        children: List.generate(categories.length, (index) {
          final category = categories[index];
          return InkWell(
            onTap: () => _navigateToCardList(category),
            child: Card(
              child: Center(
                child: Text(category),
              ),
            ),
          );
        }),
      ),
    );
  }

  void _navigateToCardList(String category) async {
    final filteredCards =
        cardBox.values.where((card) => card.tags.contains(category)).toList();
    setState(() {
      showFilteredCards = true;
      filteredCardList = filteredCards;
    });
  }

  // on tapping a card, push it to top section
  void _onCardTap(CardModel card) {
    setState(() {
      selectedCardTexts.add(card);
      combinedSentence.add(card.title);
      showFilteredCards = false;
    });
  }

  void _removeSelectedCard(CardModel card) {
    setState(() {
      selectedCardTexts.remove(card);
      combinedSentence.remove(card.title);
    });
  }

  void _clearSelectedCards() {
    setState(() {
      selectedCardTexts.clear();
      combinedSentence.clear();
    });
  }

  void _onEnterButtonPressed() async {
    String text = combinedSentence.join(' ');
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1.0);
    await flutterTts.speak(text);
  }

  void _onBackspacePressed() {
    if (selectedCardTexts.isNotEmpty) {
      setState(() {
        selectedCardTexts.removeLast();
        combinedSentence.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('DhwaniApp Library Page'),
        elevation: 8,
      ),
      body: showFilteredCards
          ? ListView.builder(
              itemCount: filteredCardList.length,
              itemBuilder: (context, index) => CustomCardWidget(
                  card: filteredCardList[index],
                  onTap: () => _onCardTap(filteredCardList[index])),
            )
          : Column(
              children: [
                _buildCategoriesList(),
                if (selectedCardTexts.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                        itemCount: selectedCardTexts.length,
                        itemBuilder: (context, index) {
                          final selectedCard = selectedCardTexts[index];
                          return CustomCardWidget(
                            card: selectedCard,
                            onTap: () => _removeSelectedCard(selectedCard),
                          );
                        }),
                  ),
                if (selectedCardTexts.isEmpty)
                  const SizedBox(
                    height: 50,
                    child: Center(
                      child: Text(
                        'No cards selected',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  )
              ],
            ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: _clearSelectedCards,
              child: const Text('Clear Selection'),
            ),
            ElevatedButton(
                onPressed: _onEnterButtonPressed, child: const Text('Enter')),
            ElevatedButton(
              onPressed: _onBackspacePressed,
              child: const Text('Backspace'),
            ),
          ],
        ),
      ),
    );
  }
}
