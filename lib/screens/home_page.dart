import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import 'package:dhwani_app_miniproject/main.dart';
import '../controllers/bottom_bar_controller.dart';
import '../models/card_model.dart';
import '../screens/search_page.dart';
import '../screens/camera_page.dart';
import '../screens/createcard_page.dart';
import '../screens/library_page.dart';
import '../widgets/custom_card_widget.dart';


class DhwaniApp_HomePage extends StatefulWidget {
  const DhwaniApp_HomePage({Key? key}) : super(key: key);

  @override
  State<DhwaniApp_HomePage> createState() => DhwaniApp_HomePageState();
}

final BottomBarController controller = Get.put(BottomBarController());

class DhwaniApp_HomePageState extends State<DhwaniApp_HomePage> {
  late Box<CardModel> cardBox;
  bool _languageSwitchState = false; // language is malayalam | english

  // bool _isNewUser = true;
  String currentEmotion = "";

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
      var updatedCard = cardBox.getAt(cardIndex)!;
      updatedCard.clickCount++;
      cardBox.putAt(cardIndex, updatedCard);
    }
  }

  FlutterTts flutterTts = FlutterTts();

  Future<void> _speakDescription(CardModel card) async {
    String language = _languageSwitchState ? 'ml-IN' : 'en-US';
    final cardIndex = cardBox.values.toList().indexWhere((c) => c == card);

    if (cardIndex >= 0) {
      var selectedCard = cardBox.getAt(cardIndex)!;
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

  int compareCards(CardModel a, CardModel b) {
    if (a.emotion.contains(currentEmotion) !=
        b.emotion.contains(currentEmotion)) {
      return a.emotion.contains(currentEmotion) ? -1 : 1; // True before False
    }
    // If matching is the same, sort by click count (descending)
    return b.clickCount - a.clickCount;
  }

  Widget _buildCardList() {
    List<CardModel> cards = cardBox.values.toList()..sort(compareCards);

    return Column(children: [
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
                crossAxisCount: 3,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
              ),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];
                return CustomCardWidget(
                  card: card,
                  onTap: () => {
                    _speakDescription(card),
                    _incrementCounter(card),
                  },
                );
              },
            );

          },
        ),
      )
    ]);
    }

  @override
  Widget build(BuildContext context) {
    final currentContext = context;
    final prefsProvider = Provider.of<SharedPrefsProvider>(context);
    currentEmotion = prefsProvider.prefs.getString('current_emotion') ?? '';
    //print(currentEmotion);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('DhwaniApp HomePage'),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Colors.red,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(currentContext,
                  MaterialPageRoute(builder: (context) => const CreateCardPage()));
            },
          ),
        ],
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
                  onPressed: () {},
                ),
                GButton(
                  icon: LineIcons.book,
                  text: 'Libraries',
                  onPressed: () {
                    Navigator.push(
                        currentContext,
                        MaterialPageRoute(
                            builder: (context) => const DhwaniApp_LibraryPage()));
                  },
                ),
                GButton(
                  icon: LineIcons.search,
                  text: 'Search',
                  onPressed: () {
                    Navigator.push(
                        currentContext,
                        MaterialPageRoute(
                            builder: (context) => const DhwaniApp_SearchPage()));
                  },
                ),
                GButton(
                  icon: LineIcons.camera,
                  text: 'Camera',
                  onPressed: () {
                    Navigator.push(
                        currentContext,
                        MaterialPageRoute(
                            builder: (context) => const DhwaniApp_CameraPage()));
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
