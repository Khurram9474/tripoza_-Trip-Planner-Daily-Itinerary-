// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookingModelAdapter extends TypeAdapter<BookingModel> {
  @override
  final int typeId = 3;

  @override
  BookingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookingModel(
      id: fields[0] as String,
      bookingId: fields[1] as String,
      customerName: fields[2] as String,
      phone: fields[3] as String,
      email: fields[4] as String,
      serviceId: fields[5] as String,
      serviceName: fields[6] as String,
      serviceCategory: fields[7] as String,
      bookingDate: fields[8] as DateTime,
      numberOfPeople: fields[9] as int,
      pricePerPerson: fields[10] as double,
      totalAmount: fields[11] as double,
      specialRequest: fields[12] as String,
      status: fields[13] as BookingStatus,
      createdAt: fields[14] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, BookingModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.bookingId)
      ..writeByte(2)
      ..write(obj.customerName)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.serviceId)
      ..writeByte(6)
      ..write(obj.serviceName)
      ..writeByte(7)
      ..write(obj.serviceCategory)
      ..writeByte(8)
      ..write(obj.bookingDate)
      ..writeByte(9)
      ..write(obj.numberOfPeople)
      ..writeByte(10)
      ..write(obj.pricePerPerson)
      ..writeByte(11)
      ..write(obj.totalAmount)
      ..writeByte(12)
      ..write(obj.specialRequest)
      ..writeByte(13)
      ..write(obj.status)
      ..writeByte(14)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BookingStatusAdapter extends TypeAdapter<BookingStatus> {
  @override
  final int typeId = 2;

  @override
  BookingStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BookingStatus.pending;
      case 1:
        return BookingStatus.confirmed;
      case 2:
        return BookingStatus.cancelled;
      case 3:
        return BookingStatus.completed;
      default:
        return BookingStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, BookingStatus obj) {
    switch (obj) {
      case BookingStatus.pending:
        writer.writeByte(0);
        break;
      case BookingStatus.confirmed:
        writer.writeByte(1);
        break;
      case BookingStatus.cancelled:
        writer.writeByte(2);
        break;
      case BookingStatus.completed:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
