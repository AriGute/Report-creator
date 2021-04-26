import 'package:flutter/material.dart';
import 'package:save_pdf/pages/home.dart';
import 'package:save_pdf/pages/loading.dart';
import 'package:save_pdf/pages/choose_location.dart';

void main() => runApp(MaterialApp(
      initialRoute: '/home',
      routes: {
        '/': (context) => Loading(),
        '/home': (context) => Home(),
        '/location': (contest) => ChooseLocation()
      },
    ));
