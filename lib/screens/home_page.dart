import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:line_icons/line_icons.dart';

import '../controllers/bottom_bar_controller.dart';
import '../models/card_model.dart';
import '../widgets/custom_card_widget.dart';



// class DhwaniApp_HomePage extends StatefulWidget {
//   @override
//   _DhwaniApp_HomePageState createState() => _DhwaniApp_HomePageState();
// }
//
// final BottomBarController controller = Get.put(BottomBarController());
//
// class _DhwaniApp_HomePageState extends State<DhwaniApp_HomePage> {
//   late Box<CardModel> cardBox;
//   bool _languageSwitchState = false; // language is malayalam | english
//   bool _isNewUser = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _openCardBox();
//
//   }
//
//   Future<void> _openCardBox() async {
//     cardBox = await Hive.openBox<CardModel>('cards');
//     _checkIfNewUser();
//   }
//
//   Future<void> _checkIfNewUser() async {
//     if (cardBox.isEmpty) {
//       await _loadData();
//       _isNewUser = true;
//     } else {
//       _isNewUser = false;
//     }
//   }
//
//   Future<void> _loadData() async {
//     final jsonString = await DefaultAssetBundle.of(context).loadString('assets/dataFiles/card_Data.json');
//     // print(jsonString);
//     final jsonData = jsonDecode(jsonString);
//
//     // Remove this line if you want to keep existing data in the box
//     cardBox.clear();
//
//     for (final cardData in jsonData) {
//       final card = CardModel(
//         imagePath: cardData['imagePath'],
//         title: cardData['title'],
//         isFav: cardData['isFav'],
//         description: cardData['description'],
//         malluDescription: cardData['malluDescription'],
//         tags: List<String>.from(cardData['tags']),
//         clickCount: 0,
//       );
//       cardBox.add(card);
//     }
//   }
//
//   // void _incrementCounter(CardModel card) {
//   //   setState(() {
//   //     card.clickCount++;
//   //     card.save();  // update database
//   //   });
//   // }
//   void _incrementCounter(CardModel card) {
//     final cardIndex = cardBox.values.toList().indexWhere((c) => c == card);
//
//     if (cardIndex != -1) {
//       final updatedCard = cardBox.getAt(cardIndex);
//       updatedCard?.clickCount++;
//       // updatedCard?.save(); // temporary comment /*TODO*/
//     }
//     //setState(() {});
//   }
//
//   void _toggleLanguageSwitch() {
//     setState(() {
//       _languageSwitchState = !_languageSwitchState;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<void>(
//         future: _openCardBox(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             final List<CardModel> cards = _isNewUser ? cardBox.values.toList() : cardBox.values.toList()..sort((a, b) => b.clickCount.compareTo(a.clickCount));
//             return Scaffold(
//               backgroundColor: Colors.white,
//               appBar: AppBar(
//                 title: const Text('DhwaniApp HomePage'),
//                 // backgroundColor: Colors.transparent,
//                 elevation: 8,
//               ),
//               body: ValueListenableBuilder(
//                 valueListenable: cardBox.listenable(),
//                 builder: (context, box, widget) {
//                   return GridView.builder(
//                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       crossAxisSpacing: 10,
//                       mainAxisSpacing: 10,
//                     ),
//                     itemCount: cards.length,
//                     itemBuilder: (context, index) {
//                       final card = cards[index];
//                       return CustomCardWidget(
//                         card: card,
//                         onTap: () => _incrementCounter(card),
//                       );
//                     }
//                   );
//                 },
//               ),
//               bottomNavigationBar: Container(
//                 decoration: BoxDecoration(color: Colors.white, boxShadow: [
//                   BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
//                 ]),
//                 child: SafeArea(
//                   child: Padding(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//                     child: GNav(
//                       rippleColor: Colors.grey[300]!,
//                       hoverColor: Colors.grey[100]!,
//                       gap: 8,
//                       activeColor: Colors.black,
//                       iconSize: 24,
//                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                       duration: const Duration(milliseconds: 400),
//                       tabBackgroundColor: Colors.grey[100]!,
//                       color: Colors.black,
//                       tabs: [
//                         GButton(
//                           icon: LineIcons.home,
//                           text: 'Home',
//                           onPressed: () {},
//                         ),
//                         GButton(
//                           icon: LineIcons.book,
//                           text: 'Libraries',
//                           onPressed: () {},
//                         ),
//                         GButton(
//                           icon: LineIcons.search,
//                           text: 'Search',
//                           onPressed: () {},
//                         ),
//                         GButton(
//                           icon: LineIcons.microphone,
//                           text: 'Speak',
//                           onPressed: () {},
//                         ),
//                       ],
//                       selectedIndex: controller.selectedIndex,
//                       onTabChange: (index) {
//                         setState(() {
//                           controller.updateIndex(index);
//                         });
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           } else {
//             return const Scaffold(
//               body: Center(child: CircularProgressIndicator(),),
//             );
//           }
//         }
//     );
//   }
// }


class DhwaniApp_HomePage extends StatefulWidget {
  @override
  _DhwaniApp_HomePageState createState() => _DhwaniApp_HomePageState();
}

final BottomBarController controller = Get.put(BottomBarController());

class _DhwaniApp_HomePageState extends State<DhwaniApp_HomePage> {
  late Box<CardModel> cardBox;
  bool _languageSwitchState = false; // language is malayalam | english
  // bool _isNewUser = true;

  @override
  void initState() {
    super.initState();
    _openCardBox();
  }

  void _openCardBox() {
    cardBox = Hive.box('cards_HiveBox');
    // _checkIfNewUser();
  }

  // Future<void> _checkIfNewUser() async {
  //   if (cardBox.isEmpty) {
  //     await _loadData();
  //     _isNewUser = true;
  //   } else {
  //     _isNewUser = false;
  //   }
  // }

  // Future<void> _loadData() async {
  //   final jsonString = await DefaultAssetBundle.of(context).loadString('assets/dataFiles/card_Data.json');
  //   // print(jsonString);
  //   final jsonData = jsonDecode(jsonString);
  //
  //   // Remove this line if you want to keep existing data in the box
  //   cardBox.clear();
  //
  //   for (final cardData in jsonData) {
  //     final card = CardModel(
  //       imagePath: cardData['imagePath'],
  //       title: cardData['title'],
  //       isFav: cardData['isFav'],
  //       description: cardData['description'],
  //       malluDescription: cardData['malluDescription'],
  //       tags: List<String>.from(cardData['tags']),
  //       clickCount: 0,
  //     );
  //     cardBox.add(card);
  //   }
  // }

  void _incrementCounter(CardModel card) {
    final cardIndex = cardBox.values.toList().indexWhere((c) => c == card);

    if (cardIndex >= 0) {
      var updatedCard = cardBox.getAt(cardIndex) as CardModel;
      updatedCard.clickCount++;
      cardBox.putAt(cardIndex, updatedCard);

      print('Incremented click count for ${updatedCard.title} to ${updatedCard.clickCount}');
      // setState(() {});
    }
    //setState(() {});
  }

  // void _toggleLanguageSwitch() {
  //   setState(() {
  //     _languageSwitchState = !_languageSwitchState;
  //   });
  // }

  Widget _buildCardList() {
    // debug
    // if (cardBox==null || cardBox.isEmpty) { print('The box is empty'); }
    // for (var key in cardBox.keys) {
    //   var card = cardBox.get(key) as CardModel;
    //   print('Card $key:');
    //   print('Image Path: ${card.imagePath}');
    //   print('Title: ${card.title}');
    //   print('Is Favorite: ${card.isFav}');
    //   print('Description: ${card.description}');
    //   print('Mallu Description: ${card.malluDescription}');
    //   print('Tags: ${card.tags}');
    //   print('Click Count: ${card.clickCount}');
    //   print('-------------------');
    // }

    if (cardBox != null) {
      List<CardModel> cards = cardBox.values.toList()..sort((a, b) => b.clickCount.compareTo(a.clickCount));
      return ValueListenableBuilder(
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
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('DhwaniApp HomePage'),
        // backgroundColor: Colors.transparent,
        elevation: 8,
      ),
      // body: FutureBuilder<void>(
      //   future: _openCardBox(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       // final List<CardModel> cards = _isNewUser
      //       //     ? cardBox.values.toList()
      //       //     : cardBox.values.toList()
      //       //   ..sort((a, b) => b.clickCount.compareTo(a.clickCount));
      //       final List<CardModel> cards = cardBox.values.toList()..sort((a, b) => b.clickCount.compareTo(a.clickCount));
      //       return ValueListenableBuilder(
      //         valueListenable: cardBox.listenable(),
      //         builder: (context, box, widget) {
      //           return GridView.builder(
      //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      //               crossAxisCount: 2,
      //               crossAxisSpacing: 10,
      //               mainAxisSpacing: 10,
      //             ),
      //             itemCount: cards.length,
      //             itemBuilder: (context, index) {
      //               final card = cards[index];
      //               return CustomCardWidget(
      //                 card: card,
      //                 onTap: () => _incrementCounter(card),
      //               );
      //             },
      //           );
      //         },
      //       );
      //     } else {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //   },
      // ),
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
