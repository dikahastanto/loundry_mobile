import 'package:flutter/material.dart';
import 'package:flutter_app/Settings.dart';
import 'Settings.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final _formLogin = GlobalKey<FormState>();
  TextEditingController controllerusername = new TextEditingController();
  TextEditingController controllerpassword = new TextEditingController();
  TextEditingController controllernama = new TextEditingController();
  TextEditingController controllernotelp = new TextEditingController();
  TextEditingController controlleralamat = new TextEditingController();
  final globalKey = GlobalKey<ScaffoldState>();
  void showSnackbar(BuildContext context, msg, color) {
    final snackBar = SnackBar(content: Text(msg), backgroundColor: color);
    globalKey.currentState.showSnackBar(snackBar);
  }

  Future<void> _login () async {
    var url = masterurl + 'register';

    final response = await http.post(url, body: {
      "email": controllerusername.text,
      "namaLengkap": controllernama.text,
      "alamat": controlleralamat.text,
      "noTelp": controllernotelp.text,
      "password": controllerpassword.text
    });


    var result = json.decode(response.body);

    if (result['sukses']) {
      String msg = result['msg'];
      showSnackbar(context, msg, suksesColor);
      var _duration = new Duration(seconds: 2);
      new Timer(_duration, () {
        Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => new Login()));
      });


    } else {
      String msg = result['msg'];
      showSnackbar(context, msg, dangerColor);
    }

    return response.body;
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
    return new Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          title: Text(
            'Daftar Akun',
            style: TextStyle(
                color: textColor
            ),
          ),
          backgroundColor: fourth,
          leading: BackButton(
            color: textColor,
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new Login()));
            },
          )
      ),
        key: globalKey,
        backgroundColor: fourth,
        body: new Center(
          child: new ListView(
            children: <Widget>[
              new Form(
                  key: _formLogin,
                  child: new Container(
                    padding: new EdgeInsets.only(left: 30.0, top: 20.0,right: 30.0),
                    child: new Column(
                      children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                                color: fourth,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(143, 148, 251, .2),
                                      blurRadius: 20.0,
                                      offset: Offset(0, 10)
                                  )
                                ]
                            ),
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[100]))
                                  ),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Email Tidak Boleh Kosong";
                                      }
                                      return null;
                                    },
                                    controller: controllerusername,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "E-Mail",
                                        hintStyle: TextStyle(color: Colors.grey[400])
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[100]))
                                  ),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Nama Tidak Boleh Kosong";
                                      }
                                      return null;
                                    },
                                    controller: controllernama,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Nama",
                                        hintStyle: TextStyle(color: Colors.grey[400])
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[100]))
                                  ),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Alamat Tidak Boleh Kosong";
                                      }
                                      return null;
                                    },
                                    controller: controlleralamat,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Alamat",
                                        hintStyle: TextStyle(color: Colors.grey[400])
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[100]))
                                  ),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "No Telp Tidak Boleh Kosong";
                                      }
                                      return null;
                                    },
                                    controller: controllernotelp,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Nomor Telephone",
                                        hintStyle: TextStyle(color: Colors.grey[400])
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[100]))
                                  ),
                                  child: TextFormField(
                                    obscureText: true,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Password Tidak Boleh Kosong";
                                      }
                                      return null;
                                    },
                                    controller: controllerpassword,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Passowrd",
                                        hintStyle: TextStyle(color: Colors.grey[400])
                                    ),
                                  ),
                                )
                              ],
                            )
                        ),
                        SizedBox(height: 30,),
                        GestureDetector(
                          onTap: () {
                            if (_formLogin.currentState.validate()) {
                              _login();
                            }
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                    colors: [
                                      Color.fromRGBO(143, 148, 251, 1),
                                      Color.fromRGBO(143, 148, 251, .6),
                                    ]
                                )
                            ),
                            child: Center(
                              child: Text("Register", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                new MaterialPageRoute(
                                    builder: (BuildContext context) => new Login()));
                          },
                          child: Text("Back", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 20),)
                      ],
                    ),
                  )
              )
            ],
          ),
        )
    );
  }
}
