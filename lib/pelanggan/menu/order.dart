import 'package:flutter/material.dart';
import 'package:flutter_app/Settings.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_app/pelanggan/detail.dart';
import 'package:flutter_app/pelanggan/Pesan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Order extends StatefulWidget {
  @override
  _OrderState createState() => _OrderState();
}


class _OrderState extends State<Order> {

  Future<List> getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString('id');
    var url = masterurl + "transaksi/pelanggan/" + id;
    final respon = await http.get(url);
    return json.decode(respon.body);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: fourth,
          title: Text(
            'Pesanan',
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
                margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 5.0),
                height: 185.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: fourth,
                    borderRadius: BorderRadius.circular(20.0)
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            list[i]['namaProduk'],
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
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
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
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: <Widget>[
                          Cel(list[i]['status'])
                        ],
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
