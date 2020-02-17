import 'package:flutter/material.dart';
import 'package:flutter_app/Settings.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/owner/DetailPromosi.dart';
import 'package:flutter_app/Login.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Future<List> getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var url = masterurl + "produk/getuserporduk/" + sharedPreferences.get('id');
    final respon = await http.get(url);
//    print(json.decode(respon.body));
    return json.decode(respon.body);

  }

  String namaLengkap = '', alamat = '-', noRek = '', namaBank = '', atasNama = '',
          noTelp = '';
  double _totalRating = 0.0;
  void getProfile () async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      namaLengkap = sharedPreferences.getString('namaLengkap');
      alamat = sharedPreferences.getString('alamat');
      noRek = sharedPreferences.getString('noRek');
      namaBank = sharedPreferences.getString('namaBank');
      atasNama = sharedPreferences.getString('atasNama');
      noTelp = sharedPreferences.getString('noTelp');
      _totalRating = double.parse(sharedPreferences.getString('rating'));

      emailController.text = sharedPreferences.getString('email');
      namaLengkapController.text = namaLengkap;
      alamatController.text = alamat;
      noTelpController.text = noTelp;
      noRekController.text = noRek;
      namaBankController.text = namaBank;
      atasNamaController.text = atasNama;
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

  final _changePasswordKey = GlobalKey<FormState>();
  TextEditingController passwordOldController = new TextEditingController();
  TextEditingController passwordNewController = new TextEditingController();
  TextEditingController passwordRepeatController = new TextEditingController();
  _displayChangePassword (BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return ListView(
            shrinkWrap: true,
            children: <Widget>[
              Form(
                key: _changePasswordKey,
                child: AlertDialog(
                  elevation: 0.0,
                  title: Text('Ganti password'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Mohon Isi Password Baru";
                          }
                          return null;
                        },
                        controller: passwordOldController,
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: "Password Lama Anda",
                            labelText: "Password Lama Anda"
                        ),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Mohon Isi Password Lama";
                          }
                          return null;
                        },
                        controller: passwordNewController,
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: "Password Baru",
                            labelText: "Password Baru"
                        ),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Ketik Ulang Password Dengan Benar";
                          } else if (value != passwordNewController.text) {
                            return 'Ketik Ulang Password Dengan Benar';
                          }
                          return null;
                        },
                        controller: passwordRepeatController,
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: "Ketik Ulang Password Baru",
                            labelText: "Ketik Ulang Password Baru"
                        ),
                      )
                    ],
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text('Batal'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    new FlatButton(
                      child: new Text('Update Data'),
                      onPressed: () {
                        if (_changePasswordKey.currentState.validate()) {
                          changePassword();
                        }
                      },
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

  void changePassword () async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var url = masterurl + 'changepassword/' + sharedPreferences.getString('id');

    final response = await http.post(url, body: {
      "oldPassword": passwordOldController.text,
      "newPassword": passwordNewController.text,
    });

    setState(() {
      passwordNewController.text = '';
      passwordOldController.text = '';
      passwordRepeatController.text = '';


    });

    Navigator.pop(context);


    var result = json.decode(response.body);
    if (result['sukses']) {
      showSnackbar(context, result['msg'], suksesColor);
    } else {
      showSnackbar(context, result['msg'], dangerColor);
    }


  }

  TextEditingController emailController = new TextEditingController();
  TextEditingController namaLengkapController = new TextEditingController();
  TextEditingController alamatController = new TextEditingController();
  TextEditingController noTelpController = new TextEditingController();
  TextEditingController noRekController = new TextEditingController();
  TextEditingController namaBankController = new TextEditingController();
  TextEditingController atasNamaController = new TextEditingController();

  void updateProfile () async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var url = masterurl + 'updateprofile/' + sharedPreferences.getString('id');

    final response = await http.post(url, body: {
      "email": emailController.text,
      "namaLengkap": namaLengkapController.text,
      "alamat": alamatController.text,
      "noTelp": noTelpController.text,
    });

    Navigator.pop(context);


    var result = json.decode(response.body);
    if (result['sukses']) {
      sharedPreferences.setString("email", emailController.text);
      sharedPreferences.setString("namaLengkap", namaLengkapController.text);
      sharedPreferences.setString("alamat", alamatController.text);
      sharedPreferences.setString("noTelp", noTelpController.text);
      sharedPreferences.setString("noRek", noRekController.text);
      sharedPreferences.setString("namaBank", namaBankController.text);
      sharedPreferences.setString("atasNama", atasNamaController.text);
      this.getProfile();
      showSnackbar(context, result['msg'], suksesColor);
    } else {
      showSnackbar(context, result['msg'], dangerColor);
    }
  }

  final _updateProfileKey = GlobalKey<FormState>();
  _displayUpdateProfile (BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return ListView(
            children: <Widget>[
              Form(
                key: _updateProfileKey,
                child: AlertDialog(
                  elevation: 0.0,
                  title: Text('Ubah Profile'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Mohon Isi E-Mail";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "E-Mail",
                            labelText: "E-Mail"
                        ),
                      ),
                      TextFormField(
                        controller: namaLengkapController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Mohon Isi Nama Lengkap";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "Nama Lengkap",
                            labelText: "Nama Lengkap"
                        ),
                      ),
                      TextFormField(
                        controller: alamatController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Mohon Isi Alamat";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "Alamat",
                            labelText: "Alamat"
                        ),
                      ),
                      TextFormField(
                        controller: noTelpController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Mohon Isi No Telp";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "No Telp",
                            labelText: "No Telp"
                        ),
                      ),
                      TextFormField(
                        controller: noRekController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Mohon Isi No Rek";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "No Rek",
                            labelText: "No Rek"
                        ),
                      ),
                      TextFormField(
                        controller: namaBankController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Mohon Isi Nama Bank";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "Nama Bank",
                            labelText: "Nama Bank"
                        ),
                      ),
                      TextFormField(
                        controller: atasNamaController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Mohon Isi Atas Nama No Rek";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: "Atas Nama",
                            labelText: "Atas Nama"
                        ),
                      )
                    ],
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: new Text('Batal'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    new FlatButton(
                      child: new Text('Update Data'),
                      onPressed: () {
                        if (_updateProfileKey.currentState.validate()) {
                          updateProfile();
                        }
                      },
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

  final _globalKey = GlobalKey<ScaffoldState>();

  void showSnackbar(BuildContext context, msg, color) {
    final snackBar = SnackBar(content: Text(msg), backgroundColor: color);
    _globalKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _globalKey,
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
                    radius: 60,
                    child: Icon(Icons.perm_identity, size: 80.0)
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
                      Text(
                        noTelp,
                        style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                        ),
                      ),

                      Text(
                        noRek + ' - ' + namaBank,
                        style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      Text(
                        'An ' + atasNama,
                        style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      RatingBarIndicator(
                        rating: _totalRating,
                        itemCount: 5,
                        itemSize: 30.0,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(left: 15,right: 15),
                    child: ButtonTheme(
                        minWidth: 170.0,
                        height: 45.0,
                        child: GestureDetector(
                          onTap: () {
                            _displayUpdateProfile(context);
                          },
                          child: Container(
                            width: 170.0,
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                color: third,
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Ubah Profil',
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 15.0
                              ),
                            ),
                          ),
                        )
                    )
                ),
                Container(
                    padding: EdgeInsets.only(left: 15,right: 15),
                    child: ButtonTheme(
                        minWidth: 170.0,
                        height: 45.0,
                        child: GestureDetector(
                          onTap: () {
                            _displayChangePassword(context);
                          },
                          child: Container(
                            width: 170.0,
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                color: third,
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Ganti Password',
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 15.0
                              ),
                            ),
                          ),
                        )
                    )
                )
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 20.0)),
          Container(
              color: fourth,
              padding: EdgeInsets.only(left: 15,right: 15),
              child: ButtonTheme(
                  minWidth: 400.0,
                  height: 45.0,
                  child: GestureDetector(
                    onTap: () {
                      logout();
                      Navigator.pushReplacement(context, new MaterialPageRoute(
                          builder: (BuildContext context) => Login()
                      )
                      );
                    },
                    child: Container(
                      width: 200.0,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          color: third,
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Logout',
                        style: TextStyle(
                            color: textColor,
                            fontSize: 15.0
                        ),
                      ),
                    ),
                  )
              )
          ),
          Padding(padding: EdgeInsets.only(top: 20.0)),
          Container(
            color: fourth,
            padding: EdgeInsets.only(right: 20, left: 15, top: 20, bottom: 20),
            child: Row(
              children: <Widget>[
                Text(
                  'Promosi Anda',
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
    return new ListView.builder(
      shrinkWrap: true,
        physics: ScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: list == null ? 0 : list.length,
        itemBuilder: (context, i) {
          return new Container(
              padding: new EdgeInsets.all(5.0),
              child: new GestureDetector(
                onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context) => new DetailPromosi(list: list,index: i,),
                    ));
                },
                child: new Card(
                  elevation: 0.0,
                  child: new ListTile(
                      contentPadding: new EdgeInsets.all(10.0),
                      trailing: new Icon(Icons.arrow_forward_ios,size: 20.0,),
                      title: new Text(
                          list[i]['nama'],
                          style: TextStyle(
                            color: textColor,
                            fontSize: 20
                          ),
                      ),
//                      leading: new Image.network(masterurl+"/img/"+list[i]['gambar'],scale: 16.0,),
                      subtitle:  new Text('Rp.' + list[i]['harga'].toString() + ',-')
                  ),
                ),
              ));
        });
  }
}