// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReviewModelAdapter extends TypeAdapter<ReviewModel> {
  @override
  final int typeId = 4;

  @override
  ReviewModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReviewModel(
      id: fields[0] as String,
      serviceId: fields[1] as String,
      serviceName: fields[2] as String,
      userName: fields[3] as String,
      avatarUrl: fields[4] as String?,
      rating: fields[5] as int,
      reviewText: fields[6] as String,
      imageUrl: fields[7] as String?,
      createdAt: fields[8] as DateTime,
      helpfulCount: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ReviewModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.serviceId)
      ..writeByte(2)
      ..write(obj.serviceName)
      ..writeByte(3)
      ..write(obj.userName)
      ..writeByte(4)
      ..write(obj.avatarUrl)
      ..writeByte(5)
      ..write(obj.rating)
      ..writeByte(6)
      ..write(obj.reviewText)
      ..writeByte(7)
      ..write(obj.imageUrl)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.helpfulCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
