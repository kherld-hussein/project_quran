import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:project_quran/bloc/pages.dart';
import 'package:screen/screen.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_quran/utils/constants.dart' as constants;

import '../index.dart';

class Page3 extends StatefulWidget {
  final int pages;

  const Page3({Key key, this.pages}) : super(key: key);

  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  /// My Document
  PDFDocument _document;

  /// On Double Tap Zoom Scale
  static const List<double> _doubleTapScales = <double>[1.0, 1.1];

  /// Current Page init (on page changed)
  int currentPage;

  /// Init Page Controller
  PageController pageController;

  bool isBookmarked = false;
  Widget _bookmarkWidget = Container();

  /// Used for Bottom Navigation
  int _selectedIndex = 0;

  /// Declare SharedPreferences
  SharedPreferences prefs;

  /// Load PDF Documents
  Future<PDFDocument> _getDocument() async {
    if (_document != null) return _document;

    /// Check Compatibility's [Android 5.0+]
    if (await hasSupport()) {
      _document = await PDFDocument.openAsset('assets/quran.pdf');
      return _document;
    } else {
      throw Exception(
        'المعذرة لا يمكن طباعة المحتوى'
        'يرجي التحقق من أن جهازك يدعم نظام أندرويد بنسخته 5 على الأقل',
      );
    }
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

      //Bookmark this page
    } else if (index == 1) {
      setState(() {
        constants.bookmarkedPage = constants.currentPage;
        print("toSave: ${constants.bookmarkedPage}");
      });
      if (constants.bookmarkedPage != null) {
        setBookmark(constants.bookmarkedPage);
      }

      //got to index
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Index()));
    }
  }

  PageController _pageControllerBuilder() {
    return new PageController(
        initialPage: widget.pages, viewportFraction: 1.1, keepPage: true);
  }

  /// set bookmarkPage in sharedPreferences
  void setBookmark(int _page) async {
    prefs = await SharedPreferences.getInstance();
    if (_page != null && !_page.isNaN) {
      await prefs.setInt(constants.BOOKMARKED_PAGE, _page);
    }
  }

  /// set lastViewedPage in sharedPreferences
  void setLastViewedPage(int _currentPage) async {
    prefs = await SharedPreferences.getInstance();
    if (_currentPage != null && !_currentPage.isNaN) {
      prefs.setInt(constants.LAST_VIEWED_PAGE, _currentPage);
      constants.lastViewedPage = prefs.getInt(constants.LAST_VIEWED_PAGE);
    }
  }

  closePage(page) async {
    await page.close();
  }

  @override
  void initState() {
    /// Prevent screen from going into sleep mode:
    Screen.keepOn(true);
    setState(() {
      constants.currentPage = widget.pages;
      pageController = _pageControllerBuilder();
    });

    super.initState();
  }
  ScrollController _scrollController;
  @override
  Widget build(BuildContext context) {
    pageController = _pageControllerBuilder();
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: FutureBuilder(
          future: _getDocument(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SafeArea(
                child: PDFView.builder(
                  scrollDirection: Axis.horizontal,
                  document: snapshot.data,
                  controller: pageController,
                  builder: (PDFPageImage pageImage, bool isCurrentIndex) {
                    currentPage = pageImage.pageNumber;
                    constants.currentPage = currentPage;
                    setLastViewedPage(currentPage);
                    if (currentPage == constants.bookmarkedPage) {
                      isBookmarked = true;
                    } else {
                      isBookmarked = false;
                    }
                    print("$isBookmarked:$currentPage");

                    if (isBookmarked) {
                      _bookmarkWidget = Bookmark();
                    } else {
                      _bookmarkWidget = Container();
                    }

                    Widget image = Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Container(
                          child: ExtendedImage.memory(
                            pageImage.bytes,
                            mode: ExtendedImageMode.gesture,
                            initGestureConfigHandler: (_) => GestureConfig(
                              //minScale: 1,
                              // animationMinScale:1,
                              // maxScale: 1.1,
                              //animationMaxScale: 1,
                              speed: 1,
                              inertialSpeed: 100,
                              //inPageView: true,
                              initialScale: 1,
                              cacheGesture: false,
                            ),
                            onDoubleTap: (ExtendedImageGestureState state) {
                              final pointerDownPosition =
                                  state.pointerDownPosition;
                              final begin = state.gestureDetails.totalScale;
                              double end;
                              if (begin == _doubleTapScales[0]) {
                                end = _doubleTapScales[1];
                              } else {
                                end = _doubleTapScales[0];
                              }
                              state.handleDoubleTap(
                                scale: end,
                                doubleTapPosition: pointerDownPosition,
                              );
                            },
                          ),
                        ),
                        isBookmarked == true ? _bookmarkWidget : Container(),
                      ],
                    );
                    if (isCurrentIndex) {
                      //currentPage=pageImage.pageNumber.round().toInt();
                      image = Hero(
                        tag: pageImage.pageNumber.toString(),
                        child: Container(child: image),
                        transitionOnUserGestures: true,
                      );
                    }
                    return image;
                  },
                  onPageChanged: (page) {},
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'المعذرة لا يمكن طباعة المحتوى'
                  'يرجي التحقق من أن جهازك يدعم نظام أندرويد بنسخته 5 على الأقل',
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        bottomNavigationBar: AnimatedBuilder(
          animation: pageController,
          builder: (context, Widget child) {
            return AnimatedContainer(
              width: size.width,
              height: pageController.position.userScrollDirection ==
                      ScrollDirection.reverse
                  ? 0
                  : 80,
              duration: Duration(microseconds: 500),
              child: child,
            );
          },
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.book),
                label: 'الإنتقال إلى العلامة',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.bookmark),
                label: 'حفظ العلامة',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.listAlt),
                label: 'الفهرس',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.grey[600],
            selectedFontSize: 12,
            onTap: (index) => _onItemTapped(index),
          ),
        ));
  }

  _onShare(BuildContext context) async {
    final RenderBox box = context.findRenderObject();
    await Share.share(
        "Advance Offline Qur’ān application with learning environment",
        subject: "offline/Ouran.app",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  Future<bool> hasSupport() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    bool hasSupport = androidInfo.version.sdkInt >= 21;
    return hasSupport;
  }
}

class SurahListBuilder extends StatefulWidget {
  final List<Pages> pages;
  final ScrollController controller;

  SurahListBuilder({Key key, @required this.pages, @required this.controller})
      : super(key: key);

  @override
  _SurahListBuilderState createState() => _SurahListBuilderState();
}

class _SurahListBuilderState extends State<SurahListBuilder> {
  TextEditingController editingController = TextEditingController();

  List<Pages> pages;

  void initSurahListView() {
    if (pages.isNotEmpty) {
      pages.clear();
    }
    pages.addAll(widget.pages);
  }

  void filterSearchResults(String query) {
    initSurahListView();
    List<Pages> searchList;
    searchList.addAll(pages);
    List<Pages> listData;
    if (query.isNotEmpty) {
      searchList.forEach((item) {
        if (item.titleAr.contains(query) ||
            item.title.toLowerCase().contains(query.toLowerCase()) ||
            item.pageIndex.toString().contains(query)) {
          listData.add(item);
        }
      });

      setState(() {
        pages.clear();
        pages.addAll(listData);
      });
      return;
    } else {
      setState(() {
        pages.clear();
        pages.addAll(widget.pages);
      });
    }
  }

  @override
  void initState() {
    initSurahListView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              cursorColor: Color(0xff1D1133),
              onChanged: (value) => filterSearchResults(value),
              controller: editingController,
              decoration: InputDecoration(
                labelText: "البحث عن سورة",
                // hintText: "البحث",
                prefixIcon: FaIcon(FontAwesomeIcons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pages.length,
              itemExtent: 80,
              controller: widget.controller,
              itemBuilder: (BuildContext context, int index) => Card(
                child: ListTile(
                  title: Text(pages[index].titleAr),
                  subtitle: Text(pages[index].title),
                  leading: Image(
                      image: AssetImage("assets/images/lg.png"),
                      width: 30,
                      height: 30),
                  trailing: Text("${pages[index].pageIndex}"),
                  onTap: () => Get.to(Page3(pages: pages[index].pages)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Bookmark extends StatefulWidget {
  @override
  _BookmarkState createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding:
            EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
        child: Align(
          alignment: Alignment.topLeft,
          child: Opacity(
            opacity: 0.8,
            child: FaIcon(
              FontAwesomeIcons.solidBookmark,
              color: Color(0xffBB8834),
              size: 40.0,
            ),
          ),
        ),
      ),
    );
  }
}
