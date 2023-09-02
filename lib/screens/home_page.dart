import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/bottom_bar_controller.dart';
import '../widgets/custom_card_widget.dart';

class DhwaniApp_HomePage extends StatefulWidget {
  final List<List<String>> selectedAnswers;

  const DhwaniApp_HomePage({Key? key, required this.selectedAnswers})
      : super(key: key);

  @override
  _DhwaniApp_HomePageState createState() => _DhwaniApp_HomePageState();
}

final BottomBarController controller = Get.put(BottomBarController());

class _DhwaniApp_HomePageState extends State<DhwaniApp_HomePage> {
  List<CardWidget> cards = [];
  List<int> clickCounts = [];
  bool _languageSwitchState = false; // language is malayalam | english

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadClickCounts();
  }

  Future<void> _loadData() async {
    // get app documents directory
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String cardDataPath = '${appDocumentsDirectory.path}/card_Data_updated.json';

    String jsonContent = await File(cardDataPath).readAsString();
    print(jsonContent);
    List<dynamic> jsonData = jsonDecode(jsonContent);

    // setState(() {
    //   cards = jsonData
    //       .map((data) => CardWidget(
    //             imagePath: data['imagePath'],
    //             title: data['title'],
    //             isFav: data['isFav'],
    //             onUpdate: _updateClickCounts,
    //             description: data['description'],
    //             malluDescription: data['malluDescription'],
    //             tags: List<String>.from(data['tags']),
    //             languageSwitchState: _languageSwitchState,
    //           ))
    //       .toList();
    // });
    List<CardWidget> tempCards = jsonData.map((data) {
      return CardWidget(
        imagePath: data['imagePath'],
        title: data['title'],
        isFav: data['isFav'],
        onUpdate: _updateClickCounts,
        description: data['description'],
        malluDescription: data['malluDescription'],
        tags: List<String>.from(data['tags']),
        languageSwitchState: _languageSwitchState,
      );
    }).toList();

    setState(() {
      cards = tempCards;
    });
  }

  Future<void> _loadClickCounts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      clickCounts = cards.map((card) {
        return prefs.getInt('${card.title}_clickCount') ?? 0;
      }).toList();
    });
  }

  void _updateClickCounts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      clickCounts = cards.map((card) {
        return prefs.getInt('${card.title}_clickCount') ?? 0;
      }).toList();
    });
  }
  // void _updateClickCounts() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     for (var card in cards) {
  //       int clickCount = prefs.getInt('${card.title}_clickCount') ?? 0;
  //       if (card.isFav) { clickCount += 10; }
  //       prefs.setInt('${card.title}_clickCount', clickCount);
  //     }
  //     clickCounts = cards.map((card) {
  //       return prefs.getInt('${card.title}_clickCount') ?? 0;
  //     }).toList();
  //   });
  // }
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //       _updateClickCounts();
  // }
  // @override
  // void didUpdateWidget(DhwaniApp_HomePage oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if(oldWidget.selectedAnswers != widget.selectedAnswers) {
  //     _updateClickCounts();
  //   }
  // }

  void _toggleLanguageSwitch() {
    setState(() {
      _languageSwitchState = !_languageSwitchState;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<int> sortedIndexes =
        List.generate(clickCounts.length, (index) => index)
          ..sort((a, b) => clickCounts[b].compareTo(clickCounts[a]));

    List<CardWidget> sortedCards =
        sortedIndexes.map((index) => cards[index]).toList();

    // update isFav value from selectedAnswers
    for (int i = 0; i < widget.selectedAnswers.length; i++) {
      List<String> selectedOptions = widget.selectedAnswers[i];
      if (selectedOptions.isNotEmpty) {
        String selectedOption = selectedOptions.first;

        for (int j = 0; j < sortedCards.length; j++) {
          if (sortedCards[j].title == selectedOption) {
            setState(() {
              sortedCards[j].isFav = true;
            });
            break;
          }
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('DhwaniApp HomePage'),
        // backgroundColor: Colors.transparent,
        elevation: 8,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'MALAYALAM',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16.0),
                Ink(
                  height: 26.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      color: _languageSwitchState ? Colors.green : Colors.red),
                  child: InkWell(
                    // onTap: () {
                    //   setState(() {
                    //     _languageSwitchState = !_languageSwitchState;
                    //   });
                    // },
                    onTap: _toggleLanguageSwitch,
                    borderRadius: BorderRadius.circular(25.0),
                    child: Center(
                      child: Text(
                        _languageSwitchState ? 'ON' : 'OFF',
                        style: const TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: sortedCards.length,
              itemBuilder: (context, index) => sortedCards[index],
            ),
          )
        ],
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
