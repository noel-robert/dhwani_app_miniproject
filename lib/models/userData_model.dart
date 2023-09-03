class UserData {
  final String username;
  final String password;
  final String email;
  final String? gender;
  final String? bloodGroup;
  final String contactNumber;
  final String disabilityType;
  final String guardianName;
  final String guardianRelation;

  UserData({
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

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'email': email,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'contactNumber': contactNumber,
      'disabilityType': disabilityType,
      'guardianName': guardianName,
      'guardianRelation': guardianRelation,
    };
  }
}