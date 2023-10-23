// class UserData {
//   final String username;
//   final String password;
//   final String email;
//   final String? gender;
//   final String? bloodGroup;
//   final String contactNumber;
//   final String disabilityType;
//   final String guardianName;
//   final String guardianRelation;
//
//   UserData({
//     required this.username,
//     required this.password,
//     required this.email,
//     required this.gender,
//     required this.bloodGroup,
//     required this.contactNumber,
//     required this.disabilityType,
//     required this.guardianName,
//     required this.guardianRelation,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'username': username,
//       'password': password,
//       'email': email,
//       'gender': gender,
//       'bloodGroup': bloodGroup,
//       'contactNumber': contactNumber,
//       'disabilityType': disabilityType,
//       'guardianName': guardianName,
//       'guardianRelation': guardianRelation,
//     };
//   }
// }

import 'package:hive/hive.dart';

part 'userData_model.g.dart';

@HiveType(typeId: 1)
class UserDataModel {
  @HiveField(0)
  late String username;

  @HiveField(1)
  late String password;

  @HiveField(2)
  late String email;

  @HiveField(3)
  late String? gender;

  @HiveField(4)
  late String? bloodGroup;

  @HiveField(5)
  late String contactNumber;

  @HiveField(6)
  late String disabilityType;

  @HiveField(7)
  late String guardianName;

  @HiveField(8)
  late String guardianRelation;

  UserDataModel({
    required this.username,
    required this.password,
    required this.email,
    required this.gender,
    required this.bloodGroup,
    required this.contactNumber,
    required this.disabilityType,
    required this.guardianName,
    required this.guardianRelation,
  });
}