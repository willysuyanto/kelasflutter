import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_course/models/BeritaArguments.dart';
import 'package:http/http.dart' as http;
import 'models/Berita.dart';

class Album {
  final int userId;
  final int id;
  final String title;

  Album({this.userId, this.id, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

//membuat custom widget
class TampilanKartu extends StatelessWidget{
  TampilanKartu({Key key, this.id,this.userId,this.title}): super(key: key);

  final String id;
  final String userId;
  final String title;

  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.all(2.0),
      height: 100,
      child: Card(
        child: Column(
          children: <Widget>[
            Text("ID : $id"),
            Text("User ID : $userId"),
            Text("Title : $title")
          ],
        ),
      ),
    );
  }
}

class WidgetBerita extends StatelessWidget{
  WidgetBerita({Key key,this.title,this.urlToImage,this.url}): super(key: key);
  final String title;
  final String urlToImage;
  final String url;

  Widget build(BuildContext context){
    return Container(
      width: 200,
      child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/lihatberita', arguments: BeritaArguments(title, url));
          },
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              FittedBox(
                child:  Image.network(urlToImage==null?"":urlToImage),
                fit: BoxFit.fill,
              ),
              Text("Title : $title")
            ],
          ),
        ),
      ),
    );
  }
}



Future<Album> fetchAlbum() async {
  final response = await http.get('https://jsonplaceholder.typicode.com/albums/2');
  if (response.statusCode == 200) {
    return Album.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

Future<List<Album>> fetchAlbumList() async {

  final response = await http.get('https://jsonplaceholder.typicode.com/albums/');

  if (response.statusCode == 200) {
    var parsedAlbum = json.decode(response.body);

    List<Album> albums = List<Album>();

    parsedAlbum.forEach((album){
      albums.add(Album.fromJson(album));
    });

    return albums;

  } else {
    throw Exception('Failed to load album');
  }
}

Future<Berita> fetchBerita(String countryID) async {
  final response = await http.get("https://newsapi.org/v2/top-headlines?country=$countryID&apiKey=b8a8521877174653b7f0a611d3cd753f");
  if (response.statusCode == 200) {
    var parsedData = json.decode(response.body);
    return Berita.fromJson(parsedData);
  } else {
    throw Exception('Failed to load news');
  }
}


class MenuPage extends StatefulWidget {
  MenuPage({Key key}) : super(key: key);

  @override
  _myMenuPageState createState() => _myMenuPageState();
}

class _myMenuPageState extends State<MenuPage>{
  String countryID = "id";
  Future futureAlbumList;
  Future<Berita> futureBerita;
  Future<Album> FutureAlbum;

  @override
  void initState()  {
    super.initState();
    futureAlbumList = fetchAlbumList();
    futureBerita = fetchBerita(countryID);
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Halaman Menu"
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: FutureBuilder(
            future: futureBerita,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data.articles.length,
                    itemBuilder: (context,index){
                      Articles artikel = snapshot.data.articles[index];
                      return WidgetBerita(title: artikel.title,urlToImage: artikel.urlToImage,url:artikel.url);
                    }
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}