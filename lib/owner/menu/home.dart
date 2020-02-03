import 'package:flutter/material.dart';
import 'package:flutter_app/Settings.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_app/pelanggan/detail.dart';
import 'package:flutter_app/pelanggan/Pesan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/owner/menu/detailpembayaran.dart';
import 'package:flutter_app/owner/Home.dart' as mainHome;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {

  Future<List> getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString('id');
    var url = masterurl + "transaksi/owner/" + id;
    final respon = await http.get(url);
    return json.decode(respon.body);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

  void _showDialog(BuildContext context, id) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Konfirmasi Pemesanan"),
          content: new Text("Apakah anda yakin?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ya"),
              onPressed: () {
                confirm(context, id);
              },
            ),
            new FlatButton(
              child: new Text("Tidak"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _showSelesai(BuildContext context, id) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Selesaikan Pesanan"),
          content: new Text("Apakah anda yakin?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ya"),
              onPressed: () {
                confirm(context, id);
              },
            ),
            new FlatButton(
              child: new Text("Tidak"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _showNotif (BuildContext context, bool sukses) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: sukses ? new Text("Sukses") : new Text("Gagal"),
          content: sukses ? Image.asset('img/success.png') : Image.asset('img/gagal.png'),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Tutup"),
              onPressed: () {
                Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => new mainHome.HomeOwner()
                ));
              },
            )
          ],
        );
      },
    );
  }

  void confirm (BuildContext context,id) async {
    final response = await http.post(masterurl + 'transaksi/confirm/' + id.toString());
//    print(response.body);
    var res = json.decode(response.body);
        _showNotif(context, res['sukses']);
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
                          list[i]['namaPelanggan'],
                          style: TextStyle(
                              color: Colors.grey
                          )
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: <Widget>[
                          list[i]['status'] == 1 ?
                          GestureDetector(
                            onTap: () {
                              _showDialog(context, list[i]['idTransaksi']);
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: secondary,
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Konfirmasi',
                                style: TextStyle(
                                    color: fourth,
                                    fontSize: 15.0
                                ),
                              ),
                            ),
                          ) : GestureDetector(
                            onTap: () {
                              _showSelesai(context, list[i]['idTransaksi']);
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Selesai',
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
                          list[i]['status'] == 1 ? GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (BuildContext context) => new DetailPembayaran(
                                      gambar: list[i]['gambar']
                                  )
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
                                'Lihat Bukti Pembayaran',
                                style: TextStyle(
                                    color: textColor,
                                    fontSize: 15.0
                                ),
                              ),
                            ),
                          ) : Text('')
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
