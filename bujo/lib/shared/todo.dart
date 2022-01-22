import 'package:bujo/shared/constants.dart';
import 'package:flutter/material.dart';

class TodoInfo {
  final String name;
  final bool done;
  final int category;
  final int order;

  TodoInfo({
    required this.name,
    required this.done,
    required this.category,
    required this.order,
  });
}

List<Color> categoryColors = [
  CheckboxColors.blue,
];
