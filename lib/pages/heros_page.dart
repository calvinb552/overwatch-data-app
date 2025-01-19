import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http;

//create api function
Future<Album> fetchHeroes() async{
  final response = await http.get(Uri.parse('https://overfast-api.tekrop.fr/heroes'));

  //check if it is a returned response
  if(response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  }else{
    throw Exception("failed to load api");
  }
}

class Heroes_Page extends StatefulWidget{
  const Heroes_Page({Key? key}) : super(key:key);
  @override
  State<Heroes_Page> createState() => _Heroes_PageState();
}
class _Heroes_PageState extends State<Heroes_Page> {
bool _customIcon = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    home:Scaffold(
      appBar: AppBar(title: const Text('Heroes Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            fetchHeroes().then((value){
              print(value.name[0]);
            });
          },
          child: const Text('api Test'),
          )  
      ),
    ),
    );
  }
}

//create model class

class Album {
  final String name;

  const Album({
    required this.name,
  });

  factory Album.fromJson(Map<String,dynamic>json){
    return Album(
      name: json['name'],
    );

  }
}