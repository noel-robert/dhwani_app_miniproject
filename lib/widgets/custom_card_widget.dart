import 'dart:io';
import 'package:flutter/material.dart';

import '../models/card_model.dart';

class CustomCardWidget extends StatelessWidget {
  final CardModel card;
  final VoidCallback onTap;

  CustomCardWidget({required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          onTap();
          print('Card tapped: ${card.title}');
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Image.asset(
              //   card.imagePath,
              //   height: MediaQuery.of(context).size.width * (1/4),
              //   width: MediaQuery.of(context).size.width,
              // ),
              if (card.imagePath[0] == '/')
                Image.file(
                  File(card.imagePath),
                )
              else
                Image.asset(
                  card.imagePath,
                ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Expanded(
                  //   child: Text(
                  //     card.title,
                  //     style: const TextStyle(fontSize: 12.0),
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
                  //
                  // Icon(
                  //   card.isFav ? Icons.favorite : Icons.favorite_border,
                  //   color: card.isFav ? Colors.red : null,
                  //   size: 16,
                  // ),
                  Flexible(
                    flex: 3, // Adjust flex factor as needed
                    child: Text(
                      card.title,
                      style: const TextStyle(fontSize: 12.0),
                      textAlign: TextAlign.start, // Align text to the left
                      overflow: TextOverflow.ellipsis, // Handle overflow with ellipsis
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    card.isFav ? Icons.favorite : Icons.favorite_border,
                    color: card.isFav ? Colors.red : null,
                    size: 16,
                  ),
                ],
              ),

              // this causes overflow, and was used for debugging only
              // Text('Tapped ${card.clickCount} times'),
            ],
          ),
        ),
      ),
    );
  }
}
