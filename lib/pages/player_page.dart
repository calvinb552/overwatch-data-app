import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http;



class Player_Page extends StatefulWidget{
  const Player_Page({Key? key}) : super(key:key);
  @override
  State<Player_Page> createState() => _Player_PageState();
}

class _Player_PageState extends State<Player_Page> {
  TextEditingController _controller = TextEditingController();
  String _playerName = '';
  String _playerStats = '';

  Future<PlayerSummary> fetchPlayerSummary() async {
  final username = _controller.text.trim(); // Ensure no leading/trailing spaces

  if (username.isEmpty) {
    setState(() {
      _playerStats = 'Please enter a username or player ID';
    });
    throw Exception('Username cannot be empty');
  }

  final url = 'https://overfast-api.tekrop.fr/players/$username/summary';
  print('Making API call to: $url');
  
  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print('Successful API call');
      
      // Parse the response body as a JSON object
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      
      // Create and return a PlayerSummary object
      return PlayerSummary.fromJson(jsonData);
    } else {
      throw Exception('Failed to fetch player profile: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
    rethrow;
  }
}


  @override

  late Future<PlayerSummary> _playerSummary;

  void initState() {
    super.initState();
    _playerSummary = fetchPlayerSummary() as Future<PlayerSummary>;
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Player info'),
        backgroundColor: const Color.fromARGB(255, 185, 172, 52),
        ),
      body: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Enter Player Username',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: fetchPlayerSummary, 
                    icon: const Icon(Icons.search))
                ),
                onSubmitted: (_) => fetchPlayerSummary(), //trigger when enter is clicked
              ),
              const SizedBox(height: 20),
                Text(_playerStats),  
       FutureBuilder(
        future: _playerSummary, 
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }else if (snapshot.hasError){
            return Center(child: Text('Error ${snapshot.error}'),);
          }else if (!snapshot.hasData){
            return const Center(child: Text('no info availible'),);
          }
          final Summary = snapshot.data!;
          return Column(
            children: [
              Text('Username: ${Summary.username}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Title: ${Summary.title}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Endorsement Level: ${Summary.endorsement}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Last Updated: ${Summary.lastUpdatedAt}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Competitive (PC): ${Summary.competitive.pc.toString()}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Competitive (Console): ${Summary.competitive.console.toString()}', style: const TextStyle(fontSize: 16)),
            ]
          );
        },
        ) 
        ],
      ),  
    );
  }
}

class PlayerSummary {
  final String username;
  final String avatar;
  final String namecard;
  final String title;
  final Endorsement endorsement;
  final Competitive competitive;
  final int lastUpdatedAt;

  PlayerSummary({
    required this.username,
    required this.avatar,
    required this.namecard,
    required this.title,
    required this.endorsement,
    required this.competitive,
    required this.lastUpdatedAt,
  });

  // Factory constructor to create an instance from JSON
  factory PlayerSummary.fromJson(Map<String, dynamic> json) {
    return PlayerSummary(
      username: json['username'],
      avatar: json['avatar'],
      namecard: json['namecard'],
      title: json['title'],
      endorsement: Endorsement.fromJson(json['endorsement']),
      competitive: Competitive.fromJson(json['competitive']),
      lastUpdatedAt: json['last_updated_at'],
    );
  }
}

// Model for Endorsement
class Endorsement {
  final int level;
  final String frame;

  Endorsement({
    required this.level,
    required this.frame,
  });

  factory Endorsement.fromJson(Map<String, dynamic> json) {
    return Endorsement(
      level: json['level'],
      frame: json['frame'],
    );
  }
}

// Model for Competitive (handles both PC and console data)
class Competitive {
  final Map<String, dynamic> pc;
  final Map<String, dynamic> console;

  Competitive({
    required this.pc,
    required this.console,
  });

  factory Competitive.fromJson(Map<String, dynamic> json) {
    return Competitive(
      pc: json['pc'] ?? {},
      console: json['console'] ?? {},
    );
  }
}




