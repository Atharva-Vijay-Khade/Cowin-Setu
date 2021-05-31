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
      body: Builder(
          // by this builder we create a context of child of scaffold, which we have to use to display the snackbar
          builder: (context) {
        // passing context of widget that instantiated scaffold won't work, thus we create this context
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              pinCodeText(),
              sizedBox(),
              loadTextField(context),
            ],
          ),
        );
      }),
      backgroundColor: Colors.grey[900],
    );
  }

  Widget loadTextField(BuildContext context) {
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
            if (value.error == true) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 5),
                  content: Text("Invalid Pincode"),
                ),
              );
            } else if (value.sessions.length == 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 5),
                  content: Text("Currently not serving as vaccine provider"),
                ),
              );
            } else {
              // Handling of server side error left, to be done !
              bool validRequest = makeApiRequestsAtIntervals(text, context);
              if (!validRequest) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 5),
                    content: Text("Unable to fetch data, Try again later : ("),
                  ),
                );
              }
            }
          });
        },
      ),
    );
  }

  bool makeApiRequestsAtIntervals(String text, context) {
    setState(() {
      pinCode = text;
      date = DateUtil.loadDate();
      Timer.periodic(Duration(seconds: 3), (timer) {
        setState(() {
          index++;
          podoData = Network.getData(date, text);
          podoData.then((value) {
            if (value.error == true) {
              print("Server Side Error");
            } else if (value.sessions.length == 0) {
              print("Not serving vaccine as of now");
            }
            value.sessions.forEach((element) {
              if (element.availableCapacityDose1 > 0 ||
                  element.availableCapacityDose2 > 0) {//logic to be added here
                  }
            });
          });
        });
      });
    });
    return true;
  }
}
