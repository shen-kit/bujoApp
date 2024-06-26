import 'package:bujo/screens/authenticate/authenticate.dart';
import 'package:bujo/screens/logged_in/logged_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return user == null ? const Authenticate() : const LoggedIn();
  }
}
