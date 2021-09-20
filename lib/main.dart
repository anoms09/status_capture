// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:status_capture/pages/home.dart';
import 'package:status_capture/pages/save.dart';

void main() {
  runApp(MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (context) => Home(),
        '/save': (context) => Save(),
      }
  ));
}



