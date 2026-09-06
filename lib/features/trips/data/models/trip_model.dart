import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import '../../../activities/data/models/activity_model.dart';

part 'trip_model.g.dart';

@HiveType(typeId: 0)
class TripModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String destination;

  @HiveField(3)
  final DateTime startDate;

  @HiveField(4)
  final DateTime endDate;

  @HiveField(5)
  final int travelers;

  @HiveField(6)
  final String description;

  @HiveField(7)
  final List<ActivityModel> activities;

  @HiveField(8)
  final DateTime createdAt;

  const TripModel({
    required this.id,
    required this.name,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.travelers,
    this.description = '',
    this.activities = const [],
    required this.createdAt,
  });

  TripModel copyWith({
    String? id,
    String? name,
    String? destination,
    DateTime? startDate,
    DateTime? endDate,
    int? travelers,
    String? description,
    List<ActivityModel>? activities,
    DateTime? createdAt,
  }) {
    return TripModel(
      id: id ?? this.id,
      name: name ?? this.name,
      destination: destination ?? this.destination,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      travelers: travelers ?? this.travelers,
      description: description ?? this.description,
      activities: activities ?? this.activities,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'destination': destination,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'travelers': travelers,
    'description': description,
    'activities': activities.map((a) => a.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
  };

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'] as String,
      name: json['name'] as String,
      destination: json['destination'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      travelers: json['travelers'] as int,
      description: json['description'] as String? ?? '',
      activities: (json['activities'] as List<dynamic>? ?? [])
          .map((a) => ActivityModel.fromJson(a as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    destination,
    startDate,
    endDate,
    travelers,
    description,
    activities,
    createdAt,
  ];
}