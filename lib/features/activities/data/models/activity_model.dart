import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'activity_model.g.dart';

@HiveType(typeId: 1)
class ActivityModel extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int day; // 1-based day number within the trip

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String time; // stored as "HH:mm" 24-hour string

  @HiveField(4)
  final String location;

  @HiveField(5)
  final String category; // one of AppConstants.activityCategories

  @HiveField(6)
  final String description;

  const ActivityModel({
    required this.id,
    required this.day,
    required this.name,
    required this.time,
    required this.location,
    required this.category,
    this.description = '',
  });

  ActivityModel copyWith({
    String? id,
    int? day,
    String? name,
    String? time,
    String? location,
    String? category,
    String? description,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      day: day ?? this.day,
      name: name ?? this.name,
      time: time ?? this.time,
      location: location ?? this.location,
      category: category ?? this.category,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'day': day,
    'name': name,
    'time': time,
    'location': location,
    'category': category,
    'description': description,
  };

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] as String,
      day: json['day'] as int,
      name: json['name'] as String,
      time: json['time'] as String,
      location: json['location'] as String,
      category: json['category'] as String,
      description: json['description'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, day, name, time, location, category, description];
}