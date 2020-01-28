import 'package:flutter/material.dart';
import 'package:flutter_app/Settings.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/owner/DetailPromosi.dart';
import 'package:flutter_app/Login.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Future<List> getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var url = masterurl + "produk/getuserporduk/" + sharedPreferences.get('id');
    final respon = await http.get(url);
//    print(json.decode(respon.body));
    return json.decode(respon.body);

  }

  String namaLengkap = '', alamat = '-';
  void getProfile () async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      namaLengkap = sharedPreferences.getString('namaLengkap');
      alamat = sharedPreferences.getString('alamat');
    });
  }

  @override
  void initState() {
    getProfile();
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
    return new Scaffold(
      body: new ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 15.0, bottom: 20.0),
            color: fourth,
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 20),
                  child: CircleAvatar(
                    backgroundColor: secondary,
                    radius: 40,
                    child: Icon(Icons.perm_identity, size: 50.0)
                  ),
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        namaLengkap,
                        style: TextStyle(
                            color: textColor,
                            fontSize: 23,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        alamat,
                        style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      RatingBarIndicator(
                        rating: 4.0,
                        itemCount: 5,
                        itemSize: 30.0,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ),
          Container(
            color: fourth,
            padding: EdgeInsets.only(left: 15,right: 15),
            child: ButtonTheme(
              minWidth: 400.0,
              height: 45.0,
              child: new RaisedButton(
                  child: new Text(
                    "Logout",
                    style: new TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                  onPressed: () {
                    logout();
                    Navigator.pushReplacement(context, new MaterialPageRoute(
                        builder: (BuildContext context) => Login()
                    )
                    );
                  },
                  elevation: 0.0,
                  color: secondary
              ),
            )
          ),
          Padding(padding: EdgeInsets.only(top: 20.0)),
          Container(
            color: fourth,
            padding: EdgeInsets.only(right: 20, left: 15, top: 20, bottom: 20),
            child: Row(
              children: <Widget>[
                Text(
                  'Promosi Anda',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: textColor
                  ),
                )
              ],
            )
          ),
          new FutureBuilder<List>(
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? new ItemList(
                list: snapshot.data
              )
                  : new Center(
                child: new CircularProgressIndicator(),
              );

            },
            future: getData(),
          ),
        ],
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List list;

  ItemList({this.list});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      shrinkWrap: true,
        physics: ScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (context, i) {
          return new Container(
              padding: new EdgeInsets.all(5.0),
              child: new GestureDetector(
                onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new DetailPromosi(list: list,index: i,),
                    ));
                },
                child: new Card(
                  elevation: 0.0,
                  child: new ListTile(
                      contentPadding: new EdgeInsets.all(10.0),
                      trailing: new Icon(Icons.arrow_forward_ios,size: 20.0,),
                      title: new Text(
                          list[i]['nama'],
                          style: TextStyle(
                            color: textColor,
                            fontSize: 20
                          ),
                      ),
//                      leading: new Image.network(masterurl+"/img/"+list[i]['gambar'],scale: 16.0,),
                      subtitle:  new Text('Rp.' + list[i]['harga'].toString() + ',-')
                  ),
                ),
              ));
        });
  }
}