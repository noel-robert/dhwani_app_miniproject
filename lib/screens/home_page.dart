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
  // int _selectedBottomBarIndex = 0;
  List<String> image = [
    'assets/PNG/C__Users_abhiv_speech_assets_images_A.png',
    'assets/PNG/C__Users_abhiv_speech_assets_images_B.png',
    'assets/PNG/C__Users_abhiv_speech_assets_images_C.png',
    'assets/PNG/C__Users_abhiv_speech_assets_images_D.png',
    'assets/PNG/C__Users_abhiv_speech_assets_images_E.png'
  ];
  List<String> title = ['A', 'B', 'C', 'D', 'E'];

  List<int> clickCounts = [];

  @override
  void initState() {
    super.initState();
    _loadClickCounts();
  }

  Future<void> _loadClickCounts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      clickCounts = title.map((t) {
        return prefs.getInt('${t}_clickCount') ?? 0;
      }).toList();
    });
  }

  void _updateClickCounts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      clickCounts = title.map((t) {
        return prefs.getInt('${t}_clickCount') ?? 0;
      }).toList();
    });
  }

  // static TextStyle optionStyle = const TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  // final List<Widget> _widgetOptions = <Widget>[
  //   Text('Home', style: optionStyle),
  //   Text('Likes', style: optionStyle),
  //   Text('Search', style: optionStyle),
  //   Text('Profile', style: optionStyle)
  // ];

  bool _languageSwitchState = false; // language is malayalam | english


  @override
  Widget build(BuildContext context) {
    List<int> sortedIndexes =
    List.generate(clickCounts.length, (index) => index)
      ..sort((a, b) => clickCounts[b].compareTo(clickCounts[a]));

    List<String> sortedImages =
    sortedIndexes.map((index) => image[index]).toList();
    List<String> sortedTitles =
    sortedIndexes.map((index) => title[index]).toList();


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
                      color: _languageSwitchState ? Colors.green : Colors.red
                  ),
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
                            color: Colors.white
                        ),
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
                itemCount: sortedImages.length,
                itemBuilder: (context, index) => CardWidget(
                  imagePath: sortedImages[index],
                  title: sortedTitles[index],
                  isFav: false,
                  onUpdate: _updateClickCounts,
                ),
              ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  blurRadius: 20,
                  color: Colors.black.withOpacity(.1)
              )
            ]
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap:8,
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