import 'package:hive/hive.dart';

part 'question_model.g.dart';

@HiveType(typeId: 2)
class QuestionModel {
  @HiveField(0)
  late String questionText;

  @HiveField(1)
  late List<String> options;

  QuestionModel({
    required this.questionText,
    required this.options,
  });
}