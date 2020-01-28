import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

var masterurl = "http://192.168.1.12:8000/";
final appbarcolor = Colors.lightBlue[900];
final bgapp = Colors.grey[300];
final primary = Color(0xff16a0e2);
final secondary = Color(0xff195a79);
final third = Color(0xffededed);
final fourth = Color(0xffffffff);
final textColor = Color(0xff34495e);

final dangerColor = Color(0xffe74c3c);
final suksesColor = Color(0xff27ae60);

void logout() async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.clear();
}

//final globalKey = GlobalKey<ScaffoldState>();

//void showSnackbar(BuildContext context) {
//  final snackBar = SnackBar(content: Text('Profile saved'));
//  globalKey.currentState.showSnackBar(snackBar);
//}