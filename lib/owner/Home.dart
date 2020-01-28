import 'package:flutter/material.dart';
import 'package:flutter_app/owner/menu/profile.dart';
import './menu/home.dart' as tabhome;
import './menu/input.dart' as input;
//import './Menu/Menu1.dart' as tabmenu1;
//import './Menu/Menu2.dart' as tabmenu2;
import '../Settings.dart';

class HomeOwner extends StatefulWidget {
  @override
  _HomeOwnerState createState() => _HomeOwnerState();
}

class _HomeOwnerState extends State<HomeOwner> with SingleTickerProviderStateMixin{

  TabController controller;
  int currentTab = 0;
  final List<Widget> screens = [
    tabhome.Home(),
    input.Input()
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = tabhome.Home();

  @override
  void initState() {
    // TODO: implement initState
    controller = new TabController(length: 3, vsync: this);
    super.initState();
  }
  
  _getTittle (current) {
    String tittle;
    if (current == 0) {
      tittle = 'Pemesanan';
    } else if (current == 1) {
      tittle = 'Input Paket';
    } else {
      tittle = 'Profile';
    }
    return tittle;
  }


  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: fourth,
        elevation: 0.0,
        title: new Text(_getTittle(currentTab), style: new TextStyle(
            color: secondary, fontWeight: FontWeight.bold
          ),
        ),
      ),

//      bottomNavigationBar: new TabBar(
//        controller: controller,
//        indicatorColor: Colors.white,
//        labelColor: appbarcolor,
//        unselectedLabelColor: Colors.lightBlue[200],
//        tabs: <Widget>[
//          new Tab(icon: new Icon(Icons.add_shopping_cart),),
//          new Tab(child: FloatingActionButton(
//            backgroundColor: appbarcolor,
//            autofocus: true,
//            isExtended: true,
//
//            child: new Icon(Icons.add),
//            elevation: 0
//          )),
//          new Tab(icon: new Icon(Icons.person)),
//        ],
//      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            currentScreen = input.Input(); // if user taps on this dashboard tab will be active
            currentTab = 1;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Container(
              padding: new EdgeInsets.only(left: 20.0),
              child: IconButton(
                color: secondary,
                icon: Icon(Icons.add_shopping_cart),
                onPressed: () {
                  setState(() {
                    currentScreen = tabhome.Home(); // if user taps on this dashboard tab will be active
                    currentTab = 0;
                  });
                },
              ),
            ),
            new Container(
              padding: new EdgeInsets.only(right: 20.0),
              child: IconButton(
                icon: Icon(Icons.perm_identity),
                color: secondary,
                onPressed: () {
                  setState(() {
                    currentScreen = Profile();
                    currentTab = 2;
                  });
                },
              ),
            )
          ],
        ),
      ),
      backgroundColor: third,
      body: PageStorage(
          child: currentScreen,
          bucket: bucket
      ),
//        new TabBarView(
//            controller: controller,
//            children: <Widget>[
//              new tabhome.Home(),
//              new input.Input(),
//              new tabhome.Home()
//            ]
//        )


    );
  }
}
