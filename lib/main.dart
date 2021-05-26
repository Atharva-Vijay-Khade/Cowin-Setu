import 'dart:async';
import 'dart:html';
import 'package:cowin_setu/PODO_By_Pin/podo_by_pin.dart';
import 'package:flutter/material.dart';
import 'Network/Network.dart';
import 'UI/ui.dart';
import 'Util/getCurrentDate.dart';

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
  String pinCode;
  String date;
  int index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: loadAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Please Enter Your Pin Code",
              style: TextStyle(
                color: Colors.grey[100],
                fontSize: 15,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 400,
              child: TextField(
                style: TextStyle(
                  color: Colors.white,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  hintText: "410206",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  icon: Icon(
                    Icons.location_city,
                    color: Colors.grey,
                  ),
                  hoverColor: Colors.white,
                ),
                onSubmitted: (text) {
                  setState(() {
                    pinCode = text;
                    date = DateUtil.loadDate();
                    Timer.periodic(Duration(seconds: 3), (timer) {
                      setState(() {
                        index++;
                        podoData = Network.getData(date, text);
                        podoData.then((value) {
                          print(
                              "$index]${value.sessions[1].name}-> D1 : ${value.sessions[0].availableCapacityDose1}, D2 : ${value.sessions[0].availableCapacityDose2}");
                        });
                      });
                    });
                  });
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[900],
    );
  }
}
