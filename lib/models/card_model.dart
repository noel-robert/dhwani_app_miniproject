import 'package:hive/hive.dart';

part 'card_model.g.dart';

@HiveType(typeId: 0)
class CardModel {
  @HiveField(0)
  late String imagePath;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late bool isFav;

  @HiveField(3)
  late String description;

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
}