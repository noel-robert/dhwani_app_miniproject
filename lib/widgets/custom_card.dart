import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CardWidget extends StatefulWidget {
  final String imagePath;
  final String title;
  bool isFav;
  final Function onUpdate; // Added onUpdate callback function

  CardWidget({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.isFav,
    required this.onUpdate, // Added onUpdate parameter
  }) : super(key: key);

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  int counter = 0;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
  }

  void initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      counter = _prefs.getInt('${widget.title}_clickCount') ?? 0;
    });
  }

  void _incrementCounter() {
    setState(() {
      counter++;
      _prefs.setInt('${widget.title}_clickCount', counter);
      //widget.onUpdate(); // Call the onUpdate callback function (real time re sorting)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: _incrementCounter,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SvgPicture.asset(
                widget.imagePath,
                height: MediaQuery.of(context).size.width * (1 / 4),
                width: MediaQuery.of(context).size.width,
              ),
              const SizedBox(height: 8.0),
              Text(widget.title),
              const SizedBox(height: 8.0),
              Text('Tapped $counter times'),
            ],
          ),
        ),
      ),
    );
  }
}