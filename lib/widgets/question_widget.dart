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

class _QuestionWidgetState extends State<QuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.question.questionText,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 16.0),
          DropdownButton<String>(
            value: widget.question.selectedOption,
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 24.0,
            elevation: 16,
            style: const TextStyle(fontSize: 16.0, color: Colors.black,),
            underline: Container(height: 1, color: Colors.grey,),
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
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}