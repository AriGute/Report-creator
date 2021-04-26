import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void getTime() async {
    http.Response response = await http
        .get(Uri.parse('http://worldtimeapi.org/api/timezone/Europe/London'));
    Map data = jsonDecode(response.body);
    // get propaties from data
    String datetime = data['datetime'];
    String offset = data['utc_offset'];
    int hoursOffSet = int.parse(offset.split('+')[1].split(':')[0]);
    // create DatTime object
    DateTime now = DateTime.parse(datetime);
    print(hoursOffSet);

    print(now);
    now = now.add(Duration(hours: hoursOffSet));
    print(now);
  }

  @override
  void initState() {
    super.initState();
    getTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Loading screen'),
    );
  }
}
