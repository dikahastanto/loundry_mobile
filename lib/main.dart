import 'package:flutter/material.dart';
import 'dart:async';
import 'Login.dart';
import 'package:flutter_app/owner/Home.dart' as homeLoundry;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/pelanggan/Home.dart' as Pelanggan;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loundry',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  void pref () async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if(sharedPreferences.getBool("status") == true){
      if(sharedPreferences.getString('level') == '1') {
        Navigator.pushReplacement(context, new MaterialPageRoute(
            builder: (BuildContext context) => new homeLoundry.HomeOwner()
        )
        );
      } else {
        Navigator.pushReplacement(context, new MaterialPageRoute(
            builder: (BuildContext context) => new Pelanggan.Home()
        )
        );
      }
    }else{
      Navigator.pushReplacement(context, new MaterialPageRoute(
          builder: (BuildContext context) => new Login())
      );
    }
  }

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, pref);
  }


  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: new Center(
          child: new Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Image.asset("img/bg.png",width: 250.0,),
                new Padding(padding: new EdgeInsets.only(top: 25.0)),
                new CircularProgressIndicator()
              ],
            ),
          )
      ),
    );
  }
}
