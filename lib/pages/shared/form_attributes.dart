import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:save_pdf/services/database.dart';
import 'constants.dart';

/*
Shared list of attributes to create assigment and to create reports.
*/
class FormAttributes {
  final Future<DocumentSnapshot> docSnapshot =
      DatabaseService().getReportForm();
  List attributeList = [];

  Future<void> getDocs() async {
    try {
      DocumentSnapshot rf = await DatabaseService().getReportForm();
      rf.data().keys.forEach((att) => attributeList.add(att));
    } catch (e) {
      print(e);
    }
  }

  Future<Map> getWidgetMap() async {
    try {
      await getDocs();
      Map widgetMap = {};
      attributeList.forEach((subject) {
        widgetMap[subject] = getAttribute(subject);
      });
      return widgetMap;
    } catch (e) {
      print(e);
    }
  }

  Widget getAttribute(String subject) {
    return TextFormField(
      decoration: textIputDecoration.copyWith(hintText: subject),
    );
  }

  Future<List<Widget>> getFullWidgetList() async {
    try {
      Map widgetMap = await getWidgetMap();
      List<Widget> widgetList = [];

      for (String k in widgetMap.keys) {
        widgetList.add(widgetMap[k]);
      }

      return widgetList;
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<List<Widget>> getCustomWidgetList(Map instructions) async {
    try {
      Map widgetMap = await getWidgetMap();

      List<Widget> widgetList = [];
      instructions.forEach((key, value) {
        if (value) {
          widgetList.add(widgetMap[key]);
        }
      });

      print(widgetList);
      return widgetList;
    } on Exception catch (e) {
      print(e);
    }
  }
}
