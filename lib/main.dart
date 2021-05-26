import 'dart:async';

import 'package:cowin_setu/PODO_By_Pin/podo_by_pin.dart';
import 'package:flutter/material.dart';
import 'Network/Network.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<PodoByPin> podoData;
  int index = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        index++;
        podoData = Network.getData();
        podoData.then((value) {
          print(
              "$index]${value.sessions[1].name}-> D1 : ${value.sessions[0].availableCapacityDose1}, D2 : ${value.sessions[0].availableCapacityDose2}");
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cowin Setu"),
      ),
      body: Text("Hello"),
    );
  }
}
