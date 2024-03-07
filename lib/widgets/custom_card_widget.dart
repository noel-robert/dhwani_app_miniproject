import 'package:flutter/material.dart';

import '../models/card_model.dart';


class CustomCardWidget extends StatelessWidget {
  final CardModel card;
  final VoidCallback onTap;

  CustomCardWidget({required this.card, required this.onTap});

  @override
  Widget build(BuildContext  context) {
    return Card (
      child: InkWell(
        onTap: () {
          onTap();
          print('Card tapped: ${card.title}');
        },
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