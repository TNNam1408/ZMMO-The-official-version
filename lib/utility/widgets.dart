import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';

InputDecoration buildInputDecoration(String hintText,String labeltext, IconData icon) {
  return InputDecoration(
    prefixIcon: Icon(icon, color: Colors.black),
    labelText: labeltext, labelStyle: TextStyle( color: Colors.black,fontSize: 20),
    hintText: hintText,hintStyle: TextStyle( color: Colors.black,fontSize: 20),
    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.0),
    ),
  );
}

// MaterialButton longButtons(String title, Function fun,
//     {Color color: Colors.orange, Color textColor: Colors.white}) {
//   return MaterialButton(
//     onPressed: fun,
//     textColor: textColor,
//     color: color,
//     child: SizedBox(
//       width: double.infinity,
//       child: Text(
//         title,
//         textAlign: TextAlign.center,
//         style: TextStyle(fontSize: 20),
//       ),
//     ),
//     height: 45,
//     minWidth: 600,
//     shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.all(Radius.circular(10))),
//   );
// }