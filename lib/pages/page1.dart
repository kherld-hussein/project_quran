import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:launch_review/launch_review.dart';
import 'package:project_quran/pages/home.dart';
import 'package:project_quran/pages/page2.dart';
import 'package:project_quran/utils/constants.dart' as constants;

class PlayOut extends StatefulWidget {
  @override
  _PlayOutState createState() => _PlayOutState();
}

class _PlayOutState extends State<PlayOut> {
  @override
  void initState() {
    super.initState();
    push();
  }

  push() {
    Timer(Duration(seconds: 1), () => Navigator.pushNamed(context, "index"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        Center(child: Image.asset('assets/images/lg.png')),
        Container(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Color(0xffffffff).withOpacity(0.1),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  width: 300,
                  child: Row(
                    children: [
                      SizedBox(width: 90),
                      Text(
                        'Offline ',
                        style: TextStyle(
                            color: Color(0xffBB8834),
                            fontSize: 24,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold),
                      ),
                      Image.asset('assets/images/logo.png', scale: 8),
                      Text(
                        'ur’ān',
                        style: TextStyle(
                            color: Color(0xffBB8834),
                            fontSize: 24,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 300,
                  width: 200,
                  color: Color(0xff150927).withOpacity(0.4),
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    children: [
                      ListTile(
                        onTap: () => Get.to(
                          HomeView(),
                          transition: Transition.rightToLeft,
                        ),
                        leading: FaIcon(
                          FontAwesomeIcons.play,
                          color: Color(0xffBB8834),
                          size: 30,
                        ),
                        title: Text(
                          "Holy Qur’ān",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        onTap: () => push(),
                        leading: FaIcon(
                          FontAwesomeIcons.quran,
                          color: Color(0xffBB8834),
                        ),
                        title: Text(
                          "Read Qur’ān",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        onTap: () =>
                            Get.to(Page2(), transition: Transition.cupertino),
                        leading: FaIcon(
                          FontAwesomeIcons.leanpub,
                          color: Color(0xffBB8834),
                        ),
                        title: Text(
                          "Learn Al Qur’ān",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        onTap: () => LaunchReview.launch(),
                        leading: FaIcon(
                          FontAwesomeIcons.thumbsUp,
                          color: Color(0xffBB8834),
                          size: 30,
                        ),
                        title: Text(
                          "Review App",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        onTap: () {
                          Get.defaultDialog(
                              title: 'Offline Qur’ān App',
                              textCustom: 'version: 1.0.0',
                              content: Text(
                                'version: 1.0.0',
                                style: TextStyle(color: Colors.grey),
                              ),
                              actions: [
                                Image.asset('assets/images/logo.png', scale: 4),
                              ],
                              middleText:
                                  'Advance Offline Qur’ān application with learning environment');
                        },
                        leading: FaIcon(
                          FontAwesomeIcons.question,
                          color: Color(0xffBB8834),
                          size: 30,
                        ),
                        title: Text(
                          "About",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 300,
                  width: Get.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/QRbar.png'),
                      Image.asset('assets/images/QRbar.png'),
                      Image.asset('assets/images/QRbar.png'),
                      Offstage(
                        child: InkWell(
                          child: Text(
                            "Developer: Kherld Hussein",
                            style: GoogleFonts.charm(color: Color(0xffBB8834)),
                          ),
                        ),
                      )
                    ],
                  ),
                  color: Color(0xff150927).withOpacity(0.4),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
