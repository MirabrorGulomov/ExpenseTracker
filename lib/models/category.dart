import 'dart:io';

import 'package:flutter/material.dart';

enum Categories {
  transport,
  food,
  shopping,
  health,
  lending,
  borrowing,
  family,
  personal,
}

class Category {
  final IconData icon;
  final String title;
  final ImageProvider image;

  const Category(
      {required this.icon, required this.title, required this.image});
}
