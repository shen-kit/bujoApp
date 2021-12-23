import 'package:bujo/shared/get_text_size.dart';
import 'package:bujo/shared/screen_base.dart';
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
      body: screenBase(
        context: context,
        title: 'Bullet Journal',
        subtitle: 'Stay on top of your life',
        settings: true,
        mainContent: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
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
                            curve: Curves.decelerate),
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
                          ? const Alignment(-1, 1)
                          : const Alignment(1, 1),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.decelerate,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          color: const Color(0xff40CDC5),
                          width: _signIn
                              ? getTextSize(
                                  'Sign In',
                                  const TextStyle(fontSize: 20),
                                ).width
                              : getTextSize(
                                  'Register',
                                  const TextStyle(fontSize: 20),
                                ).width,
                          height: 1,
                        ),
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
                  onPageChanged: (page) => setState(() => _signIn = page == 0),
                  children: const [
                    SignIn(),
                    Register(),
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
