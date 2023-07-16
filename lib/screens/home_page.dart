import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/bottom_bar_controller.dart';
import '../widgets/custom_card.dart';

class DhwaniApp_HomePage extends StatefulWidget {
  const DhwaniApp_HomePage({Key? key}) : super(key: key);

  @override
  _DhwaniApp_HomePageState createState() => _DhwaniApp_HomePageState();
}

final BottomBarController controller = Get.put(BottomBarController());

class _DhwaniApp_HomePageState extends State<DhwaniApp_HomePage> {
  List<CardWidget> cards = [
    CardWidget(
        imagePath: 'assets/PNG/sleep_male_,_to.png',
        title: 'Sleep',
        isFav: false,
        onUpdate: () {},
        description: 'I am feeling sleepy',
        malluDescription: 'എനിക്ക് ഉറക്കം വരുന്നു',
        tags: ['sleep', 'sleepy', 'nap', 'rest']),
    CardWidget(
        imagePath: 'assets/PNG/eat_,_to.png',
        title: 'Eat',
        isFav: false,
        onUpdate: () {},
        description: 'I am hungry',
        malluDescription: 'എനിക്ക് വിശക്കുന്നു',
        tags: ['Hungry', 'food']),
    CardWidget(
        imagePath: 'assets/PNG/stomach_ache.png',
        title: 'Sick',
        isFav: false,
        onUpdate: () {},
        description: 'I am sick',
        malluDescription: 'എനിക്ക് സുഖമില്ല',
        tags: ['Sick', 'not feeling well', 'ill', 'illness']),
    CardWidget(
        imagePath: 'assets/PNG/play_area.png',
        title: 'Play',
        isFav: false,
        onUpdate: () {},
        description: 'I want to go to play',
        malluDescription: 'എനിക്ക് കളിക്കാൻ പോകണം',
        tags: ['play', 'running', 'go outside']),
    CardWidget(
        imagePath: 'assets/PNG/comedy_tv.png',
        title: 'Televisison',
        isFav: false,
        onUpdate: () {},
        description: 'I want to watch tv',
        malluDescription: 'എനിക്ക് ടിവി കാണണം',
        tags: ['tv', 'television', 'watch']),
    CardWidget(
        imagePath: 'assets/PNG/A.png',
        title: 'A',
        isFav: false,
        onUpdate: () {},
        description: 'temp_placeholder',
        malluDescription: 'temp_placeholder',
        tags: ['temp_placeholder']),
    CardWidget(
        imagePath: 'assets/PNG/B.png',
        title: 'B',
        isFav: false,
        onUpdate: () {},
        description: 'temp_placeholder',
        malluDescription: 'temp_placeholder',
        tags: ['temp_placeholder']),
    CardWidget(
        imagePath: 'assets/PNG/C.png',
        title: 'C',
        isFav: false,
        onUpdate: () {},
        description: 'temp_placeholder',
        malluDescription: 'temp_placeholder',
        tags: ['temp_placeholder']),
    CardWidget(
        imagePath: 'assets/PNG/D.png',
        title: 'D',
        isFav: false,
        onUpdate: () {},
        description: 'temp_placeholder',
        malluDescription: 'temp_placeholder',
        tags: ['temp_placeholder']),
    CardWidget(
        imagePath: 'assets/PNG/E.png',
        title: 'E',
        isFav: false,
        onUpdate: () {},
        description: 'temp_placeholder',
        malluDescription: 'temp_placeholder',
        tags: ['temp_placeholder'])
  ];

  List<int> clickCounts = [];

  @override
  void initState() {
    super.initState();
    _loadClickCounts();
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

  bool _languageSwitchState = false; // language is malayalam | english

  @override
  Widget build(BuildContext context) {
    List<int> sortedIndexes =
        List.generate(clickCounts.length, (index) => index)
          ..sort((a, b) => clickCounts[b].compareTo(clickCounts[a]));

    List<CardWidget> sortedCards =
        sortedIndexes.map((index) => cards[index]).toList();

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
                    onTap: () {
                      setState(() {
                        _languageSwitchState = !_languageSwitchState;
                      });
                    },
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
