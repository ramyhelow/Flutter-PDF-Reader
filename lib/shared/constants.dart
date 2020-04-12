import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  errorStyle: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
    hintText: 'Email',
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2.0)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.pink, width: 2.0)));
