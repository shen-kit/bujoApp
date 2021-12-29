import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({this.loadingText = '', Key? key}) : super(key: key);

  final String loadingText;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: Center(
        child: loadingText != ''
            ? Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SpinKitThreeBounce(
                      color: Colors.white,
                      size: 30,
                    ),
                    Text(loadingText),
                  ],
                ),
              )
            : const SpinKitThreeBounce(
                color: Colors.white,
                size: 30,
              ),
      ),
    );
  }
}
