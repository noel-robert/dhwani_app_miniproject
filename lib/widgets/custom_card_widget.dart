// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class CardWidget extends StatefulWidget {
//   final String imagePath;
//   final String title;
//   final Function onUpdate; // Added onUpdate callback function
//   bool isFav;
//   String description;
//   String malluDescription;
//   List<String> tags = [];
//   final bool languageSwitchState;
//
//   CardWidget({
//     Key? key,
//     required this.imagePath,
//     required this.title,
//     required this.isFav,
//     required this.onUpdate, // Added onUpdate parameter
//     required this.description,
//     required this.malluDescription,
//     required this.tags,
//     required this.languageSwitchState,
//   }) : super(key: key);
//
//   @override
//   _CardWidgetState createState() => _CardWidgetState();
// }
//
// class _CardWidgetState extends State<CardWidget> {
//   int counter = 0;
//   late SharedPreferences _prefs;
//
//   @override
//   void initState() {
//     super.initState();
//     initSharedPreferences();
//   }
//
//   // void initSharedPreferences() async {
//   //   _prefs = await SharedPreferences.getInstance();
//   //   setState(() {
//   //     counter = widget.isFav
//   //         ? 1
//   //         : (_prefs.getInt('${widget.title}_clickCount') ??
//   //             0); //edited here to initialise to 1
//   //   });
//   // }
//   void initSharedPreferences() async {
//     _prefs = await SharedPreferences.getInstance();
//     setState(() {
//       counter = _prefs.getInt('${widget.title}_clickCount') ?? 0;
//     });
//   }
//
//   void _incrementCounter() {
//     setState(() {
//       counter++;
//       _prefs.setInt('${widget.title}_clickCount', counter);
//       // widget.onUpdate(); // Call the onUpdate callback function (real time re sorting)
//     });
//   }
//
//   FlutterTts flutterTts = FlutterTts();
//   Future<void> _speakDescription() async {
//     String text = widget.languageSwitchState ? widget.malluDescription : widget.description;
//     String language = widget.languageSwitchState ? 'ml-IN' : 'en-US';
//
//     print(language);  // debug
//     await flutterTts.setLanguage(language);
//     await flutterTts.setPitch(1.0);
//     await flutterTts.speak(text);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: InkWell(
//         onTap: () {
//           _incrementCounter();
//           _speakDescription();
//         },
//         // onTap: () {
//         //   setState(() {
//         //     counter++;
//         //     _prefs.setInt('${widget.title}_clickCount', counter);
//         //   });
//         // },
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               Image.asset(
//                 widget.imagePath,
//                 height: MediaQuery.of(context).size.width * (1 / 4),
//                 width: MediaQuery.of(context).size.width,
//               ),
//               const SizedBox(height: 8.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       widget.title,
//                       style: const TextStyle(fontSize: 18.0),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   Icon(
//                     widget.isFav ? Icons.favorite : Icons.favorite_border,
//                     color: widget.isFav ? Colors.red : null,
//                   )
//                 ],
//               ),
//               Text('Tapped $counter times'), // for demo purposes
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

import 'package:dhwani_app_miniproject/models/card_model.dart';


class CustomCardWidget extends StatelessWidget {
  final CardModel card;
  final VoidCallback onTap;

  CustomCardWidget({required this.card, required this.onTap, });

  @override
  Widget build(BuildContext  context) {
    return Card (
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Image.asset(
                card.imagePath,
                height: MediaQuery.of(context).size.width * (1/4),
                width: MediaQuery.of(context).size.width,
              ),

              const SizedBox(height: 8.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      card.title,
                      style: const TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Icon(
                    card.isFav ? Icons.favorite : Icons.favorite_border,
                    color: card.isFav ? Colors.red : null,
                  ),
                ],
              ),

              Text('Tapped ${card.clickCount} times'),
            ],
          ),
        ),
      ),
    );
  }
}