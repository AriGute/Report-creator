import 'package:flutter/material.dart';

const double boxSize = 5;

const textIputDecoration = InputDecoration(
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2.0)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2.0)));

Widget customTextFormField(String text, Function func) {
  return Container(
    height: 40,
    child: TextFormField(
      decoration: textIputDecoration.copyWith(
          hintText: text,
          labelText: text,
          labelStyle: TextStyle(color: Colors.grey[400])),
      onChanged: (val) => func(val),
    ),
  );
}
