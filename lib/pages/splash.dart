import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project_quran/pages/page1.dart';
import 'package:shimmer/shimmer.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        duration: 3000,
        splash: Shimmer.fromColors(
            baseColor: Color(0xff150927),
            highlightColor: Color(0xffBB8834),
            child: Image.asset('assets/images/logo.png')),
        splashIconSize: 200,
        nextScreen: PlayOut(),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
        backgroundColor: Color(0xff150927),
      ),
    );
  }
}
