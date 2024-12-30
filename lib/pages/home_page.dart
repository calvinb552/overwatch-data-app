import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
      page = Placeholder();
      break;
    case 1:
      page = Placeholder();
      break;
    case 2:
      page = Placeholder();
      break;
    case 3:
      page = Placeholder();
      break;
    default:
      throw UnimplementedError('no widget for $selectedIndex')
    }

    return Scaffold(
      appBar: AppBar(title: const Text('overwatch stats'),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () {

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
