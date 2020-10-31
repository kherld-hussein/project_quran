import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project_quran/bloc/quran_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share/share.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();
  final _queue = <MediaItem>[
    MediaItem(
      id: 'assets/audio/050.mp3',
      album: 'Juzu',
      title: 'Surat Qaf',
      artist: '',
      artUri: 'assets/images/url.png',
      duration: Duration(minutes: 10),
    ),
    MediaItem(
      id: 'assets/audio/051.mp3',
      album: 'Juzu ',
      title: 'Surat Dhariat',
      artist: '',
      artUri: 'assets/images/url.png',
      duration: Duration(minutes: 10),
    ),
    // MediaItem(id: 'assets/audio/075.mp3', album: 'null', title: 'null'),
    // MediaItem(id: 'assets/audio/100.mp3', album: 'null', title: 'null'),
    // MediaItem(id: 'assets/audio/101.mp3', album: 'null', title: 'null'),
  ];
  Color color;

  @override
  void dispose() {
    AudioService.stop();
    if (playing == true) {
      setState(() {
        color = Color(0xffBB8834);
      });
    } else {
      color = Colors.white;
    }

    super.dispose();
  }

  Future<int> _getDuration() async {
    File audiofile = await audioCache.load('audio/Amma/81.mp3');
    await advancedPlayer.setUrl(
      audiofile.path,
    );
    int duration = await Future.delayed(
        Duration(seconds: 2), () => advancedPlayer.getDuration());
    return duration;
  }

  getLocalFileDuration() {
    return FutureBuilder<int>(
      future: _getDuration(),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('No Connection...');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Text('Awaiting result...');
          case ConnectionState.done:
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            return Text(
                '81.mp3 duration is: ${Duration(milliseconds: snapshot.data)}');
        }
        return null; // unreachable
      },
    );
  }

  bool playing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff150927),
      appBar: AppBar(
        backgroundColor: Color(0xff150927),
        iconTheme: IconThemeData(color: Color(0xffBB8834), size: 40),
        actions: [
          IconButton(
            icon: FaIcon(FontAwesomeIcons.shareAlt),
            onPressed: () => _onShare(context),
          )
        ],
        title: Stack(children: [
          Center(
            child: Text(
              'Al Qur’ān',
              style: TextStyle(
                  color: Color(0xffBB8834),
                  fontSize: 24,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ]),
        elevation: 0,
      ),
      body: Card(
        color: Color(0xff150927),
        child: Container(
          padding: EdgeInsets.all(20),
          // color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Card(
                    color: Color(0xff1D1133),
                    child: ListTile(
                      leading: Chip(
                        label: Text(
                          ' 1.',
                          style: TextStyle(color: Color(0xffBB8834)),
                        ),
                      ),
                      title: Text(
                        "Surah Al-Fātihah الفاتحة\n[ The Opening ]",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        audioCache.play('audio/1.mp3',
                            isNotification: playing == true);
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  SettingsTitle(title: 'Juzzu Ammah'),
                  Card(
                    color: Color(0xff1D1133),
                    child: ListTile(
                      leading: Chip(
                          label: Text(
                        ' 78.',
                        style: TextStyle(color: Color(0xffBB8834)),
                      )),
                      title: Text(
                        "Surah An-Naba’ \n[ The News ]",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () => audioCache.play('audio/Amma/78.mp3'),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    color: Color(0xff1D1133),
                    child: ListTile(
                      leading: Chip(
                        label: Text(
                          ' 79.',
                          style: TextStyle(color: Color(0xffBB8834)),
                        ),
                      ),
                      title: Text(
                        "Surah An-Nāzi’āt \n[ The Extractors ]",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () => audioCache.play('audio/Amma/79.mp3'),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    color: Color(0xff1D1133),
                    child: ListTile(
                      leading: Chip(
                        label: Text(
                          ' 80.',
                          style: TextStyle(color: Color(0xffBB8834)),
                        ),
                      ),
                      title: Text(
                        "Surah ‘Abasa \n[ He Frowned ]",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () => audioCache.play('audio/Amma/80.mp3'),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    color: Color(0xff1D1133),
                    child: ListTile(
                      leading: Chip(
                        label: Text(
                          ' 81.',
                          style: TextStyle(color: Color(0xffBB8834)),
                        ),
                      ),
                      title: Text(
                        "Surah At-Takweer \n[ The Wrapping ]",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () => audioCache.play('audio/Amma/81.mp3'),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    color: Color(0xff1D1133),
                    child: ListTile(
                      leading: Chip(
                        label: Text(
                          ' 82.',
                          style: TextStyle(color: Color(0xffBB8834)),
                        ),
                      ),
                      title: Text(
                        "Surah Al-Infitār \n[ The Breaking Apart ]",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () => audioCache.play('audio/Amma/82.mp3'),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    color: Color(0xff1D1133),
                    child: ListTile(
                      leading: Chip(
                        label: Text(
                          ' 83.',
                          style: TextStyle(color: Color(0xffBB8834)),
                        ),
                      ),
                      title: Text(
                        "Surah Al-Mutaffifeen \n[ Those Who Give Less ]",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () => audioCache.play('audio/Amma/83.mp3'),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    color: Color(0xff1D1133),
                    child: ListTile(
                      leading: Chip(
                        label: Text(
                          ' 84.',
                          style: TextStyle(color: Color(0xffBB8834)),
                        ),
                      ),
                      title: Text(
                        "Surah Al-Inshiqāq \n[ The Splitting ]",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () => audioCache.play('audio/Amma/84.mp3'),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    color: Color(0xff1D1133),
                    child: ListTile(
                      leading: Chip(
                        label: Text(
                          ' 85.',
                          style: TextStyle(color: Color(0xffBB8834)),
                        ),
                      ),
                      title: Text(
                        "Surah Al-Burūj \n[ The Great Stars ]",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () => audioCache.play('audio/Amma/85.mp3'),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    color: Color(0xff1D1133),
                    child: ListTile(
                      leading: Chip(
                        label: Text(
                          ' 86.',
                          style: TextStyle(color: Color(0xffBB8834)),
                        ),
                      ),
                      title: Text(
                        "Surah At-Tāriq \n[ The Night-Comer ]",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () => audioCache.play('audio/Amma/86.mp3'),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    color: Color(0xff1D1133),
                    child: ListTile(
                      leading: Chip(
                        label: Text(
                          ' 87.',
                          style: TextStyle(color: Color(0xffBB8834)),
                        ),
                      ),
                      title: Text(
                        "Surah Al-A’lā \n[ The Most High ]",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () => audioCache.play('audio/Amma/87.mp3'),
                    ),
                  ),
                  SizedBox(height: 10),
                  Card(
                    color: Color(0xff1D1133),
                    child: ListTile(
                      leading: Chip(
                        label: Text(
                          ' 88.',
                          style: TextStyle(color: Color(0xffBB8834)),
                        ),
                      ),
                      title: Text(
                        "Surah Al-Ghāshiyah \n[ The Overwhelming ]",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () => audioCache.play('audio/Amma/88.mp3'),
                    ),
                  ),
                  getLocalFileDuration(),
                ]),
          ),
          // child: StreamBuilder<AudioState>(
          //     stream: _audioStateStream,
          //     builder: (context, snapshot) {
          //       final audioState = snapshot.data;
          //       final queue = audioState?.queue;
          //       final mediaItem = audioState?.mediaItem;
          //       final playbackState = audioState?.playbackState;
          //       final processingState =
          //           playbackState?.processingState ?? AudioProcessingState.none;
          //       final playing = playbackState?.playing ?? false;
          //
          //       return Container(
          //         width: MediaQuery.of(context).size.width,
          //         child: Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           mainAxisSize: MainAxisSize.max,
          //           children: [
          //             if (processingState == AudioProcessingState.none) ...[
          //               _startPlayBtn()
          //             ] else ...[
          //               SizedBox(height: 20),
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   !playing
          //                       ? IconButton(
          //                           icon: FaIcon(FontAwesomeIcons.play),
          //                           onPressed: AudioService.play,
          //                         )
          //                       : IconButton(
          //                           icon: FaIcon(FontAwesomeIcons.pause),
          //                           onPressed: AudioService.pause,
          //                         ),
          //                   IconButton(
          //                     icon: FaIcon(FontAwesomeIcons.skiing),
          //                     onPressed: () {
          //                       if (mediaItem == queue.first) {
          //                         return;
          //                       }
          //                       AudioService.skipToPrevious();
          //                       // AudioService.skipToQueueItem(mediaId)
          //                     },
          //                   ),
          //                   IconButton(
          //                     icon: FaIcon(FontAwesomeIcons.pause),
          //                     onPressed: () {
          //                       if (mediaItem == queue.last) {
          //                         return;
          //                       }
          //                       AudioService.skipToNext();
          //                     },
          //                   ),
          //                 ],
          //               )
          //             ]
          //           ],
          //         ),
          //       );
          //     }),
        ),
      ),
    );
  }

  _startPlayBtn() {
    List<dynamic> qList = List();
    for (int i = 0; i < 2; i++) {
      var mediaItem = _queue[i].toJson();
      qList.add(mediaItem);
    }
    var params = {'data': qList};

    return MaterialButton(
      onPressed: () async {
        await AudioService.start(
          backgroundTaskEntrypoint: _entryPoint,
          androidNotificationColor: 0xffBABEBA,
          androidNotificationIcon: 'mipmap/launcher',
          androidNotificationChannelName: 'Al Qur’ān Kareem',
          params: params,
        );
        print(params.toString());
      },
      child: Text('Start Listening'),
    );
  }

  _onShare(BuildContext context) async {
    final RenderBox box = context.findRenderObject();
    await Share.share("Offline Quran App",
        subject: "offline/Ouran.app",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }
}

void _entryPoint() async {
  AudioServiceBackground.run(() => QuranServicesTask());
}

Stream<AudioState> get _audioStateStream {
  return Rx.combineLatest3<List<MediaItem>, MediaItem, PlaybackState,
      AudioState>(
    AudioService.queueStream,
    AudioService.currentMediaItemStream,
    AudioService.playbackStateStream,
    (queue, mediaItem, playbackState) =>
        AudioState(queue, mediaItem, playbackState),
  );
}

class SettingsTitle extends StatelessWidget {
  final String title;

  const SettingsTitle({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(6, 8, 6, 8),
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ));
  }
}
