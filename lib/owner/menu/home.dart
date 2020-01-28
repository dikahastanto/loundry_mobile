import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Settings.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          Expanded(
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Container(
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Nama Paket',
                          style: TextStyle(
                              fontSize: 20
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 10),),
                        Text(
                          'Nama Paket',
                          style: TextStyle(
                              fontSize: 20
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 10),),
                        ButtonTheme(
                          minWidth: 200.0,
                          height: 40.0,
                          child: new RaisedButton(
                              child: new Text(
                                "Detail Pemesanan",
                                style: new TextStyle(fontSize: 20.0, color: Colors.white),
                              ),
                              onPressed: () {
                              },
                              elevation: 0.0,
                              color: secondary,
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0)
                              )
                          ),
                        )
                      ],
                    )
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    color: fourth,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5.0,
                        offset: Offset(0, 3)
                      )
                    ],
                  ),
                ),
              )
          )
        ],
      ),
    );
  }
}
