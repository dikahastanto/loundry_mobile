import 'package:flutter/material.dart';
import 'package:flutter_app/Settings.dart';

class DetailPembayaran extends StatelessWidget {
  DetailPembayaran({this.gambar});
  String gambar;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Detail Pembayaran',
          style: TextStyle(
            color: textColor
          ),
        ),
        elevation: 0.0,
        backgroundColor: fourth,
        leading: IconButton(
          icon: Icon(Icons.close),
          color: textColor,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Image.network(masterurl + 'img/transaksi/' + gambar.toString()),
          )
        ],
      ),
    );
  }
}
