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

class Detail extends StatefulWidget {
  Detail({this.list,this.index});
  List list;
  int index;
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> with SingleTickerProviderStateMixin {
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

    Navigator.pop(context);

    _settingModalBottomSheet(context);

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
        Navigator.pop(context);
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _settingModalBottomSheet(context);
        },
        isExtended: true,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        icon: Icon(Icons.shopping_basket),
        label: Text('Pesan Sekarang'),
      ),
      body: ListView(
        children: <Widget>[
          new Stack(
            children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: fourth,
                            offset: Offset(0.0, 2.0),
                            blurRadius: 6.0
                        )
                      ]
                  ),
                  child: Hero(
                    tag: widget.list[widget.index]['gambar'],
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0)),
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: masterurl + "img/produk/" + widget.list[widget.index]['gambar'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
              ),
              Padding(
                padding: EdgeInsets.only(left: 0.0, top: 35.0),
                child: Row(
                  children: <Widget>[
                    RawMaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: new Icon(
                        Icons.arrow_back_ios,
                        color: fourth,
                        size: 20.0,
                      ),
                      shape: new CircleBorder(),
                      elevation: 0.0,
                      fillColor: Color(0xff001a3a).withOpacity(0.8),
                      padding: const EdgeInsets.all(0.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.list[widget.index]['nama'],
                      style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: textColor
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    Text(
                      widget.list[widget.index]['isi'],
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: textColor
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Harga',
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w300,
                              color: textColor
                          ),
                        ),
                        Text(
                          'Rp.' + widget.list[widget.index]['harga'].toString() + ',-',
                          style: TextStyle(
                              fontSize: 15.0,
                              color: textColor
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Pemilik',
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w300,
                              color: textColor
                          ),
                        ),
                        Text(
                          widget.list[widget.index]['namaLengkap'],
                          style: TextStyle(
                              fontSize: 15.0,
                              color: textColor
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 5.0)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Rating',
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w300,
                              color: textColor
                          ),
                        ),

                        RatingBarIndicator(
                          rating: 4.0,
                          itemCount: 5,
                          itemSize: 20.0,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ),
            ],
          ),
        ],
      ),
    );
  }
}
