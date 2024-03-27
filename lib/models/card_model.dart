import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'dart:io';

part 'card_model.g.dart';

@HiveType(typeId: 0)
class CardModel {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late String imagePath;

  @HiveField(3)
  late bool isFav;

  @HiveField(4)
  late String malluDescription;

  @HiveField(5)
  late List<String> tags;

  @HiveField(6)
  late int clickCount;

  @HiveField(7)
  late List<String> emotion;

  CardModel({
    required this.imagePath,
    required this.title,
    required this.isFav,
    required this.description,
    required this.malluDescription,
    required this.tags,
    required this.clickCount,
    required this.emotion,
  });

  Image getImage() {
    if (imagePath.startsWith('/')) {
      // The imagePath is a file path, not an asset path
      return Image.file(File(imagePath));
    } else {
      // The imagePath is an asset path
      return Image.asset(imagePath);
    }
  }
}
