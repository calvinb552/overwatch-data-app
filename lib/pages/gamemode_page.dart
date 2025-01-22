import 'package:flutter/material.dart';

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
