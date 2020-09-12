import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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


class MenuPage extends StatefulWidget {
  MenuPage({Key key}) : super(key: key);

  @override
  _myMenuPageState createState() => _myMenuPageState();
}

class _myMenuPageState extends State<MenuPage>{
  Future futureAlbumList;
  Future<Album> FutureAlbum;

  @override
  void initState()  {
    super.initState();
    futureAlbumList = fetchAlbumList();
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
            future: futureAlbumList,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.separated(
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: Colors.grey,
                      );
                    },
                    itemCount: snapshot.data.length,
                    itemBuilder: (context,index){
                      Album album = snapshot.data[index];
                      return Text(album.title);
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