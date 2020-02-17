import 'package:flutter/material.dart';
import 'package:flutter_app/Settings.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_app/pelanggan/detail.dart';
import 'package:flutter_app/pelanggan/Pesan.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

Future<List> getData() async {
  var url = masterurl + "produk/allporduk";
  final respon = await http.get(url);
  return json.decode(respon.body);

}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: fourth,
        title: Text(
          'Home',
          style: TextStyle(
          color: textColor
        ),
        )
      ),
      backgroundColor: Colors.grey[100],

      body: ListView(
        children: <Widget>[
          new FutureBuilder<List>(
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
          )
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
                      Text(list[i]['isi']),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                          list[i]['namaLengkap'],
                          style: TextStyle(
                              color: Colors.grey
                          )
                      ),
                      RatingBarIndicator(
                        rating: list[i]['totalRating'].toDouble(),
                        itemCount: 5,
                        itemSize: 20.0,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
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
