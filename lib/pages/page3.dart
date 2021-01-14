import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    if (_document != null) {
      return _document;
    }

    /// Check Compatibility's [Android 5.0+]
    if (await hasSupport()) {
      _document = await PDFDocument.openAsset('assets/pdf/quran.pdf');
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
      /// init current page
      constants.currentPage = widget.pages;
      pageController = _pageControllerBuilder();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pageController = _pageControllerBuilder();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff150927),
        iconTheme: IconThemeData(color: Color(0xffBB8834)),
        title: Text(
          'Al Qur\'an Viewer',
          style: TextStyle(color: Color(0xffBB8834)),
        ),
        actions: <Widget>[
          // IconButton(
          //   icon: FaIcon(FontAwesomeIcons.bookmark),
          //   onPressed: () => _pdfViewerKey.currentState?.openBookmarkView(),
          // ),
          IconButton(
            icon: FaIcon(FontAwesomeIcons.shareAlt),
            onPressed: () => _onShare(context),
          ),
          // IconButton(
          //   icon: FaIcon(FontAwesomeIcons.angleUp),
          //   onPressed: _pdfViewerController.previousPage,
          // ),
          // IconButton(
          //   icon: FaIcon(FontAwesomeIcons.angleDown),
          //   onPressed: _pdfViewerController.nextPage,
          // )
        ],
      ),
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

                  /// Update lastViewedPage
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
                          // gesture not applied (minScale,maxScale,speed...)
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
    );
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

  SurahListBuilder({Key key, this.pages}) : super(key: key);

  @override
  _SurahListBuilderState createState() => _SurahListBuilderState();
}

class _SurahListBuilderState extends State<SurahListBuilder> {
  TextEditingController editingController = TextEditingController();

  List<Pages> pages = List<Pages>();

  void initSurahListView() {
    if (pages.isNotEmpty) {
      pages.clear();
    }
    pages.addAll(widget.pages);
  }

  void filterSearchResults(String query) {
    /// Fill surah list if empty
    initSurahListView();

    /// SearchList contains every surah
    List<Pages> searchList = List<Pages>();
    searchList.addAll(pages);

    /// Contains matching surah(s)
    List<Pages> listData = List<Pages>();
    if (query.isNotEmpty) {
      /// Loop all surah(s)
      searchList.forEach((item) {
        /// Filter by (titleAr:exact,title:partial,pageIndex)
        if (item.titleAr.contains(query) ||
            item.title.toLowerCase().contains(query.toLowerCase()) ||
            item.pageIndex.toString().contains(query)) {
          listData.add(item);
        }
      });

      /// Fill surah List with searched surah(s)
      setState(() {
        pages.clear();
        pages.addAll(listData);
      });
      return;

      /// Show all surah list
    } else {
      setState(() {
        pages.clear();
        pages.addAll(widget.pages);
      });
    }
  }

  @override
  void initState() {
    /// Init listView with all surah(s)
    initSurahListView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          /// Search field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              cursorColor: Colors.green,
              onChanged: (value) {
                filterSearchResults(value);
                print(value);
              },
              controller: editingController,
              decoration: InputDecoration(
                  labelText: "البحث عن سورة",
                  // hintText: "البحث",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            ),
          ),

          /// ListView represent all/searched surah(s)
          Expanded(
            child: ListView.builder(
              itemCount: pages.length,
              itemExtent: 80,
              itemBuilder: (BuildContext context, int index) => ListTile(
                  title: Text(pages[index].titleAr),
                  subtitle: Text(pages[index].title),
                  leading: Image(
                      image:
                          AssetImage("assets/images/${pages[index].place}.png"),
                      width: 30,
                      height: 30),
                  trailing: Text("${pages[index].pageIndex}"),
                  onTap: () {
                    /// Push to Quran view ([int pages] represent surah page(reversed index))
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Page3(pages: pages[index].pages)));
                  }),
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
            child: Icon(
              Icons.bookmark,
              color: Colors.red[800],
              size: 40.0,
            ),
          ),
        ),
      ),
    );
  }
}
