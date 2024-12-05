import 'dart:ui';

import 'package:calendar/core/extensions/date_format.dart';

class EventModel {
  final int? id;
  final String? createdAt;
  final Color color;
  final String eventName;
  final String eventDescription;
  final DateTime? eventStartTime;
  final DateTime? eventFinishTime;

   EventModel({
    this.id,
    this.createdAt,
    this.color = const Color(0xFFF3F4F6),
    this.eventFinishTime,
    this.eventStartTime,
    this.eventDescription = "",
    this.eventName = "",
  });

  Map<String, Object?> toJson() {
    return {
      'createdAt': createdAt ?? DateTime.now().dateFormat(),
      'eventFinishTime': eventFinishTime?.toIso8601String(),
      'eventStartTime': eventStartTime?.toIso8601String(),
      'color': color.value,
      'eventDescription': eventDescription,
      'eventName': eventName,
    };
  }

  factory EventModel.fromJson(Map<String, Object?> json) {
    return EventModel(
      id: json['id'] as int,
      createdAt: json['createdAt'] as String,
      eventFinishTime: json['eventFinishTime'] != null ? DateTime.parse(json['eventFinishTime'] as String) : null,
      eventStartTime: json['eventStartTime'] != null ? DateTime.parse(json['eventStartTime'] as String) : null,
      eventDescription: json['eventDescription'] as String,
      eventName: json['eventName'] as String,
      color: json['color'] != null ? Color(int.parse(json['color'].toString())) : Color(0xFFF3F4F6),
    );
  }
  DateTime get nowDateTime => DateFormatter.fromDateFormat(createdAt!);


  EventModel copyWith({
    int? id,
    String? createdAt,
    Color? color,
    String? eventName,
    String? eventDescription,
    DateTime? eventStartTime,
    DateTime? eventFinishTime,
  }) {
    return EventModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      color: color ?? this.color,
      eventName: eventName ?? this.eventName,
      eventDescription: eventDescription ?? this.eventDescription,
      eventStartTime: eventStartTime ?? this.eventStartTime,
      eventFinishTime: eventFinishTime ?? this.eventFinishTime,
    );
  }
}
