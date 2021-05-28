import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget loadAppBar() {
  return AppBar(
    title: Text("Cowin Setu"),
    backgroundColor: Colors.grey[800],
  );
}

Widget pinCodeText() {
  return Text(
    "Please Enter Your Pin Code",
    style: TextStyle(
      color: Colors.grey[100],
      fontSize: 15,
    ),
  );
}

Widget sizedBox() {
  return SizedBox(
    height: 20,
  );
}
