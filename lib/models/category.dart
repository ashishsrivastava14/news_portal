import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final IconData icon;
  final String color;
  final int articleCount;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    this.color = '#1E88E5',
    this.articleCount = 0,
  });

  Category copyWith({
    String? id,
    String? name,
    IconData? icon,
    String? color,
    int? articleCount,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      articleCount: articleCount ?? this.articleCount,
    );
  }
}
