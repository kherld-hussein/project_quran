import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:motion_tab_bar/MotionTabController.dart';
import 'package:project_quran/bloc/quran_bloc.dart';
import 'package:project_quran/wigets/CPainter.dart';
import 'package:project_quran/wigets/settingTile.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share/share.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer = AudioPlayer();
  bool playing = false;
  final _queue = <MediaItem>[
    MediaItem(
      id: 'assets/audio/Amma/90.mp3',
      album: 'Juzu',
      title: 'Surat Qaf',
      artist: '',
      artUri: 'assets/images/url.png',
      duration: Duration(minutes: 10),
    ),
    MediaItem(
      id: 'assets/audio/Amma/79.mp3',
      album: 'Juzu ',
      title: 'Surat Naba',
      artist: '',
      artUri: 'assets/images/logo.png',
      duration: Duration(minutes: 10),
    ),
    MediaItem(id: 'assets/audio/Amma/78.mp3', album: 'null', title: 'null'),
    MediaItem(id: 'assets/audio/Amma/100.mp3', album: 'null', title: 'null'),
    MediaItem(id: 'assets/audio/Amma/101.mp3', album: 'null', title: 'null'),
  ];
  Color color;
  ScrollController _scrollController;
  MotionTabController _tabController;
  String shortcut = "Read AL Qur’ān";

  @override
  void initState() {
    _scrollController = ScrollController();
    _tabController = MotionTabController(initialIndex: 1, vsync: this);
    final QuickActions quickActions = QuickActions();
    quickActions.initialize((String shortcutType) {
      setState(() {
        if (shortcutType != null) shortcut = shortcutType;
      });
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
        type: 'ListenQur’ān',
        localizedTitle: 'Listen Qur’ān',
        icon: 'logoo',
      ),
      const ShortcutItem(
        type: 'ReadQur’ān',
        localizedTitle: 'Read Qur’ān',
        icon: 'logoo',
      ),
      const ShortcutItem(
          type: 'LearnQur’ān', localizedTitle: 'Learn Qur’ān', icon: 'logoo'),
    ]);
    super.initState();
  }

  @override
  void dispose() {
    AudioService.stop();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<int> _getDuration() async {
    File audioFile = await audioCache.load('audio/Amma/81.mp3');
    await advancedPlayer.setUrl(audioFile.path);
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

  Duration duration = Duration();
  Duration position = Duration();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery
        .of(context)
        .size;
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
        centerTitle: true,
        title: Image.asset('assets/images/basmallah.png'),
        elevation: 0,
      ),
      body: Stack(children: [
        Card(
          color: Color(0xff150927),
          child: Container(
            padding: EdgeInsets.all(20),
            child: ListView(controller: _scrollController, children: [
              Card(
                color: Color(0xff1D1133),
                child: ListTile(
                  leading: Chip(
                    backgroundColor:
                    playing == false ? Colors.white : Color(0xffBB8834),
                    label: Text(
                      ' 1.',
                      style: TextStyle(
                          color: playing == false
                              ? Color(0xffBB8834)
                              : Colors.white),
                    ),
                  ),
                  trailing: IconButton(
                    icon: FaIcon(playing == false
                        ? FontAwesomeIcons.play
                        : FontAwesomeIcons.pause),
                    onPressed: () => getAudio('assets/audio/1.mp3'),
                  ),
                  title: Text(
                    "Surah Al-Fātihah الفاتحة\n[ The Opening ]",
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle:
                  Offstage(offstage: playing == false, child: slider()),
                ),
              ),
              SizedBox(height: 10),
              SettingsTitle(title: 'Juzzu Ammah'),
              Card(
                color: Color(0xff1D1133),
                child: ListTile(
                  leading: Chip(
                    backgroundColor: Colors.white,
                    label: Text(
                      ' 78.',
                      style: TextStyle(color: Color(0xffBB8834)),
                    ),
                  ),
                  // trailing: IconButton(
                  //   icon: FaIcon(playing == false
                  //       ? FontAwesomeIcons.play
                  //       : FontAwesomeIcons.pause),
                  //   onPressed: () => getAudio('audio/Amma/78.mp3'),
                  // ),
                  title: Text(
                    "Surah An-Naba’ \nالنبإ\n[ The News ]",
                    style: TextStyle(color: Colors.white),
                  ),
                  // subtitle:
                  //     Offstage(offstage: playing == false, child: slider()),
                ),
              ),
              SizedBox(height: 10),
              Card(
                color: Color(0xff1D1133),
                child: ListTile(
                  leading: Chip(
                    backgroundColor: Colors.white,
                    label: Text(
                      ' 79.',
                      style: TextStyle(color: Color(0xffBB8834)),
                    ),
                  ),
                  title: Text(
                    "Surah An-Nāzi’āt \nالنازعات\n[ The Extractors ]",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () =>
                      advancedPlayer.play('audio/Amma/79.mp3', isLocal: true),
                ),
              ),
              SizedBox(height: 10),
              Card(
                color: Color(0xff1D1133),
                child: ListTile(
                  leading: Chip(
                    backgroundColor: Colors.white,
                    label: Text(
                      ' 80.',
                      style: TextStyle(color: Color(0xffBB8834)),
                    ),
                  ),
                  title: Text(
                    "Surah ‘Abasa \nعبس\n[ He Frowned ]",
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
                    backgroundColor: Colors.white,
                    label: Text(
                      ' 81.',
                      style: TextStyle(color: Color(0xffBB8834)),
                    ),
                  ),
                  title: Text(
                    "Surah At-Takweer \nالتكىير\n[ The Wrapping ]",
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
                    backgroundColor: Colors.white,
                    label: Text(
                      ' 82.',
                      style: TextStyle(color: Color(0xffBB8834)),
                    ),
                  ),
                  title: Text(
                    "Surah Al-Infitār \nاﻻنفطار\n[ The Breaking Apart ]",
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
                    backgroundColor: Colors.white,
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
                    backgroundColor: Colors.white,
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
                    backgroundColor: Colors.white,
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
                    backgroundColor: Colors.white,
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
                    backgroundColor: Colors.white,
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
                    backgroundColor: Colors.white,
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

            //                 ],
            //               )
            //             ]
            //           ],
            //         ),
            //       );
            //     }),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: AnimatedBuilder(
            animation: _scrollController,
            builder: (BuildContext context, Widget child) {
              return AnimatedContainer(
                width: size.width,
                height: _scrollController.position.userScrollDirection ==
                    ScrollDirection.reverse
                    ? 0
                    : 80,
                duration: Duration(microseconds: 500),
                child: child,
              );
            },
            child: Stack(
              children: [
                CustomPaint(size: Size(size.width, 80), painter: CPainter()),
                Center(
                  heightFactor: 0.6,
                  child: CircleAvatar(
                    radius: 37,
                    backgroundColor: Colors.white,
                    child: FloatingActionButton(
                      onPressed: () {},
                      backgroundColor: Color(0xff150927),
                      child: StreamBuilder<AudioState>(
                          stream: _audioStateStream,
                          builder: (context, snapshot) {
                            final audioState = snapshot.data;
                            final queue = audioState?.queue;
                            final mediaItem = audioState?.mediaItem;
                            final playbackState = audioState?.playbackState;
                            final processingState =
                                playbackState?.processingState ??
                                    AudioProcessingState.none;
                            final playing = playbackState?.playing ?? false;
                            return !playing
                                ? IconButton(
                              icon: FaIcon(FontAwesomeIcons.play),
                              onPressed: () => AudioService.play(),
                            )
                                : IconButton(
                              icon: FaIcon(FontAwesomeIcons.pause),
                              onPressed: () => AudioService.pause(),
                            );
                          }),
                      elevation: 0.1,
                    ),
                  ),
                ),
                StreamBuilder<AudioState>(
                    stream: _audioStateStream,
                    builder: (context, snapshot) {
                      final audioState = snapshot.data;
                      final queue = audioState?.queue;
                      final mediaItem = audioState?.mediaItem;
                      return Container(
                        width: size.width,
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: FaIcon(FontAwesomeIcons.backward,
                                  color: Color(0xffBB8834)),
                              onPressed: () {
                                if (mediaItem == queue.first) {
                                  return;
                                }
                                AudioService.skipToPrevious();
                                // AudioService.skipToQueueItem(mediaId)
                              },
                            ),
                            Container(width: size.width * 0.20),
                            IconButton(
                              icon: FaIcon(FontAwesomeIcons.forward,
                                  color: Color(0xffBB8834)),
                              onPressed: () {
                                if (mediaItem == queue.last) {
                                  return;
                                }
                                AudioService.skipToNext();
                              },
                            ),
                          ],
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Widget slider() {
    return Slider.adaptive(
      min: 0.0,
      value: position.inSeconds.toDouble(),
      onChanged: (double value) {
        setState(() {
          advancedPlayer.seek(Duration(seconds: value.toInt()));
        });
      },
      max: duration.inSeconds.toDouble(),
    );
  }

  void getAudio(String asset) async {
    if (playing) {
      var res = await advancedPlayer.pause();
      if (res == 1) {
        setState(() {
          playing = false;
        });
      }
    } else {
      var res = await advancedPlayer.play(asset, isLocal: true);
      if (res == 1) {
        setState(() {
          playing = true;
        });
      }
      advancedPlayer.onDurationChanged.listen((Duration dr) {
        setState(() {
          duration = dr;
        });
      });
      advancedPlayer.onAudioPositionChanged.listen((Duration dr) {
        setState(() {
          position = dr;
        });
      });
    }
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
    await Share.share(
        "Advance Offline Qur’ān application with learning environment",
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
