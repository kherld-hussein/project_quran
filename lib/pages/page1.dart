import 'package:flutter/material.dart';
import 'package:flutter_playout/player_state.dart';

class PlayOut extends StatefulWidget {
  @override
  _PlayOutState createState() => _PlayOutState();
}

class _PlayOutState extends State<PlayOut> {
  PlayerState _desiredState = PlayerState.PLAYING;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        color: Colors.black,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Container(child: Image.asset('assets/images/logo.png')),
            ),
            SliverToBoxAdapter(child: Container()),
            SliverToBoxAdapter(),
          ],
        ),
      ),
    );
  }
}
