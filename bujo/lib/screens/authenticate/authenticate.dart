import 'package:flutter/material.dart';

import 'package:bujo/screens/authenticate/sign_in.dart';
import 'package:bujo/screens/authenticate/register.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final PageController _controller = PageController(initialPage: 0);
  bool _signIn = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 20),
            child: Text(
              'Bullet Journal',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Oregano',
                fontSize: 36,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 5),
            child: Text(
              'Stay on top of your life',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'Garamond',
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Container(
              width: double.infinity,
              height: 400,
              decoration: const BoxDecoration(
                color: Color(0xff000C35),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // sign in + register buttons
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 3 / 5,
                    height: 40,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () => _controller.animateToPage(0,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.ease),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => _controller.animateToPage(1,
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.ease),
                            child: const Text(
                              'Register',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        AnimatedAlign(
                          alignment: _signIn
                              ? const Alignment(-0.9, 1)
                              : const Alignment(0.85, 1),
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.decelerate,
                          child: Container(
                            color: const Color(0xff40CDC5),
                            width: 60,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: PageView(
                      controller: _controller,
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (page) =>
                          setState(() => _signIn = page == 0),
                      children: const [
                        SignIn(),
                        Register(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
