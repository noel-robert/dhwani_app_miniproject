import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:huggingface_dart/huggingface_dart.dart';
import 'package:line_icons/line_icons.dart';
import 'package:string_similarity/string_similarity.dart';

import '../controllers/bottom_bar_controller.dart';
import '../models/card_model.dart';
import '../screens/home_page.dart';
import '../widgets/custom_card_widget.dart';
import 'camera_page.dart';

class DhwaniApp_SearchPage extends StatefulWidget {
  const DhwaniApp_SearchPage({Key? key}) : super(key: key);

  @override
  State<DhwaniApp_SearchPage> createState() => DhwaniApp_SearchPageState();
}

final BottomBarController controller = Get.put(BottomBarController());

class DhwaniApp_SearchPageState extends State<DhwaniApp_SearchPage> {
  late Box<CardModel> cardBox;
  String searchValue = '';
  bool _languageSwitchState = false; // language is malayalam | english
  final hf = HfInference('your token here');
  FlutterTts flutterTts = FlutterTts();
  List<String> completedSentences = [];

  @override
  void initState() {
    super.initState();
    _openCardBox();
  }

  void _openCardBox() {
    cardBox = Hive.box('cards_HiveBox');
  }

  void _incrementCounter(CardModel card) {
    final cardIndex = cardBox.values.toList().indexWhere((c) => c == card);

    if (cardIndex >= 0) {
      var updatedCard = cardBox.getAt(cardIndex) as CardModel;
      updatedCard.clickCount++;
      cardBox.putAt(cardIndex, updatedCard);
    }
  }

  Future<void> _speakDescription(CardModel card) async {
    String language = _languageSwitchState ? 'ml-IN' : 'en-US';
    final cardIndex = cardBox.values.toList().indexWhere((c) => c == card);

    if (cardIndex >= 0) {
      var selectedCard = cardBox.getAt(cardIndex) as CardModel;
      String text = _languageSwitchState
          ? selectedCard.malluDescription
          : selectedCard.description;
      await flutterTts.setLanguage(language);
      await flutterTts.setPitch(1.0);
      await flutterTts.speak(text);
    }
  }

  void _toggleVocalLanguage() {
    setState(() {
      _languageSwitchState = !_languageSwitchState;
    });
  }

  Future<void> _fillMask(String inputText) async {
    final List completions = await hf.fillMask(
      model: 'bert-base-uncased',
      inputs: ['$inputText [MASK] .'],
    );

    if (completions.isEmpty) {
      print('No completion found.');
    } else {
      List<String> filteredSentences = [];
      for (var completion in completions) {
        String sentence = capitalize(completion['sequence'].toString());
        if (!_containsBlacklistedWords(sentence)) {
          filteredSentences.add(sentence);
        }
      }
      setState(() {
        completedSentences = filteredSentences;
      });
    }
  }

  bool _containsBlacklistedWords(String sentence) {
    List<String> blacklistedWords = [
      'alcohol',
      'kill',
      'die',
      'wank',
      'cry',
      'depress',
      'bomb',
      'blood'
    ];
    for (var word in blacklistedWords) {
      if (sentence.toLowerCase().contains(word)) {
        return true;
      }
    }
    return false;
  }

  Future<void> _speak(String text) async {
    await flutterTts.speak(text);
  }

  String capitalize(String s) {
    if (s.isEmpty) return s;

    s = s.replaceAllMapped(RegExp(r'\bi\b'), (match) => 'I');

    return s[0].toUpperCase() + s.substring(1);
  }

  void _onTextChanged() {
    String inputText = searchValue;
    if (inputText.isNotEmpty) {
      _fillMask(inputText);
    }
  }

  Widget _buildCardList() {
    if (cardBox != null) {
      List<CardModel> cards = cardBox.values.toList()
        ..sort((a, b) => b.clickCount.compareTo(a.clickCount));
      List<CardModel> filtered = [];
      for (CardModel card in cards) {
        if (card.title.toLowerCase().contains(searchValue.toLowerCase()) ||
            card.tags.any((tag) =>
                StringSimilarity.compareTwoStrings(
                    tag.toLowerCase(), searchValue) >
                0.5)) {
          filtered.add(card);
        }
      }
      return Column(children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchValue = value;
                      _onTextChanged(); // Call the _onTextChanged method
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    hintStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor:
                        const Color(0xFFF3D6F5), // Set the background color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none, // Remove the border
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: _languageSwitchState,
          onChanged: (value) {
            _toggleVocalLanguage();
          },
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: cardBox.listenable(),
            builder: (context, box, widget) {
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final card = filtered[index];
                    return CustomCardWidget(
                        card: card,
                        onTap: () => {
                              _speakDescription(card),
                              _incrementCounter(card),
                            });
                  });
            },
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: ListView.builder(
            itemCount: completedSentences.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  _speak(completedSentences[index]);
                },
                child: Card(
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      completedSentences[index],
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ]);
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentContext = context;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('DhwaniApp SearchPage'),
        elevation: 8,
      ),
      body: _buildCardList(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1)),
        ]),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: [
                GButton(
                  icon: LineIcons.home,
                  text: 'Home',
                  onPressed: () {
                    Navigator.push(
                        currentContext,
                        MaterialPageRoute(
                            builder: (context) => const DhwaniApp_HomePage()));
                  },
                ),
                GButton(
                  icon: LineIcons.book,
                  text: 'Libraries',
                  onPressed: () {},
                ),
                GButton(
                  icon: LineIcons.search,
                  text: 'Search',
                  onPressed: () {},
                ),
                GButton(
                  icon: LineIcons.camera,
                  text: 'Camera',
                  onPressed: () {
                    Navigator.push(
                        currentContext,
                        MaterialPageRoute(
                            builder: (context) =>
                                const DhwaniApp_CameraPage()));
                  },
                ),
              ],
              selectedIndex: controller.selectedIndex,
              onTabChange: (index) {
                setState(() {
                  controller.updateIndex(index);
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
