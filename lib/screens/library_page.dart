import 'package:flutter/cupertino.dart';
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
import 'home_page.dart';

final BottomBarController controller = Get.put(BottomBarController());

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
  List<CardModel> filteredCardList =
      []; // List to store cards filtered using tags

  List<CardModel> selectedCardsList = [];

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
      selectedCardsList.add(card);
      combinedSentence.add(card.title);
      showFilteredCards = false;
    });
  }

  void _removeSelectedCard(CardModel card) {
    setState(() {
      selectedCardsList.remove(card);
      combinedSentence.remove(card.title);
    });
  }

  void _clearSelectedCards() {
    setState(() {
      selectedCardsList.clear();
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
    if (selectedCardsList.isNotEmpty) {
      setState(() {
        selectedCardsList.removeLast();
        combinedSentence.removeLast();
      });
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     appBar: AppBar(
  //       title: const Text('DhwaniApp Library Page'),
  //       elevation: 8,
  //     ),
  //     body: showFilteredCards
  //         ? ListView.builder(
  //             itemCount: filteredCardList.length,
  //             itemBuilder: (context, index) => CustomCardWidget(
  //                 card: filteredCardList[index],
  //                 onTap: () => _onCardTap(filteredCardList[index])),
  //           )
  //         : Column(
  //             children: [
  //               _buildCategoriesList(),
  //               if (selectedCardsList.isNotEmpty)
  //                 Expanded(
  //                   child: ListView.builder(
  //                       itemCount: selectedCardsList.length,
  //                       itemBuilder: (context, index) {
  //                         final selectedCard = selectedCardsList[index];
  //                         return CustomCardWidget(
  //                           card: selectedCard,
  //                           onTap: () => _removeSelectedCard(selectedCard),
  //                         );
  //                       }),
  //                 ),
  //               if (selectedCardsList.isEmpty)
  //                 const SizedBox(
  //                   height: 50,
  //                   child: Center(
  //                     child: Text(
  //                       'No cards selected',
  //                       style: TextStyle(fontSize: 24),
  //                     ),
  //                   ),
  //                 )
  //             ],
  //           ),
  //     bottomNavigationBar: BottomAppBar(
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceAround,
  //         children: [
  //           ElevatedButton(
  //             onPressed: _clearSelectedCards,
  //             child: const Text('Clear Selection'),
  //           ),
  //           ElevatedButton(
  //               onPressed: _onEnterButtonPressed, child: const Text('Enter')),
  //           ElevatedButton(
  //             onPressed: _onBackspacePressed,
  //             child: const Text('Backspace'),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
                selectedCardsList.isNotEmpty
                    ? Container(
                        height: 150,
                        color: Colors.grey[200],
                        child: Row(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: selectedCardsList.length,
                                  itemBuilder: (context, index) {
                                    final selectedCard =
                                        selectedCardsList[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: InkWell(
                                        onTap: () =>
                                            _removeSelectedCard(selectedCard),
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                    selectedCard.imagePath,
                                                    height: 64.0,
                                                    width: 48),
                                                Center(
                                                    child: Text(
                                                        selectedCard.title)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                      onPressed: _clearSelectedCards,
                                      child: const Text('Clear Selection')),
                                  ElevatedButton(
                                      onPressed: _onEnterButtonPressed,
                                      child: const Text('Enter')),
                                  ElevatedButton(
                                      onPressed: _onBackspacePressed,
                                      child: const Text('Backspace')),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                _buildCategoriesList()
              ],
            ),
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
                        context,
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
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const DhwaniApp_SearchPage()));
                  },
                ),
                GButton(
                    icon: LineIcons.camera,
                    text: 'Camera',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const DhwaniApp_CameraPage()));
                    }),
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
