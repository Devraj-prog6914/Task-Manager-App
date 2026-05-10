import 'package:flutter/material.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String date;
  final bool completed;
  final String priority;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.completed,
    required this.priority,
  });

  Map<String, dynamic> toMap() => {
    'title': title,
    'description': description,
    'date': date,
    'completed': completed,
    'priority': priority,
  };

  factory TaskModel.fromMap(String id, Map<String, dynamic> map) {
    return TaskModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: map['date'] ?? '',
      completed: map['completed'] ?? false,
      priority: map['priority'] ?? 'Medium',
    );
  }

  Color get priorityColor {
    switch (priority) {
      case 'High':
        return Colors.redAccent;
      case 'Medium':
        return Colors.orangeAccent;
      default:
        return Colors.greenAccent;
    }
  }
}
