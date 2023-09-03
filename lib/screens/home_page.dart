import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:line_icons/line_icons.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../controllers/bottom_bar_controller.dart';
import '../widgets/custom_card_widget.dart';
import 'package:dhwani_app_miniproject/models/card_model.dart';


class DhwaniApp_HomePage extends StatefulWidget {
  @override
  _DhwaniApp_HomePageState createState() => _DhwaniApp_HomePageState();
}

final BottomBarController controller = Get.put(BottomBarController());

class _DhwaniApp_HomePageState extends State<DhwaniApp_HomePage> {
  late Box<CardModel> cardBox;
  bool _languageSwitchState = false; // language is malayalam | english
  bool _isNewUser = true;

  @override
  void initState() {
    super.initState();
    _openCardBox();
    _checkIfNewUser();
  }

  Future<void> _openCardBox() async {
    cardBox = await Hive.openBox<CardModel>('cards');
  }

  Future<void> _checkIfNewUser() async {
    if (cardBox.isEmpty) {
      await _loadData();
      _isNewUser = true;
    } else {
      _isNewUser = false;
    }
  }

  Future<void> _loadData() async {
    final jsonString = await DefaultAssetBundle.of(context).loadString('assets/dataFiles/card_Data.json');
    // print(jsonString);
    final jsonData = jsonDecode(jsonString);

    // Remove this line if you want to keep existing data in the box
    cardBox.clear();

    for (final cardData in jsonData) {
      final card = CardModel(
        imagePath: cardData['imagePath'],
        title: cardData['title'],
        isFav: cardData['isFav'],
        description: cardData['description'],
        malluDescription: cardData['malluDescription'],
        tags: List<String>.from(cardData['tags']),
        clickCount: 0,
      );
      cardBox.add(card);
    }
  }

  void _incrementCounter(CardModel card) {
    setState(() {
      card.clickCount++;
      card.save();  // update database
    });
  }

  void _toggleLanguageSwitch() {
    setState(() {
      _languageSwitchState = !_languageSwitchState;
    });
  }

  @override
  Widget build(BuildContext context) {
    // List<int> sortedIndexes =
    //     List.generate(clickCounts.length, (index) => index)
    //       ..sort((a, b) => clickCounts[b].compareTo(clickCounts[a]));
    //
    // List<CardWidget> sortedCards =
    //     sortedIndexes.map((index) => cards[index]).toList();
    //
    // // update isFav value from selectedAnswers
    // for (int i = 0; i < widget.selectedAnswers.length; i++) {
    //   List<String> selectedOptions = widget.selectedAnswers[i];
    //   if (selectedOptions.isNotEmpty) {
    //     String selectedOption = selectedOptions.first;
    //
    //     for (int j = 0; j < sortedCards.length; j++) {
    //       if (sortedCards[j].title == selectedOption) {
    //         setState(() {
    //           sortedCards[j].isFav = true;
    //         });
    //         break;
    //       }
    //     }
    //   }
    // }
    final List<CardModel> cards = _isNewUser ? cardBox.values.toList() : cardBox.values.toList()..sort((a, b) => b.clickCount.compareTo(a.clickCount));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('DhwaniApp HomePage'),
        // backgroundColor: Colors.transparent,
        elevation: 8,
      ),

      // body: Column(
      //   children: [
      //     Padding(
      //       padding: const EdgeInsets.all(8.0),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.end,
      //         children: [
      //           const Text(
      //             'MALAYALAM',
      //             style: TextStyle(
      //               fontSize: 16.0,
      //               fontWeight: FontWeight.bold,
      //             ),
      //           ),
      //           const SizedBox(width: 16.0),
      //           Ink(
      //             height: 26.0,
      //             width: 40.0,
      //             decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(25.0),
      //                 color: _languageSwitchState ? Colors.green : Colors.red),
      //             child: InkWell(
      //               // onTap: () {
      //               //   setState(() {
      //               //     _languageSwitchState = !_languageSwitchState;
      //               //   });
      //               // },
      //               onTap: _toggleLanguageSwitch,
      //               borderRadius: BorderRadius.circular(25.0),
      //               child: Center(
      //                 child: Text(
      //                   _languageSwitchState ? 'ON' : 'OFF',
      //                   style: const TextStyle(
      //                       fontSize: 13.0,
      //                       fontWeight: FontWeight.bold,
      //                       color: Colors.white),
      //                 ),
      //               ),
      //             ),
      //           )
      //         ],
      //       ),
      //     ),
      //     Expanded(
      //       child: GridView.builder(
      //         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //           crossAxisCount: 2,
      //           mainAxisSpacing: 10,
      //           crossAxisSpacing: 10,
      //         ),
      //         itemCount: sortedCards.length,
      //         itemBuilder: (context, index) => sortedCards[index],
      //       ),
      //     )
      //   ],
      // ),
      body: ValueListenableBuilder(
        valueListenable: cardBox.listenable(),
        builder: (context, box, widget) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];
              return CustomCardWidget(
                card: card,
                onTap: () => _incrementCounter(card),
              );
            }
          );
        },
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
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
                  onPressed: () {},
                ),
                GButton(
                  icon: LineIcons.search,
                  text: 'Search',
                  onPressed: () {},
                ),
                GButton(
                  icon: LineIcons.microphone,
                  text: 'Speak',
                  onPressed: () {},
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
