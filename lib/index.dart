import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_quran/pages/page3.dart';
import 'package:project_quran/utils/constants.dart' as constants;
import 'package:screen/screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/pages.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  /// Used for Bottom Navigation
  int _selectedIndex = 0;

  /// Get Screen Brightness
  void getScreenBrightness() async {
    constants.brightnessLevel = await Screen.brightness;
  }

  /// Navigation event handler
  _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    /// Go to Bookmarked page
    if (index == 0) {
      setState(() {
        /// in case Bookmarked page is null (Bookmarked page initialized in splash screen)
        if (constants.bookmarkedPage == null) {
          constants.bookmarkedPage = constants.DEFAULT_BOOKMARKED_PAGE;
        }
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => Page3(pages: constants.bookmarkedPage - 1)),
          (Route<dynamic> route) => false);

      /// Continue reading
    } else if (index == 1) {
      if (constants.lastViewedPage != null) {
        /// Push to Quran view ([int pages] represent surah page(reversed index))
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Page3(pages: constants.lastViewedPage - 1)));
      }

      /// Customize Screen Brightness
    } else if (index == 2) {
      if (constants.brightnessLevel == null) {
        getScreenBrightness();
      }
      showDialog(context: this.context, builder: (context) => SliderAlert());
    }
  }

  void redirectToLastVisitedSurahView() {
    print("redirectTo:${constants.lastViewedPage}");
    if (constants.lastViewedPage != null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => Page3(pages: constants.lastViewedPage)),
          (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    /// set saved Brightness level
    Screen.setBrightness(constants.brightnessLevel);
    Screen.keepOn(true);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          /*leading: IconButton(
            icon: Icon(
              Icons.tune,
              color: Colors.white,
            ),
            onPressed: (){
              showDialog(context: this.context,
                  builder:(context)=>SliderAlert());
            },
          ),*/
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                  padding: const EdgeInsets.all(8.0), child: Text('الفهرس')),
              Icon(
                Icons.format_list_numbered_rtl,
                color: Colors.white,
              ),
            ],
          ),
        ),
        body: Container(
          child: Directionality(
            textDirection: TextDirection.rtl,

            /// Use future builder and DefaultAssetBundle to load the local JSON file
            child: new FutureBuilder(
                future: DefaultAssetBundle.of(context)
                    .loadString('assets/json/surah.json'),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Pages> surahList = parseJson(snapshot.data.toString());
                    return surahList.isNotEmpty
                        ? new SurahListBuilder(pages: surahList)
                        : new Center(child: new CircularProgressIndicator());
                  } else {
                    return new Center(child: new CircularProgressIndicator());
                  }
                }),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              title: Text('الإنتقال إلى العلامة'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chrome_reader_mode),
              title: Text('مواصلة القراءة'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.highlight),
              title: Text('إضاءة الشاشة'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.grey[600],
          selectedFontSize: 12,
          onTap: (index) => _onItemTapped(index),
        ),
      ),
    );
  }

  List<Pages> parseJson(String response) {
    if (response == null) {
      return [];
    }
    final parsed =
        json.decode(response.toString()).cast<Map<String, dynamic>>();
    return parsed.map<Pages>((json) => new Pages.fromJson(json)).toList();
  }
}

class SliderAlert extends StatefulWidget {
  @override
  _SliderAlertState createState() => _SliderAlertState();
}

class _SliderAlertState extends State<SliderAlert> {
  /// Declare sharedPreferences
  SharedPreferences prefs;

  /// Temp Brightness Level (not save it yet)
  double tempBrightnessLevel;

  setBrightnessLevel(double level) async {
    constants.brightnessLevel = level;
    prefs = await SharedPreferences.getInstance();
    prefs.setDouble(constants.BRIGHTNESS_LEVEL, constants.brightnessLevel);
  }

  @override
  void initState() {
    if (constants.brightnessLevel != null) {
      setState(() {
        tempBrightnessLevel = constants.brightnessLevel;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title: Text("إضاءة الشاشة", textDirection: TextDirection.rtl),
        content: Container(
          height: 24,
          child: Row(
            children: <Widget>[
              Icon(Icons.highlight, size: 24),
              Slider(
                value: tempBrightnessLevel,
                onChanged: (_brightness) {
                  setState(() {
                    tempBrightnessLevel = _brightness;
                  });
                  Screen.setBrightness(tempBrightnessLevel);
                },
                max: 1,
                label: "$tempBrightnessLevel",
                divisions: 10,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
              child: Text("إلغاء", textDirection: TextDirection.rtl),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          FlatButton(
            child: Text("حفظ", textDirection: TextDirection.rtl),
            onPressed: () {
              setBrightnessLevel(tempBrightnessLevel);
              Navigator.of(context).pop();
              Get.snackbar('', ' تم الحفظ بنجاح');
            },
          ),
        ],
      ),
    );
  }
}
