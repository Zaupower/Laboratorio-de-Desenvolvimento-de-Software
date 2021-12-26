
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

  CallCostumToast(String words){
  Fluttertoast.showToast(
      msg:
      words,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.amberAccent[100],
      textColor: Colors.black,
      fontSize: 10.0);
}