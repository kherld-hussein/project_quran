import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project_quran/pages/page1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_quran/utils/constants.dart' as constants;

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  SharedPreferences prefs;

  /// get bookmarkPage from sharedPreferences
  getLastViewedPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(constants.LAST_VIEWED_PAGE)) {
      var _lastViewedPage = prefs.getInt(constants.LAST_VIEWED_PAGE);
      setState(() {
        constants.lastViewedPage = _lastViewedPage;
      });
    }
  }

  /// get bookmarkPage from sharedPreferences
  getBookmark() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(constants.BOOKMARKED_PAGE)) {
      var bookmarkedPage = prefs.getInt(constants.BOOKMARKED_PAGE);
      setState(() {
        constants.bookmarkedPage = bookmarkedPage;
      });

      /// if not found return default value
    } else {
      constants.bookmarkedPage = constants.DEFAULT_BOOKMARKED_PAGE;
    }
  }
  @override
  void initState() {
    /// get Saved preferences
    getBookmark();
    getLastViewedPage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        duration: 3000,
        splash: Image.asset('assets/images/logo.png'),
        splashIconSize: 200,
        nextScreen: PlayOut(),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.fade,
        backgroundColor: Color(0xff150927),
      ),
    );
  }
}
