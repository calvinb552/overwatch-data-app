import 'package:flutter/material.dart';
import 'package:overwatch_stats/pages/heros_page.dart';
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
      appBar: AppBar(title: const Text('overwatch stats'),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => heros_page()));
            },
             
            child: const Text('Heros')),
          ElevatedButton(onPressed: () {

            },
             
            child: const Text('Players')),
          ElevatedButton(onPressed: () {

            },
             
            child: const Text('Maps')),
          ElevatedButton(onPressed: () {

            },
             
            child: const Text('gamemodes')),
          ],
        )

        ),
      );
  }
}




