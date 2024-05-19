import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';

import '../controllers/bottom_bar_controller.dart';
import '../main.dart';
import '../screens/library_page.dart';
import '../screens/home_page.dart';
import '../screens/search_page.dart';

class DhwaniApp_CameraPage extends StatefulWidget {
  const DhwaniApp_CameraPage({super.key});

  @override
  State<DhwaniApp_CameraPage> createState() => DhwaniApp_CameraPageState();
}

final BottomBarController controller = Get.put(BottomBarController());

class DhwaniApp_CameraPageState extends State<DhwaniApp_CameraPage> {
  String output = '';
  late File _imageFile;
  String _targetEmotion = '';

  @override
  void initState() {
    super.initState();
    loadModel();
    _setTargetEmotion();
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  Future getImage(var source) async {
    XFile? imageFile;
    if (source == 'camera') {
      output = 'null';
      imageFile = await ImagePicker()
          .pickImage(source: ImageSource.camera); // to take from camera,
    } else if (source == 'gallery') {
      output = 'null';
      imageFile = await ImagePicker()
          .pickImage(source: ImageSource.gallery); // to take from gallery,
    } else {
      // unreachable case
    }

    setState(() {
      if (imageFile != null) {
        _imageFile = File(imageFile.path);
      }
    });
  }

  runModel() async {
    var predictions = await Tflite.runModelOnImage(path: _imageFile.path);

    for (var element in predictions!) {
      setState(() {
        output = element['label'];
        _showMatchMessage(output);
      });
    }
  }

  loadModel() async {
    // await Tflite.loadModel(
    //   model: "assets/cnnModels/fer_model.tflite",
    //   labels: "assets/cnnModels/fer_labels.txt",
    // );
    await Tflite.loadModel(
      model: "assets/cnnModels/ferplus_model_pd_best.tflite",
      labels: "assets/cnnModels/fer_model.txt",
    );
  }

  void _showMatchMessage(String predictedEmotion) {
    if (predictedEmotion == _targetEmotion) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Congratulations! Matched Emotions"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 5),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Try Again. Not matched"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  void _setTargetEmotion() {
    // List<String> emotions = ['angry', 'fear', 'happy', 'sad', 'surprise'];
    List<String> emotions = ['anger', 'fear', 'happy', 'sad', 'surprised', 'neutral', 'disgust', 'contempt'];
    _targetEmotion = emotions[Random().nextInt(emotions.length)];
  }

  String getIconForEmotion(String emotion) {
    // switch (emotion) {
    //   case 'angry':
    //     return '\u{1F621}';
    //   case 'fear':
    //     return '\u{1F630}';
    //   case 'happy':
    //     return '\u{1F600}';
    //   case 'sad':
    //     return '\u{1F61E}';
    //   case 'surprise':
    //     return '\u{1F62E}';
    //   default:
    //     return '';
    // }
    final Map<String, List<String>> emojiMap = {
      'anger': ['\u{1F620}', '\u{1F621}'],
      'fear': ['\u{1F628}', '\u{1F630}'],
      'happy': ['\u{1F600}', '\u{1F601}', '\u{1F60A}'],
      'sad': ['\u{1F622}', '\u{1F61E}'],
      'surprised': ['\u{1F632}', '\u{1F62E}'],
      'neutral': ['\u{1F610}', '\u{1F611}'],
      'disgust': ['\u{1F922}', '\u{1F612}'],
      'contempt': ['\u{1F624}', '\u{1F644}']
    };

    // final random = Random();

    if (emojiMap.containsKey(emotion)) {
      final emojis = emojiMap[emotion]!;
      // return emojis[random.nextInt(emojis.length)];
      return emojis[0];
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final prefsProvider = Provider.of<SharedPrefsProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Emotion Analysis')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                getIconForEmotion(_targetEmotion),
                style: const TextStyle(fontSize: 72),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'HintEmotion: $_targetEmotion',
              style: const TextStyle(fontSize: 12, color: Colors.green),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              'Emotion: $output',
              style: const TextStyle(fontSize: 24, color: Colors.green),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async => {
                await runModel(),
                await prefsProvider.prefs.setString('current_emotion', output)
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                backgroundColor: Colors.blueAccent,
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
              ),
              child: const Text(
                'Upload',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              onPressed: () => setState(() => _setTargetEmotion()),
              child: const Icon(Icons.refresh),
            ),
          ],
        ),
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
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DhwaniApp_LibraryPage()));
                  },
                ),
                GButton(
                  icon: LineIcons.search,
                  text: 'Search',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const DhwaniApp_SearchPage()));
                  },
                ),
                GButton(
                  icon: LineIcons.camera,
                  text: 'Camera',
                  onPressed: () {}
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => getImage('camera'),
            heroTag: null,
            backgroundColor: Colors.blue,
            child: const Icon(Icons.camera_alt_rounded),
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            onPressed: () => getImage('gallery'),
            heroTag: null,
            backgroundColor: Colors.blue,
            child: const Icon(Icons.image_rounded),
          )
        ],
      ),
    );
  }
}
