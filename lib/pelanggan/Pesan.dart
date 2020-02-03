import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/Settings.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:convert';
import 'package:async/async.dart';

class Pesan extends StatefulWidget {
  Pesan({this.list,this.index});
  List list;
  int index;
  @override
  _PesanState createState() => _PesanState();
}

class _PesanState extends State<Pesan> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  File _image;
  final globalKey = GlobalKey<ScaffoldState>();

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

  Future getImageGalery(BuildContext context) async {

    var imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery
    );

    setState(() {
      _image = imageFile;
    });

  }


  void showSnackbar(msg, color) {
    final snackBar = SnackBar(content: Text(msg), backgroundColor: color);
    globalKey.currentState.showSnackBar(snackBar);
  }

  Future<void> upload(File imagefile, BuildContext context) async {

    if (imagefile == null) {
      showSnackbar('Mohon Upload Gambar', dangerColor);
    } else {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      String idProduk = widget.list[widget.index]['id'].toString();
      String idPelanggan = sharedPreferences.getString('id');

      var stream = new http.ByteStream(DelegatingStream.typed(imagefile.openRead()));

      var length = await imagefile.length();
      var uri = Uri.parse(masterurl +'transaksi/insert');

      var request = new http.MultipartRequest("POST", uri);


      var multipartfile = new http.MultipartFile("image", stream, length,filename: basename(imagefile.path));

      request.fields['idProduk'] = idProduk;
      request.fields['idPelanggan'] = idPelanggan;
      request.files.add(multipartfile);

      var response = await request.send();
      var responseSTR = await response.stream.bytesToString();
      var res = json.decode(responseSTR);
      if(res['sukses']){
        showSnackbar(res['msg'], suksesColor);
      }else{
        showSnackbar(res['msg'], dangerColor);
      }
    }


  }


  void _settingModalBottomSheet(context){
    showModalBottomSheet(
        elevation: 0.0,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc){
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                color: Colors.transparent,
                height: 500.0,
                child: new Container(
                    decoration: new BoxDecoration(
                        color: fourth,
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(40.0),
                            topRight: const Radius.circular(40.0))),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text(
                            "Upload Bukti Pembayaran",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: textColor
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                        ),
                        Column(
                          children: <Widget>[
                            new OutlineButton(
                                color: textColor,
                                child: new Text("Pilih Gambar", style: TextStyle(color: textColor),),
                                onPressed: () {
                                  getImageGalery(context);
                                },
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
                            ),
                            Container(
                              height: 200.0,
                              child: _image==null ? new Text("Tidak Ada Gambar dipilih") : new Image.file(_image, scale: 1.0,),
                            ),
                            RaisedButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                  side: BorderSide(color: Colors.red)),
                              onPressed: () {
                                upload(_image, context);
                              },
                              color: Colors.red,
                              textColor: Colors.white,
                              elevation: 0.0,
                              child: Text("Upload Bukti Pembayaran",
                                  style: TextStyle(fontSize: 14)),
                            )
                          ],
                        )
                      ],
                    )
                ),
              );
            },
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
            'Upload Bukti Pembayaran',
            style: TextStyle(
              color: textColor
            ),
        ),
        backgroundColor: fourth,
        leading: BackButton(
          color: textColor,
        ),
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 20.0),
              child: Column(
                children: <Widget>[
                  Container(
                    child: _image==null ? new Text("Tidak Ada Gambar dipilih") : new Image.file(_image, scale: 1.0,),
                  ),
                  OutlineButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)
                    ),
                    onPressed: () {
                      getImageGalery(context);
                    },
                    color: secondary,
                    textColor: textColor,
                    child: Text("Pilih Gambar",
                        style: TextStyle(fontSize: 14)),
                  ),
                  RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)
                    ),
                    onPressed: () {
                      upload(_image, context);
                    },
                    color: secondary,
                    textColor: Colors.white,
                    elevation: 0.0,
                    child: Text("Upload Bukti Pembayaran",
                        style: TextStyle(fontSize: 14)),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
