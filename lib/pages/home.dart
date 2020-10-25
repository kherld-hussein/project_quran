import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:project_quran/bloc/quran_bloc.dart';
import 'package:rxdart/rxdart.dart';

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

  @override
  void dispose() {
    AudioService.stop();
    super.dispose();
  }

  Future<int> _getDuration() async {
    File audiofile = await audioCache.load('audio/051.mp3');
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
                '051.mp3 duration is: ${Duration(milliseconds: snapshot.data)}');
        }
        return null; // unreachable
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Al Qur’ān')),
      body: Container(
        padding: EdgeInsets.all(20),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Row(
                      children: [
                        Image.asset('assets/images/logo.jpg', scale: 5),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Play Local Asset \'050.mp3\':'),
                            _Btn(
                                txt: 'Play',
                                onPressed: () => audioCache
                                    .play('audio/050.mp3', volume: 30)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Image.asset('assets/images/logo.jpg', scale: 5),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('Loop Local Asset \'079.mp3\':'),
                          _Btn(
                              txt: 'Loop',
                              onPressed: () =>
                                  audioCache.loop('audio/050.mp3')),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Image.asset('assets/images/logo.jpg', scale: 5),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('Play Local Asset \'audio2.mp3\':'),
                          _Btn(
                              txt: 'Play',
                              onPressed: () =>
                                  audioCache.play('audio/051.mp3')),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Image.asset('assets/images/logo.jpg', scale: 5),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // Text('Play Local Asset In Low Latency \'050.mp3\':'),
                          _Btn(
                              txt: 'Play',
                              onPressed: () => audioCache.play('audio/079.mp3',
                                  mode: PlayerMode.LOW_LATENCY)),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Image.asset('assets/images/logo.jpg', scale: 5),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // Text(
                          //     'Play Local Asset Concurrently In Low Latency \'050.mp3\':'),
                          _Btn(
                              txt: 'Play',
                              onPressed: () async {
                                await audioCache.play('audio/050.mp3',
                                    mode: PlayerMode.LOW_LATENCY);
                                await audioCache.play('audio/051.mp3',
                                    mode: PlayerMode.LOW_LATENCY);
                              }),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Image.asset('assets/images/logo.jpg', scale: 5),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // Text('Play Local Asset In Low Latency \'051.mp3\':'),
                          _Btn(
                              txt: 'Play',
                              onPressed: () => audioCache.play('audio/051.mp3',
                                  mode: PlayerMode.LOW_LATENCY)),
                        ],
                      )
                    ],
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

class _Btn extends StatelessWidget {
  final String txt;
  final VoidCallback onPressed;

  const _Btn({Key key, this.txt, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
        minWidth: 48.0,
        child: RaisedButton(child: Text(txt), onPressed: onPressed));
  }
}
