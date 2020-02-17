import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Settings.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Input extends StatefulWidget {
  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  final _forminsert = GlobalKey<FormState>();
  final globalKey = GlobalKey<ScaffoldState>();
  TextEditingController controllerNama=new TextEditingController();
  TextEditingController controllerHarga=new TextEditingController();
  TextEditingController controllerIsi=new TextEditingController();
  File _image;

  Future getImageGalery() async {

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

  Future<void> upload(File imagefile) async{

    var stream = new http.ByteStream(DelegatingStream.typed(imagefile.openRead()));

    var length = await imagefile.length();
    var uri = Uri.parse(masterurl +'produk/insert');

    var request = new http.MultipartRequest("POST", uri);


    var multipartfile = new http.MultipartFile("image", stream, length,filename: basename(imagefile.path));
    request.fields['nama'] = controllerNama.text;
    request.fields['harga'] = controllerHarga.text;
    request.fields['isi'] = controllerIsi.text;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    request.fields['idUser'] = sharedPreferences.getString("id");
    request.files.add(multipartfile);


    var response = await request.send();
    var responseSTR = await response.stream.bytesToString();
    var res = json.decode(responseSTR);
    print(res);
    if(res['sukses']){
      showSnackbar(res['msg'], suksesColor);
      reset();
    }else{
      showSnackbar(res['msg'], dangerColor);
    }


  }

  void reset () {
    setState(() {
      _image = null;
      controllerNama.clear();
      controllerIsi.clear();
      controllerHarga.clear();
    });
  }

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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      body: ListView(
        children: <Widget>[
          Form(
            key: _forminsert,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                  ),

                  new Container(
                        color: fourth,
                        padding: new EdgeInsets.only(left: 20.0, right: 20.0, bottom: 50.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              color: third,
                              padding: EdgeInsets.only(left: 20.0, right: 20),
                              child: TextFormField(
                                controller: controllerNama,
                                validator: (value) => value.isEmpty ? 'Nama tidak boleh kosong' : null,
                                decoration: new InputDecoration(
                                    hintText: "Masukan Nama",
                                    border: InputBorder.none
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                            ),
                            Container(
                              color: third,
                              padding: EdgeInsets.only(left: 20.0, right: 20),
                              child: TextFormField(
                                controller: controllerHarga,
                                keyboardType: TextInputType.number,
                                validator: (value) => value.isEmpty ? 'Harga Tidak Boleh Kosong' : null,
                                decoration: new InputDecoration(
                                    hintText: "Masukan Harga",
                                    border: InputBorder.none
                                ),
                              )
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                            ),
                            Container(
                              color: third,
                              padding: EdgeInsets.only(left: 20.0, right: 20),
                              child: TextFormField(
                                controller: controllerIsi,
                                maxLines: 8,
                                validator: (value) => value.isEmpty ? 'Isi tidak boleh kosong' : null,
                                decoration: new InputDecoration(
                                  hintText: "Masukan Isi",
                                  border: InputBorder.none
                                ),
                              )
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                            ),
                            RaisedButton(
                                elevation: 0.0,
                                onPressed: (){
                                  getImageGalery();
                                },
                                child: new Text("Insert Gambar"),
                            ),
                            _image==null ? new Text("Tidak Ada Gambar dipilih") : new Image.file(_image, scale: 1.0,),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                            ),
                            ButtonTheme(
                              minWidth: 400.0,
                              height: 45.0,
                              child: new RaisedButton(
                                  child: new Text(
                                    "Input",
                                    style: new TextStyle(fontSize: 20.0, color: Colors.white),
                                  ),
                                  onPressed: () {
                                    if (_forminsert.currentState.validate()) {
                                      upload(_image);
                                    }
                                  },
                                  elevation: 0.0,
                                  color: primary,
                                  shape: new RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(30.0)
                                  )
                              ),
                            )
                          ],
                        )
                    ),

                ],
              ),
            ),
          )
        ],
      )
    );
  }
}
