import 'package:flutter/material.dart';

void showBottomEditBar(context, child) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25),
      ),
    ),
    builder: (context) {
      return Container(
        padding: EdgeInsets.only(
          top: 20,
          right: 40,
          left: 40,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: child,
      );
    },
  );
}
