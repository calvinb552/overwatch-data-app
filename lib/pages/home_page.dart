import 'package:flutter/material.dart';
import 'package:overwatch_stats/pages/heros_page.dart';
import 'package:overwatch_stats/pages/maps_page.dart';
import 'package:overwatch_stats/pages/player_page.dart';
import 'package:overwatch_stats/pages/gamemode_page.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('overwatch stats'),
        centerTitle: true,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
            padding: const EdgeInsets.all(8.0), // Padding around the button
            child: ElevatedButton(
              onPressed: () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Heroes_Page()));
              },
              child: const Text('Heroes'),
            ),
          ),
          Padding(padding: EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: () {
            Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Player_Page()));
          },
            child: const Text('Players'))),
          Padding(padding: EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Maps_Page()));
          },
            child: const Text('Maps'))),
          Padding(padding: EdgeInsets.all(8.0),
            child: ElevatedButton(onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Gamemode_Page()));
          },
            child: const Text('Gamemodes'))),
          ],
        )

        ),
      );
  }
}




