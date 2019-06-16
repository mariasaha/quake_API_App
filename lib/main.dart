import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


Map _data;
List _features;
void main() async {
  _data = await getQuakes();
  //print(_data['features'][0]['properties']['place']);
  _features = _data['features'];

  // var usrMap = {"name": "Tom", 'Email': 'tom@xyz.com'};
  //   usrMap.forEach((k,v) => print('${k}: ${v}'));

  runApp(new MaterialApp(
    title: 'Quakes',
    home: new Quakes(),
  ));
}

class Quakes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title:  new Text('Quakes'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: new Center(
        child: new ListView.builder(
          itemCount: _features.length,
          padding: const EdgeInsets.all(15.0),

          itemBuilder: (BuildContext context, int position){
            //rows for listview
            if(position.isOdd) return new Divider();
            final index = position ~/ 2; //dividing pos by 2 returning an int

            var format = new DateFormat("yMMMd").add_jm();

            var date = format.format(new DateTime.fromMicrosecondsSinceEpoch(_features[index]['properties']['time']* 1000
            , isUtc: true));

            return new ListTile(
              title: new Text ("At: $date",
              style: new TextStyle(fontSize: 15.5,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold),),

              subtitle:  new Text("Place: ${_features[index]['properties']['place']}",
              style: new TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
                fontStyle: FontStyle.italic
              ),),
              leading: new CircleAvatar(
                backgroundColor: Colors.green,
                child: new Text("${_features[index]['properties']['mag']}",
                  style: new TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontStyle: FontStyle.normal
                  ),),
              ),
              onTap: () { _showAlertMessage(context, "${_features[index]['properties']['title']}");}
            );
          }),
      ),
    );
  }
}

void _showAlertMessage(BuildContext context, String message){
  var alert = new AlertDialog(
    title: new Text('Quakes'),
    content: new Text(message),
    actions: <Widget>[
      new FlatButton(onPressed: (){Navigator.pop(context);},
  child: new Text("OK")),
    ],
  );
  showDialog(context: context, builder: (_) => alert);

}

Future<Map> getQuakes() async {
  String apiURL = 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson';
  http.Response response = await http.get(apiURL);

  return json.decode(response.body);
}