import 'package:flutter/material.dart';
import 'package:flutter_app/Settings.dart';
import 'package:flutter_app/pelanggan/Home.dart' as Pelanggan;
import 'Settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_app/owner/Home.dart' as HomeOwner;
import 'package:flutter_app/Register.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  final _formLogin = GlobalKey<FormState>();
  TextEditingController controllerusername = new TextEditingController();
  TextEditingController controllerpassword = new TextEditingController();
  final globalKey = GlobalKey<ScaffoldState>();
  void showSnackbar(BuildContext context, msg, color) {
    final snackBar = SnackBar(content: Text(msg), backgroundColor: color);
    globalKey.currentState.showSnackBar(snackBar);
  }

  Future<void> _login () async {
    var url = masterurl + 'login';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    final response = await http.post(url, body: {
      "email": controllerusername.text,
      "password": controllerpassword.text
    });


    var result = json.decode(response.body);

    if (result['sukses']) {
      setState(() {
        sharedPreferences.setString("id", result['user']['id'].toString());
        sharedPreferences.setString("email", result['user']['email']);
        sharedPreferences.setString("namaLengkap", result['user']['namaLengkap']);
        sharedPreferences.setString("alamat", result['user']['alamat']);
        sharedPreferences.setString("noTelp", result['user']['noTelp']);
        sharedPreferences.setString("level", result['user']['level'].toString());
        sharedPreferences.setBool("status", true);
      });

     if (result['user']['level'] == 1) {
       sharedPreferences.setString("rating", result['user']['totalRating'].toString());
       sharedPreferences.setString("noRek", result['user']['noRek'].toString());
       sharedPreferences.setString("atasNama", result['user']['atasNama'].toString());
       sharedPreferences.setString("namaBank", result['user']['namaBank'].toString());
       Navigator.pushReplacement(
           context,
           new MaterialPageRoute(
               builder: (BuildContext context) => new HomeOwner.HomeOwner()));
     } else {
       Navigator.pushReplacement(
           context,
           new MaterialPageRoute(
               builder: (BuildContext context) => new Pelanggan.Home()));
     }

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
      key: globalKey,
      backgroundColor: fourth,
      body: new Center(
        child: new ListView(
          children: <Widget>[
            new Form(
                key: _formLogin,
                child: new Container(
                  padding: new EdgeInsets.only(left: 30.0, right: 30.0),
                  child: new Column(
                    children: <Widget>[
                      new Image.asset('img/bg.png'),
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
                            child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              new MaterialPageRoute(
                                  builder: (BuildContext context) => new Register()));
                        },
                        child: Text("Register", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),),
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
