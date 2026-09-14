import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'review_model.g.dart';

@HiveType(typeId: 4)
class ReviewModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String serviceId;

  @HiveField(2)
  final String serviceName;

  @HiveField(3)
  final String userName;

  @HiveField(4)
  final String? avatarUrl;

  @HiveField(5)
  final int rating; // 1-5

  @HiveField(6)
  final String reviewText;

  @HiveField(7)
  final String? imageUrl;

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  final int helpfulCount;

  const ReviewModel({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.userName,
    this.avatarUrl,
    required this.rating,
    required this.reviewText,
    this.imageUrl,
    required this.createdAt,
    this.helpfulCount = 0,
  });

  ReviewModel copyWith({
    String? id,
    String? serviceId,
    String? serviceName,
    String? userName,
    String? avatarUrl,
    int? rating,
    String? reviewText,
    String? imageUrl,
    DateTime? createdAt,
    int? helpfulCount,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      serviceName: serviceName ?? this.serviceName,
      userName: userName ?? this.userName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      rating: rating ?? this.rating,
      reviewText: reviewText ?? this.reviewText,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      helpfulCount: helpfulCount ?? this.helpfulCount,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'serviceId': serviceId,
    'serviceName': serviceName,
    'userName': userName,
    'avatarUrl': avatarUrl,
    'rating': rating,
    'reviewText': reviewText,
    'imageUrl': imageUrl,
    'createdAt': createdAt.toIso8601String(),
    'helpfulCount': helpfulCount,
  };

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      serviceId: json['serviceId'] as String,
      serviceName: json['serviceName'] as String,
      userName: json['userName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      rating: json['rating'] as int,
      reviewText: json['reviewText'] as String,
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      helpfulCount: json['helpfulCount'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [
    id,
    serviceId,
    serviceName,
    userName,
    avatarUrl,
    rating,
    reviewText,
    imageUrl,
    createdAt,
    helpfulCount,
  ];
}