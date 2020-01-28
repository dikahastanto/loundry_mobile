import 'package:flutter/material.dart';
import 'package:flutter_app/Settings.dart';
import 'package:transparent_image/transparent_image.dart';

class DetailPromosi extends StatelessWidget {
  DetailPromosi({this.list,this.index});
  List list;
  int index;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: fourth,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0.0,
        title: new Text('Detail', style: new TextStyle(
            color: textColor, fontWeight: FontWeight.bold
        ),
        ),
      ),
      body: new ListView(
        children: <Widget>[

//          new Image.network(masterurl+"/img/"+list[index]['gambar']),

          new Padding(padding: new EdgeInsets.only(top: 5.0)),

          new Container(
            padding: new EdgeInsets.all(10.0),
            child: new Card(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    padding: new EdgeInsets.only(left:20.0,right: 20.0,top: 20.0),
                    child: new FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: masterurl + "img/produk/" + list[index]['gambar']
                    ),
                  ),

                  new Container(
                    padding: new EdgeInsets.only(left:20.0,right: 20.0,top: 20.0),
                    child: new Text(
                      list[index]['nama'],
                      style: new TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: textColor
                      )
                    ),
                  ),

                  new Container(
                      padding: new EdgeInsets.only(left: 20.0,right: 20.0,top: 20.0),
                      child: new Row(
                        children: <Widget>[
                          new Text(
                            'Rp.' + list[index]['harga'].toString() + ',-',
                            style: new TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.w400,
                                color: textColor
                            )
                          ),
                        ],
                      )
                  ),

                  new Container(
                    padding: new EdgeInsets.only(left: 20.0,right: 20.0,top: 20.0,bottom: 20.0),
                    child: new Text(list[index]['isi'],style: new TextStyle(fontSize: 20.0, color: textColor),),
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

