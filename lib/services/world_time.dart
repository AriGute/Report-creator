import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String location; // location name for the UI
  String time; // the time in that location
  String flag; // url to an asset flag icon
  String url; // location url for api endpoint
  bool isDaytime; // true or false if dayime or not

  WorldTime({this.location, this.flag, this.url});

  void getTime() async {
    try {
      http.Response response = await http
          .get(Uri.parse('http://worldtimeapi.org/api/timezone/$url'));
      Map data = jsonDecode(response.body);
      // get propaties from data
      String datetime = data['datetime'];
      String offset = data['utc_offset'];
      int hoursOffSet = int.parse(offset.split('+')[1].split(':')[0]);
      // create DatTime object
      DateTime now = DateTime.parse(datetime);

      now = now.add(Duration(hours: hoursOffSet));
      isDaytime = now.hour > 6 && now.hour < 20 ? true : false;
      time = DateFormat.jm().format(now);
    } catch (e) {
      print(e);
      time = 'could not get time data';
      location = 'could not get location data';
      flag = 'could not get flag data';
    }
  }
}
