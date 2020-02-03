import 'package:flutter/material.dart';
import 'package:flutter_app/Settings.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_app/pelanggan/detail.dart';
import 'package:flutter_app/pelanggan/Pesan.dart';

class Profile extends StatefulWidget {
  Profile({this.id});
  String id;
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Future<List> getData() async {
    var url = masterurl + "produk/getuserporduk/" + widget.id;
    final respon = await http.get(url);
    return json.decode(respon.body);

  }

  String namaLengkap = '', alamat = '-';
  void getProfile () async {
    var url = masterurl + "getprofile/" + widget.id;
    final respon = await http.get(url);
    var res = json.decode(respon.body);
    setState(() {
      namaLengkap = res['namaLengkap'];
      alamat = res['alamat'];
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
      appBar: AppBar(
        title: Text(
            'Profile',
          style: TextStyle(
            color: textColor
          ),
        ),
        backgroundColor: fourth,
        elevation: 0.0,
        leading: BackButton(
          color: textColor,
        ),
      ),
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
                        RatingBar(
                          initialRating: 3,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            print(rating);
                          },
                        ),
                      ],
                    ),
                  )
                ],
              )
          ),
          Padding(padding: EdgeInsets.only(top: 20.0)),
          Container(
              color: fourth,
              padding: EdgeInsets.only(right: 20, left: 15, top: 20, bottom: 20),
              child: Row(
                children: <Widget>[
                  Text(
                    'List Promosi',
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
    return ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (context, i) {
          return Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 5.0),
                height: 185.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: fourth,
                    borderRadius: BorderRadius.circular(20.0)
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(120.0, 20.0, 20.0, 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            list[i]['nama'],
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                          Text(
                              'Rp. ' + list[i]['harga'].toString() + ',-',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600
                              )
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(list[i]['isi']),
                      SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (BuildContext context) => new Pesan(list: list,index: i,)
                              ));
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: secondary,
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Pesan Sekarang',
                                style: TextStyle(
                                    color: fourth,
                                    fontSize: 15.0
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context) => new Detail(list: list,index: i,),
                              ));
                            },
                            child: Container(
                              width: 70.0,
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: third,
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Detail',
                                style: TextStyle(
                                    color: textColor,
                                    fontSize: 15.0
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 20.0,
                left: 20.0,
                bottom: 5.0,
                child: Hero(
                  tag: list[i]['gambar'],
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image(
                        fit: BoxFit.fill,
                        width: 110.0,
                        image: NetworkImage(masterurl  + 'img/produk/' + list[i]['gambar'])
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}