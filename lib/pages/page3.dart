import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:epub_viewer/epub_viewer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class Page3 extends StatefulWidget {
  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  PdfViewerController _pdfViewerController;
  bool loading = false;
  Dio dio = new Dio();

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
  }

  download() async {
    if (Platform.isIOS) {
      print('download');
      await downloadFile();
    } else {
      loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: loading
            ? CircularProgressIndicator()
            : MaterialButton(
                onPressed: () async {
                  Directory appDocDir =
                      await getApplicationDocumentsDirectory();
                  print('$appDocDir');
                  String iosBookPath = '${appDocDir.path}/arabic.epub';
                  print(iosBookPath);
                  String androidBookPath = 'file:///android_asset/arabic.epub';
                  EpubViewer.setConfig(
                      themeColor: Theme.of(context).primaryColor,
                      identifier: "iosBook",
                      scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
                      allowSharing: true,
                      enableTts: true,
                      nightMode: true);
//                    EpubViewer.open(
//                      Platform.isAndroid ? androidBookPath : iosBookPath,
//                      lastLocation: EpubLocator.fromJson({
//                        "bookId": "2239",
//                        "href": "/OEBPS/ch06.xhtml",
//                        "created": 1539934158390,
//                        "locations": {
//                          "cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"
//                        }
//                      }),
//                    );

                  await EpubViewer.openAsset(
                    'assets/arabic.epub',
                    lastLocation: EpubLocator.fromJson({
                      "bookId": "2239",
                      "href": "/OEBPS/ch06.xhtml",
                      "created": 1539934158390,
                      "locations": {
                        "cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"
                      }
                    }),
                  );
                  // get current locator
                  EpubViewer.locatorStream.listen((locator) {
                    print(
                        'LOCATOR: ${EpubLocator.fromJson(jsonDecode(locator))}');
                  });
                },
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                color: Color(0xffBB8834),
                shape: StadiumBorder(),
                child: Text('Get Started'),
              ),
      ),
      // body: SfPdfViewer.asset(
      //   'assets/Quran.pdf',
      //   key: _pdfViewerKey,
      //   controller: _pdfViewerController,
      // ),
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
    );
  }

  _onShare(BuildContext context) async {
    final RenderBox box = context.findRenderObject();
    await Share.share(
        "Advance Offline Qur’ān application with learning environment",
        subject: "offline/Ouran.app",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  Future downloadFile() async {
    print('download1');
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);

    if (permission != PermissionStatus.granted) {
      await PermissionHandler().requestPermissions([PermissionGroup.storage]);
      await startDownload();
    } else {
      await startDownload();
    }
  }

  startDownload() async {
    Directory appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    String path = appDocDir.path + '/chair.epub';
    File file = File(path);
//    await file.delete();

    if (!File(path).existsSync()) {
      await file.create();
      await dio.download(
        'https://github.com/FolioReader/FolioReaderKit/raw/master/Example/'
        'Shared/Sample%20eBooks/The%20Silver%20Chair.epub',
        path,
        deleteOnError: true,
        onReceiveProgress: (receivedBytes, totalBytes) {
          print((receivedBytes / totalBytes * 100).toStringAsFixed(0));
          //Check if download is complete and close the alert dialog
          if (receivedBytes == totalBytes) {
            loading = false;
            setState(() {});
          }
        },
      );
    } else {
      loading = false;
      setState(() {});
    }
  }
}
