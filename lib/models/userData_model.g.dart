// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userData_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDataModelAdapter extends TypeAdapter<UserDataModel> {
  @override
  final int typeId = 1;

  @override
  UserDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserDataModel(
      username: fields[0] as String,
      password: fields[1] as String,
      email: fields[2] as String,
      gender: fields[3] as String?,
      bloodGroup: fields[4] as String?,
      contactNumber: fields[5] as String,
      disabilityType: fields[6] as String,
      guardianName: fields[7] as String,
      guardianRelation: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserDataModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.password)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.gender)
      ..writeByte(4)
      ..write(obj.bloodGroup)
      ..writeByte(5)
      ..write(obj.contactNumber)
      ..writeByte(6)
      ..write(obj.disabilityType)
      ..writeByte(7)
      ..write(obj.guardianName)
      ..writeByte(8)
      ..write(obj.guardianRelation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
