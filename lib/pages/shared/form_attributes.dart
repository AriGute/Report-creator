import 'package:flutter/material.dart';

/*
Shared list of widget to create assigment and crete reports.

Adding any widget to originalList will lead to adding widget in
create assignment and create report.
*/
class FormAttributes {
  Map getWidgetMap() {
    Map originalList = {};
    originalList["widget1"] = Text("data1");
    originalList["widget2"] = Text("data2");
    originalList["widget3"] = Text("data3");
    originalList["widget4"] = Text("data4");

    return originalList;
  }

  List<Widget> getFullWidgetList() {
    Map widgetMap = getWidgetMap();
    List<Widget> widgetList = [];

    for (String k in widgetMap.keys) {
      widgetList.add(widgetMap[k]);
    }

    return widgetList;
  }

  List<Widget> getCustomWidgetList(Map instructions) {
    Map widgetMap = getWidgetMap();

    List<Widget> widgetList = [];
    instructions.forEach((key, value) {
      if (value) {
        widgetList.add(widgetMap[key]);
      }
    });

    print(widgetList);
    return widgetList;
  }
}
