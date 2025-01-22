import 'package:flutter/material.dart';

class Maps_Page extends StatefulWidget{
  const Maps_Page({Key? key}) : super(key:key);
  @override
  State<Maps_Page> createState() => _Maps_PageState();
}

class _Maps_PageState extends State<Maps_Page> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 112, 108, 168),
      appBar: AppBar(
        title: Text('Map info'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 51, 51, 190),),
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            splashColor: Colors.blueAccent,
            onTap: () {},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [ 
            Ink.image(
              image: const NetworkImage('https://overfast-api.tekrop.fr/static/maps/necropolis.jpg'),
              height: 200,
              width: 200,
              fit: BoxFit.cover,
              ),
              SizedBox(height: 6),
              Text('Map Name',
              style: TextStyle(fontSize: 32),)
              
            ]
          )
          )
        ],
      ),
    )
    );
  }
}