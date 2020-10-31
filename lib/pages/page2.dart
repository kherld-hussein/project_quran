import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff150927),
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
                '    Learn Qur’ān and\n Recite once everyday',
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
              Image.asset('assets/images/Qlearn.png'),
              Positioned(
                bottom: 0,
                left: 80,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(
                      child: child,
                      scale: animation,
                    );
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
                              Image.asset(
                                'assets/images/logo.png',
                                scale: 4,
                              ),
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
              )
            ],
          )
        ],
      ),
    );
  }
}
