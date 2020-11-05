import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_quran/pages/splash.dart';
import 'package:statusbar_util/statusbar_util.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  StatusbarUtil.setTranslucent();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Offline Qur’ān",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashView(),
    );
  }
}
