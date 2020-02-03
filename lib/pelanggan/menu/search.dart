import 'package:flutter/material.dart';
import 'package:flutter_app/Settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_app/pelanggan/menu/profile.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  TextEditingController controllerKeyword = new TextEditingController();

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

  bool serarched = false;

  Future<List> getData() async {
    var url = masterurl + "search";
    final respon = await http.post(url, body: {
      "keyword": controllerKeyword.text,
    });
    return json.decode(respon.body);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: fourth,
          title: Text(
            'Search',
            style: TextStyle(
                color: textColor
            ),
          )
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.only(left: 10, right: 10),
            color: fourth,
            child: TextFormField(
              controller: controllerKeyword,
              decoration: new InputDecoration(
                  hintText: "Masukan Keyword",
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      color: third,
                      autofocus: false,
                      onPressed: () {
                        if (controllerKeyword.text != '') {
                          setState(() {
                            serarched = true;
                          });
                        }
                      })
              ),
            ),
          ),
          serarched ? new FutureBuilder<List>(
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? new ItemList(
                  list: snapshot.data
              )
                  : Container(
                padding: EdgeInsets.only(top: 40.0),
                child: Center(
                  child: new CircularProgressIndicator(),
                ),
              );
            },
            future: getData(),
          ) : Text('')
        ],
      ),
    );
  }
}

class ItemList extends StatelessWidget {
  final List list;

  ItemList({this.list});

  String cekStatus (int status) {
    return status.toString();
  }

  Widget Cel (int status) {
    String ketStatus;
    var warna = null;
    if (status == 1) {
      ketStatus = 'Mengunggu Konfrimasi';
      warna = Colors.redAccent;
    } else if (status == 2) {
      ketStatus = 'Sedang Diproses';
      warna = Colors.amber;
    } else {
      ketStatus = 'Sudah Selesai';
      warna = Colors.greenAccent;
    }
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: warna,
          borderRadius: BorderRadius.circular(10.0)
      ),
      alignment: Alignment.center,
      child: Text(
        ketStatus,
        style: TextStyle(
            color: fourth,
            fontSize: 15.0
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (context, i) {
          return Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                height: 185.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: fourth,
                    borderRadius: BorderRadius.circular(20.0)
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            list[i]['namaLengkap'],
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          RatingBarIndicator(
                            rating: 3,
                            itemCount: 5,
                            itemSize: 30.0,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Icon(Icons.pin_drop),
                          Text(list[i]['alamat'])
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) => new Profile(id: list[i]['id'].toString(),),
                          ));
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              color: third,
                              borderRadius: BorderRadius.circular(10.0)
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Lihat Profile',
                            style: TextStyle(
                                color: textColor,
                                fontSize: 15.0
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }
}
