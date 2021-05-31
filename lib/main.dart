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
        keyboardType: TextInputType.number,
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
          date = DateUtil.loadDate();
          podoData = Network.getData(date, text);
          podoData.then((value) {
            if(value.error==true){
              print("Invalid Pincode");
            }
            else if (value.sessions.length == 0) {
              print("currently not as vaccine provider");
            } else {
              // Handling of server side error left, to be done !
              bool validRequest = makeApiRequestsAtIntervals(text);
              if (!validRequest) {
                print("Unable to fecth data");
              }
            }
          });
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
            if(value.error==true){
              return false;
            }
            else if (value.sessions.length == 0) {
              return false;
            }
            print(
                "$index]${value.sessions[0].name}-> D1 : ${value.sessions[0].availableCapacityDose1}, D2 : ${value.sessions[0].availableCapacityDose2}");
          });
        });
      });
    });
    return true;
  }
}
