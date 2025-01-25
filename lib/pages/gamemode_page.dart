import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http;

Future<List<gamemodes>> fetchGamemodes() async{
  final response = await http.get(Uri.parse('https://overfast-api.tekrop.fr/gamemodes'));

  if(response.statusCode == 200) {
    List<dynamic> gamemode_list = jsonDecode(response.body);
    return gamemode_list.map((json) => gamemodes.fromJson(json)).toList();
  }else{
    throw Exception('failed to load api');
  }
}
class Gamemode_Page extends StatefulWidget{
  const Gamemode_Page({Key? key}) : super(key:key);
  @override
  State<Gamemode_Page> createState() => _Gamemode_PageState();
}

class _Gamemode_PageState extends State<Gamemode_Page> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gamemode info'),
        backgroundColor: Colors.green,),
      body: const Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('implement info here')
        ],
      ),
    )
    );
  }
}


class gamemodes {
  final String gamekey;
  final String name;
  final String icon;
  final String description;
  final String screenshot;

  const gamemodes({
    required this.gamekey,
    required this.name,
    required this.icon,
    required this.description,
    required this.screenshot,
  });

  factory gamemodes.fromJson(Map<String,dynamic>json){
    return gamemodes(
      gamekey: json['key'], 
      name: json['name'], 
      icon: json['icon'], 
      description: json['description'], 
      screenshot: json['screenshot']);
  }
}
