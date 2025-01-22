import 'package:flutter/material.dart';

class Player_Page extends StatefulWidget{
  const Player_Page({Key? key}) : super(key:key);
  @override
  State<Player_Page> createState() => _Player_PageState();
}

class _Player_PageState extends State<Player_Page> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Player info')),
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
