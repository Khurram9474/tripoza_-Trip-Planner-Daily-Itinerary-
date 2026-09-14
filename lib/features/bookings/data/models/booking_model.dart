import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'booking_model.g.dart';

@HiveType(typeId: 2)
enum BookingStatus {
  @HiveField(0)
  pending,
  @HiveField(1)
  confirmed,
  @HiveField(2)
  cancelled,
  @HiveField(3)
  completed,
}

@HiveType(typeId: 3)
class BookingModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String bookingId; // e.g. TRP-2026-8F42A1

  @HiveField(2)
  final String customerName;

  @HiveField(3)
  final String phone;

  @HiveField(4)
  final String email;

  @HiveField(5)
  final String serviceId;

  @HiveField(6)
  final String serviceName;

  @HiveField(7)
  final String serviceCategory;

  @HiveField(8)
  final DateTime bookingDate;

  @HiveField(9)
  final int numberOfPeople;

  @HiveField(10)
  final double pricePerPerson;

  @HiveField(11)
  final double totalAmount;

  @HiveField(12)
  final String specialRequest;

  @HiveField(13)
  final BookingStatus status;

  @HiveField(14)
  final DateTime createdAt;

  const BookingModel({
    required this.id,
    required this.bookingId,
    required this.customerName,
    required this.phone,
    required this.email,
    required this.serviceId,
    required this.serviceName,
    required this.serviceCategory,
    required this.bookingDate,
    required this.numberOfPeople,
    required this.pricePerPerson,
    required this.totalAmount,
    this.specialRequest = '',
    this.status = BookingStatus.confirmed,
    required this.createdAt,
  });

  BookingModel copyWith({
    String? id,
    String? bookingId,
    String? customerName,
    String? phone,
    String? email,
    String? serviceId,
    String? serviceName,
    String? serviceCategory,
    DateTime? bookingDate,
    int? numberOfPeople,
    double? pricePerPerson,
    double? totalAmount,
    String? specialRequest,
    BookingStatus? status,
    DateTime? createdAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      bookingId: bookingId ?? this.bookingId,
      customerName: customerName ?? this.customerName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      serviceCategory: serviceCategory ?? this.serviceCategory,
      bookingDate: bookingDate ?? this.bookingDate,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      pricePerPerson: pricePerPerson ?? this.pricePerPerson,
      totalAmount: totalAmount ?? this.totalAmount,
      specialRequest: specialRequest ?? this.specialRequest,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'bookingId': bookingId,
    'customerName': customerName,
    'phone': phone,
    'email': email,
    'serviceId': serviceId,
    'serviceName': serviceName,
    'serviceCategory': serviceCategory,
    'bookingDate': bookingDate.toIso8601String(),
    'numberOfPeople': numberOfPeople,
    'pricePerPerson': pricePerPerson,
    'totalAmount': totalAmount,
    'specialRequest': specialRequest,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
  };

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      bookingId: json['bookingId'] as String,
      customerName: json['customerName'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      serviceId: json['serviceId'] as String,
      serviceName: json['serviceName'] as String,
      serviceCategory: json['serviceCategory'] as String,
      bookingDate: DateTime.parse(json['bookingDate'] as String),
      numberOfPeople: json['numberOfPeople'] as int,
      pricePerPerson: (json['pricePerPerson'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      specialRequest: json['specialRequest'] as String? ?? '',
      status: BookingStatus.values.byName(json['status'] as String? ?? 'confirmed'),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  List<Object?> get props => [
    id,
    bookingId,
    customerName,
    phone,
    email,
    serviceId,
    serviceName,
    serviceCategory,
    bookingDate,
    numberOfPeople,
    pricePerPerson,
    totalAmount,
    specialRequest,
    status,
    createdAt,
  ];
}