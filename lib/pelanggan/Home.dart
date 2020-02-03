import 'package:flutter/material.dart';
import 'package:flutter_app/Settings.dart';
import 'package:flutter_app/pelanggan/menu/home.dart' as tabHome;
import 'package:flutter_app/pelanggan/menu/order.dart' as tabOrder;
import 'package:flutter_app/pelanggan/menu/search.dart' as tabSearch;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  TabController controller;

  @override
  void initState() {
    // TODO: implement initState
    controller = new TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//        bottom: TabBar(
//          controller: controller,
//          tabs: <Widget>[
//            new Tab(icon: new Icon(Icons.home),),
//            new Tab(icon: new Icon(Icons.assignment)),
//            new Tab(icon: new Icon(Icons.wc)),
//            new Tab(icon: new Icon(Icons.people)),
//          ],
//        ),
        bottomNavigationBar: Material(
          color: fourth,
          child: TabBar(
            labelColor: secondary,
            controller: controller,
            tabs: <Widget>[
              new Tab(icon: new Icon(Icons.home)),
              new Tab(icon: new Icon(Icons.assignment)),
              new Tab(icon: new Icon(Icons.search)),
              new Tab(icon: new Icon(Icons.person_outline)),
            ],
          ),
        ),
        body: new TabBarView(
            controller: controller,
            children: <Widget>[
              new tabHome.Home(),
              new tabOrder.Order(),
              new tabSearch.Search(),
              new tabHome.Home()
            ]
        ),
      backgroundColor: third,
    );
  }
}
