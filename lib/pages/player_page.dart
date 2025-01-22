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

  Future<void> _searchPlayer() async {
    final username = _controller.text;

    if (username.isEmpty) {
      setState(() {
        _playerStats = 'Please enter a username or player ID';
        return;
      });
    }

    final url = 'https://overfast-api.tekrop.fr/players/$username';
    print('making api call to: $url');
    
    try{
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('retriving data');
        print('data: $data');
        setState(() {
          _playerName = username;
          _playerStats = data;
        });
      } else {
        setState(() {
          _playerStats = "Error: could not retrive stats";
          print('could not retrive stats');
        });
      }
    } catch (e) {
      setState(() {
        print('failed to make request');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Player info'),
        backgroundColor: const Color.fromARGB(255, 185, 172, 52),
        ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter Player Username',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: _searchPlayer, 
                  icon: const Icon(Icons.search))
              ),
              onSubmitted: (_) => _searchPlayer(), //trigger when enter is clicked
            ),
            const SizedBox(height: 20),
              Text(_playerStats),
          ],
        ),
      ),
    );
  }
}



