import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(hintText: 'Email'),
              validator: (value) =>
                  value!.isNotEmpty ? null : 'Please enter an email',
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(hintText: 'Password'),
              obscureText: true,
              validator: (value) =>
                  value!.isNotEmpty ? null : 'Please enter your password',
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 45,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: const Color(0x40FFFFFF),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.email,
                      color: Color(0x40FFFFFF),
                    ),
                    SizedBox(width: 10),
                    Text('Sign In'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 45,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: const Color(0x40FFFFFF),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    FaIcon(
                      FontAwesomeIcons.google,
                      color: Colors.redAccent,
                    ),
                    SizedBox(width: 10),
                    Text('Sign In with Google'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
