import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http;

//create api function
Future<List<Hero>> fetchHeroes() async{
  final response = await http.get(Uri.parse('https://overfast-api.tekrop.fr/heroes'));

  //check if it is a returned response
  if(response.statusCode == 200) {
    List<dynamic> hero_list = jsonDecode(response.body);
    return hero_list.map((json) => Hero.fromJson(json)).toList();
  }else{
    throw Exception("failed to load api");
  }
}

Future<HeroDetails> fetchHeroDetails(herokey) async{
  final response = await http.get(Uri.parse('https://overfast-api.tekrop.fr/heroes/${herokey}'));

  if(response.statusCode == 200) {
    return HeroDetails.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("failed to load hero details");
  }
}

class Heroes_Page extends StatefulWidget{
  const Heroes_Page({Key? key}) : super(key:key);
  @override
  State<Heroes_Page> createState() => _Heroes_PageState();
}
class _Heroes_PageState extends State<Heroes_Page> {
  late Future<List<Hero>> _heroesFuture;
  Map<String, Future<HeroDetails>> _detailsCache = {}; //cache to avoid duplicate API calls


  @override
  void initState() {
    super.initState();
    _heroesFuture = fetchHeroes() as Future<List<Hero>>; //get heros on widget initialization
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Heroes Page')),
      body: FutureBuilder<List<Hero>>(
        future: _heroesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError){
            return Center(child: Text("error: ${snapshot.error}"));
          }else if (snapshot.hasData){
            final heroes = snapshot.data!;
            return ListView.builder(
              itemCount: heroes.length,
              itemBuilder: (context, index) {
                final hero = heroes[index];
                return ExpansionTile(
                  title: Text(hero.name),
                  onExpansionChanged: (isExpanded) {
                    if (isExpanded && !_detailsCache.containsKey(hero.name)) {
                      //fetch details only if not cached
                      setState(() {
                        _detailsCache[hero.name] = fetchHeroDetails(hero.name.toLowerCase());
                      });
                    }
                  },
                  children: [
                    FutureBuilder<HeroDetails>(
                      future: _detailsCache[hero.name], 
                      builder: (context, snapshot){
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                            );
                        }else if (snapshot.hasError){
                          return Padding(padding: const EdgeInsets.all(8.0),
                          child: Text("error loading hero details: ${snapshot.error}"),
                          );
                        }else if (snapshot.hasData){
                          final details = snapshot.data!;
                          return Padding(padding: const EdgeInsets.all(8.0),
                          child: Text(details.description),
                          );
                        } else {
                          return const Padding(padding: EdgeInsets.all(8.0),
                          child: Text("no details available."),
                          );
                        }
                      })
                  ],
                );
              });
          }else{
            return const Center(child: Text('an error has occured please try again later'));
          }
        }

      ),

    );
  }
}

//create model class

class Hero {
  final String name;

  const Hero({
    required this.name,
  });

  factory Hero.fromJson(Map<String,dynamic>json){
    return Hero(
      name: json['name'],
    );

  }
}

class HeroDetails {
  final String description;
  final String portrait;
  final int age;
  final String birthday;
  final String location;
  final String role;

  HeroDetails({
    required this.description, 
    required this.portrait, 
    required this.role, 
    required this.location, 
    required this.age, 
    required this.birthday
    });
    factory HeroDetails.fromJson(Map<String,dynamic>json){
      return HeroDetails(
        description: json['description'], 
        portrait: json['portrait'], 
        role: json['role'], 
        location: json['location'], 
        age: json['age'], 
        birthday: json['birthday']);
    }
}