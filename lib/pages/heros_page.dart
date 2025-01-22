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
      backgroundColor: Color.fromARGB(255, 254, 204, 204),
      appBar: AppBar(
        title: const Text('Heroes Page'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,),
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
                  tilePadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                  title: Row(
                    children: [
                      Image(
                        image: NetworkImage(hero.portrait),
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child; //image loaded
                          return const CircularProgressIndicator(); //loading icon
                        },
                        errorBuilder: (context, error, StackTrace) {
                          print("Failed to load image $error");
                          return const Icon(Icons.error); //fallback icon
                        },
                      ),
                      const SizedBox(width: 10),
                      Text(hero.name), //hero name
                    ],
                    ),
                  onExpansionChanged: (isExpanded) {
                    if (isExpanded && !_detailsCache.containsKey(hero.name)) {
                      //fetch details only if not cached
                      setState(() {
                        _detailsCache[hero.name] = fetchHeroDetails(hero.characterkey);
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
                          child: Text("Details: ${details.description}\nage: ${details.age}\nbirthday: ${details.birthday}\nlocation: ${details.location}\nrole: ${details.role}\nhitpoints: ${details.hitpoints}\nabilities: ${details.abilities}", style: const TextStyle(fontSize: 16),
                          ),
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
  final String characterkey;
  final String name;
  final String portrait;

  const Hero({
    required this.name,
    required this.portrait,
    required this.characterkey,
  });

  factory Hero.fromJson(Map<String,dynamic>json){
    return Hero(
      characterkey: json['key'],
      name: json['name'],
      portrait: json['portrait']
    );

  }
}

class HeroDetails {
  final String description;
  final int age;
  final String birthday;
  final String location;
  final String role;
  final Map hitpoints;
  final List<Map<String, dynamic>> abilities;
  final Map story;

  HeroDetails({
    required this.description,  
    required this.role, 
    required this.location, 
    required this.age, 
    required this.birthday,
    required this.hitpoints,
    required this.abilities,
    required this.story,
    });
    factory HeroDetails.fromJson(Map<String,dynamic>json){
      //removing icon from each ability
      List<Map<String, dynamic>> processedAbilities = (json['abilities'] as List<dynamic>).map((ability){
        //create copy of ability dictonary without icon
        Map<String, dynamic> abilityMap = Map<String, dynamic>.from(ability);
        abilityMap.remove('icon');
        abilityMap.remove('video');
        return abilityMap;
      }
      ).toList();

      return HeroDetails(
        description: json['description'],  
        role: json['role'], 
        location: json['location'], 
        age: json['age'], 
        birthday: json['birthday'],
        hitpoints: json['hitpoints'],
        abilities: processedAbilities,
        story: json['story']
        );
        
    }
}