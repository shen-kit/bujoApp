import 'package:bujo/screens/logged_in/settings.dart';
import 'package:flutter/material.dart';

Widget screenBase({
  required BuildContext context,
  required String title,
  required String subtitle,
  required bool settings,
  required Widget mainContent,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // header section
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: SizedBox(
          height: 70,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  title,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontFamily: 'Oregano',
                    fontSize: 36,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  subtitle,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontFamily: 'Garamond',
                    fontSize: 16,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    if (settings) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SafeArea(
                            child: Settings(),
                          ),
                        ),
                      );
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(
                    settings ? Icons.settings : Icons.cancel_outlined,
                    size: 36,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Expanded(
        child: Container(
          width: double.infinity,
          height: 400,
          decoration: const BoxDecoration(
            color: Color(0xff000C35),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: mainContent,
        ),
      ),
    ],
  );
}
