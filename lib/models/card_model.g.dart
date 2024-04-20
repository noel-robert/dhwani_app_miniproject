// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CardModelAdapter extends TypeAdapter<CardModel> {
  @override
  final int typeId = 0;

  @override
  CardModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CardModel(
      imagePath: fields[2] as String,
      title: fields[0] as String,
      isFav: fields[3] as bool,
      description: fields[1] as String,
      malluDescription: fields[4] as String,
      tags: (fields[5] as List).cast<String>(),
      clickCount: fields[6] as int,
      emotion: (fields[7] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, CardModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.imagePath)
      ..writeByte(3)
      ..write(obj.isFav)
      ..writeByte(4)
      ..write(obj.malluDescription)
      ..writeByte(5)
      ..write(obj.tags)
      ..writeByte(6)
      ..write(obj.clickCount)
      ..writeByte(7)
      ..write(obj.emotion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
