import 'package:flutter/material.dart';

class Question {
  final String questionText;
  final List<String> options;
  String? selectedOption; // Add selectedOption property

  Question(this.questionText, this.options);
}

class QuestionWidget extends StatefulWidget {
  final Question question;
  final Function(List<String>) onAnswerSelected;

  QuestionWidget({required this.question, required this.onAnswerSelected});

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

// class _QuestionWidgetState extends State<QuestionWidget> {
//   List<String> selectedOptions = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//           child: Text(
//             widget.question.questionText,
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 18.0,
//             ),
//           ),
//         ),
//         ListView.builder(
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//           itemCount: widget.question.options.length,
//           itemBuilder: (BuildContext context, int index) {
//             final option = widget.question.options[index];
//             return ListTile(
//               leading: Checkbox(
//                 value: selectedOptions.contains(option),
//                 onChanged: (bool? value) {
//                   setState(() {
//                     if (value != null && value) {
//                       selectedOptions.add(option);
//                     } else {
//                       selectedOptions.remove(option);
//                     }
//                     widget.onAnswerSelected(selectedOptions);
//                   });
//                 },
//               ),
//               title: Text(option),
//             );
//           }
//         )
//       ],
//     );
//   }
// }

class _QuestionWidgetState extends State<QuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.question.questionText,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          SizedBox(height: 16.0),
          DropdownButton<String>(
            value: widget.question.selectedOption,
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24.0,
            elevation: 16,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
            underline: Container(
              height: 1,
              color: Colors.grey,
            ),
            onChanged: (value) {
              setState(() {
                widget.question.selectedOption = value;
                widget.onAnswerSelected([value!]);
              });
            },
            items: widget.question.options.map((option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
          ),
          SizedBox(height: 16.0),
        ],
      ),
    );
  }
}