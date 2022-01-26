import 'package:bujo/services/auth.dart';
import 'package:bujo/shared/constants.dart';
import 'package:bujo/shared/screen_base.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenBase(
        context: context,
        title: 'Settings',
        subtitle: 'Make the app your own',
        settings: false,
        mainContent: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Text(
                'Appearance',
                style: headerStyle,
              ),
              const SizedBox(height: 8),
              SettingsCard(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Theme',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    FaIcon(
                      FontAwesomeIcons.solidMoon,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // SettingsCard(
              //   onPressed: () {},
              //   child: Align(
              //     alignment: Alignment.centerLeft,
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: const [
              //         Text(
              //           'My Day Quote',
              //           style: TextStyle(
              //             fontSize: 16,
              //             fontWeight: FontWeight.w400,
              //           ),
              //         ),
              //         SizedBox(height: 5),
              //         Text(
              //           'Make the most of it',
              //           style: TextStyle(
              //             fontFamily: 'Garamond',
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 8),
              SettingsCard(
                onPressed: () {},
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Habits Quote',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Every action is a vote for who you will become',
                        style: TextStyle(
                          fontFamily: 'Garamond',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Account',
                style: headerStyle,
              ),
              const SizedBox(height: 8),
              SettingsCard(
                onPressed: () async {
                  await AuthService().signOut();
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Sign Out',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Icon(
                      Icons.logout,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SettingsCard(
                delete: true,
                onPressed: () async {
                  await AuthService().deleteAccountPermanently();
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Delete Account Permanently',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Icon(
                      Icons.delete,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsCard extends StatelessWidget {
  const SettingsCard({
    Key? key,
    required this.child,
    required this.onPressed,
    this.delete = false,
  }) : super(key: key);

  final Widget child;
  final Function onPressed;
  final bool delete;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onPressed(),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.zero,
        backgroundColor:
            delete ? const Color(0xffA72727) : const Color(0x38ffffff),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        child: child,
      ),
    );
  }
}
