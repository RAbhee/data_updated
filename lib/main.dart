import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(MyApp());
}

//Fetch Data
Future<Album> fetchAlbum() async{
  final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users/1'))

  ;
  if (response.statusCode == 200){
    return Album.fromJson(jsonDecode(response.body));
  }else {
    throw Exception('Failed to load album');
  }


}
//request to update data
Future<Album> updateAlbum(String title) async {
  final response = await http.put(Uri.parse('https://jsonplaceholder.typicode.com/users/1'),

      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },

      body: jsonEncode(<String, String>{'title': title}));

  if (response.statusCode == 200){
    return Album.fromJson(jsonDecode(response.body));
  }else {
    throw Exception('Failed to update album');
  }
}

//Album Object to convert the json data to object and display to user
class Album{

  final String name;
  final String username;
  final String email;

  Album ({required this.name,
    required this.username,
    required this.email,
  });

  factory Album.fromJson(Map<String, dynamic>json){
    return Album(name: json['name'],username: json['username'],email: json['email']);
  }

}

//Display the data and update the data

class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MyAppState(

  );

}

class _MyAppState extends State<MyApp>{

  TextEditingController _controller = TextEditingController();
  late Future<Album> _futureAlbum;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _futureAlbum = fetchAlbum();
  }


  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(

        appBar: AppBar(
          title: Text('Update Data'),
        ),
        body:
        Center(
          child: FutureBuilder<Album>(
            future: _futureAlbum,
            builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.done){
                if (snapshot.hasData){
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(snapshot.data!.name),
                      Text(snapshot.data!.username),
                      Text(snapshot.data!.email),
                      TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                            hintText: "Enter Name"
                        ),
                      ),
                      TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                            hintText: "Enter User Name"
                        ),
                      ),
                      TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                            hintText: "Enter email"
                        ),
                      ),

                      ElevatedButton(onPressed: (){
                        setState(() {
                          _futureAlbum = updateAlbum(_controller.text);
                        });
                      },
                          child: Text('update Data'))
                    ],

                  );
                } else if(snapshot.hasError){
                  return Text('${snapshot.error}');
                }
              }

              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );

  }
}