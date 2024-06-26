import 'package:bujo/services/auth.dart';
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

  final AuthService _auth = AuthService();
  // bool loading = false;
  String error = '';

  void register() async {
    if (!_formKey.currentState!.validate()) return;
    // setState(() => loading = true);
    dynamic result = await _auth.registerWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
    );
    if (result.runtimeType == String) {
      setState(() {
        error = result;
        // loading = false;
      });
    } else {}
  }

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
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(hintText: 'Password'),
              obscureText: true,
              validator: (value) =>
                  value!.isNotEmpty ? null : 'Please enter a password',
              onFieldSubmitted: (value) => register(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => register(),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0x40FFFFFF),
                ),
                icon: const Icon(
                  Icons.email,
                  color: Color(0xFF638fd6),
                ),
                label: const Text('Register'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  // setState(() => loading = true);
                  dynamic result = await _auth.signInWithGoogle();
                  if (result.runtimeType == String) {
                    setState(() {
                      error = result;
                      // loading = false;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0x40FFFFFF),
                ),
                icon: const FaIcon(
                  FontAwesomeIcons.google,
                  color: Colors.redAccent,
                ),
                label: const Text('Sign In with Google'),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              error,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
