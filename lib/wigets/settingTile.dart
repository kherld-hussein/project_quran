import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsTitle extends StatelessWidget {
  final String title;

  const SettingsTitle({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(6, 8, 6, 8),
      child: Text(title, style: TextStyle(color: Colors.white, fontSize: 20)),
    );
  }
}
