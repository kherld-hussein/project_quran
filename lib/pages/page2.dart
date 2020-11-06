import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:lottie/lottie.dart';

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  final InAppReview _inAppReview = InAppReview.instance;
  bool _isAvailable;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Platform.isIOS || Platform.isMacOS) {
        _inAppReview.isAvailable().then((bool isAvailable) {
          setState(() {
            _isAvailable = isAvailable;
          });
        });
      } else {
        setState(() {
          _isAvailable = false;
        });
      }
    });
    super.initState();
  }

  Future<void> _requestReview() => _inAppReview.requestReview();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff150927),
      appBar: AppBar(
        backgroundColor: Color(0xff150927),
        iconTheme: IconThemeData(color: Color(0xffBB8834)),
        elevation: 0,
        actions: [
          IconButton(
            icon: Lottie.asset('assets/lottie/dev.json',
                height: 80, width: 80, addRepaintBoundary: true),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text('Tell us your thoughts'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        content: Text(
                            'We\'ll use the information you give us to improve our services '),
                        actions: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              FlatButton(
                                  child: Text('OK'),
                                  onPressed: () async {
                                    if (await _inAppReview.isAvailable()) {
                                      _requestReview();
                                      Navigator.pop(context);
                                    } else {
                                      _inAppReview.openStoreListing();
                                      Navigator.pop(context);
                                    }
                                  }),
                            ],
                          ),
                        ],
                      ));
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                'Qur’ān App',
                style: TextStyle(
                    color: Color(0xffBB8834),
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
              SizedBox(height: 10),
              Text(
                'Learn Qur’ān and\n Recite once everyday',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff672BBc),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Stack(
            children: [
              Image.asset('assets/images/learn.png'),
              Positioned(
                bottom: 0,
                left: 80,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(child: child, scale: animation);
                  },
                  child: MaterialButton(
                    onPressed: () {
                      Get.snackbar("", '',
                          showProgressIndicator: true,
                          messageText: Text(
                            "Assalamualykumو Learning View will be available in the next version In Sha Allah",
                            style: TextStyle(color: Colors.white),
                          ),
                          duration: Duration(seconds: 15),
                          titleText: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset('assets/images/logo.png', scale: 4),
                              Text(
                                'Under Development',
                                style: TextStyle(
                                    color: Color(0xffBB8834),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          dismissDirection: SnackDismissDirection.HORIZONTAL,
                          backgroundColor: Color(0xff672BBc).withOpacity(0.4));
                    },
                    child: Text(
                      "Get Started",
                      style: GoogleFonts.hindVadodara(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    color: Color(0xffBB8834),
                    shape: StadiumBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
