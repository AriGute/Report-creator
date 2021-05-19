import 'package:flutter/material.dart';

class FormAttributes {
  Map getWidgetMap() {
    Map originalList = {};
    originalList["widget1"] = Text("data1");
    originalList["widget2"] = Text("data2");
    originalList["widget3"] = Text("data3");
    originalList["widget4"] = Text("data4");

    return originalList;
  }

  List<Widget> getWidgetList() {
    Map widgetMap = getWidgetMap();
    List<Widget> widgetList = [];

    for (String k in widgetMap.keys) {
      widgetList.add(widgetMap[k]);
    }

    return widgetList;
  }
}
