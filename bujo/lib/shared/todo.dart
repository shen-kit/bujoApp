import 'package:bujo/shared/constants.dart';
import 'package:flutter/material.dart';

class TodoInfo {
  String? docId;
  final String name;
  final bool done;
  final int category;
  final int order;

  TodoInfo({
    this.docId,
    required this.name,
    required this.done,
    required this.category,
    required this.order,
  });
}

List<Color> todoCategoryColors = [
  CheckboxColors.white,
  CheckboxColors.red,
  CheckboxColors.yellow,
  CheckboxColors.blue,
];
