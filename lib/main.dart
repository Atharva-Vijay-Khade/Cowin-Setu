import 'dart:async';
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
            pinCodeText(),
            sizedBox(),
            loadTextField(),
          ],
        ),
      ),
      backgroundColor: Colors.grey[900],
    );
  }

  Widget loadTextField() {
    return Container(
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
          podoData = Network.getData(date, text);
          if (podoData == null) {
            SnackBar(content: Text("unable to get data"));
          }
          else{
            // bool ValidRequest = makeApiRequestsAtIntervals(text);
            podoData = Network.getData(date, text);
            podoData.then((value) {
            if(value.sessions.length==0)
              return false;
            });
          }
        },
      ),
    );
  }

  bool makeApiRequestsAtIntervals(String text) {
    setState(() {
      pinCode = text;
      date = DateUtil.loadDate();
      Timer.periodic(Duration(seconds: 3), (timer) {
        setState(() {
          index++;
          podoData = Network.getData(date, text);
          podoData.then((value) {
            if(value.sessions.length==0)
              return false;
            print(
                "$index]${value.sessions[1].name}-> D1 : ${value.sessions[1].availableCapacityDose1}, D2 : ${value.sessions[1].availableCapacityDose2}");
          });
        });
      });
    });
    return true;
  }
}
