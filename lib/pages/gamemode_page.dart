import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http;

Map<String, String> Gamemode_images = {
    "assault":"https://static.wikia.nocookie.net/overwatch_gamepedia/images/e/e0/Assault.png/revision/latest/scale-to-width-down/256?cb=20230516191316",
    "capture-the-flag":"",
    "clash":"",
    "control":"",
    "deathmatch":"",
    "elimination":"",
    "escort":"",
    "flashpoint": "",
    "hybrid":"",
    "push": "",
    "team-deathmatch":""

  };

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
  late Future<List<gamemodes>> _gamemodesFuture;
  Map<String, Future<gamemodes>> _gamemodeCache = {};


  @override
  void initState() {
    super.initState();
    _gamemodesFuture = fetchGamemodes();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gamemode info'),
        backgroundColor: Colors.green,),
      body: FutureBuilder<List<gamemodes>>(
        future: _gamemodesFuture, 
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          } else if (snapshot.hasError){
            return Center(child: Text("error: ${snapshot.error}"),);
          } else if (snapshot.hasData){
            final gamemode = snapshot.data!;
            return ListView.builder(
              itemCount: gamemode.length,
              itemBuilder: (context, index) {
                final item = gamemode[index];

                print('Loading image for ${item.name}: ${item.icon}');
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context, 
                          builder: (_) => AlertDialog(
                            title: Text(item.name),
                            content: Text(item.description),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context), 
                                child: const Text('close'))
                            ],
                          ));
                      },
                      child: Column(
                        children: [
                          //icon
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.greenAccent,
                            ),
                            child: Container(
                              color: Colors.red,
                              width: 60,
                              height: 60,
                              child: 
                            Image.network(
                              item.icon,
                              width: 50,
                              height: 50,
                              errorBuilder: (context, error, StackTrace){
                                return Image.network("https://e7.pngegg.com/pngimages/10/205/png-clipart-computer-icons-error-information-error-angle-triangle-thumbnail.png");
                              },
                            ),
                            ),
                          ),
                          if (index != gamemode.length - 1)
                            Container(
                              width: 2,
                              height: 50,
                              color: Colors.greenAccent,
                            )
                        ],
                      ),
                    )
                  ],
                );
                
              }
            );
          }else{
            throw('error');
          }
        })
    );
  }
}


class gamemodes {

  final String gamekey;
  final String name;
  final String icon;
  final String description;
  final String screenshot;

  gamemodes({
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
      icon: Gamemode_images[json["key"]] ?? "https://e7.pngegg.com/pngimages/10/205/png-clipart-computer-icons-error-information-error-angle-triangle-thumbnail.png", 
      description: json['description'], 
      screenshot: json['screenshot']);
  }
}
