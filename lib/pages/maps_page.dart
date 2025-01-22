import 'package:flutter/material.dart';

class Maps_Page extends StatefulWidget{
  const Maps_Page({Key? key}) : super(key:key);
  @override
  State<Maps_Page> createState() => _Maps_PageState();
}

class _Maps_PageState extends State<Maps_Page> {
  bool _showImage = true;
  

  void _toggleView() async {
    await Future.delayed(const Duration(milliseconds: 200)); //wait for ripple affect to start
    setState(() {
      _showImage = !_showImage; //switch image on and off
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 112, 108, 168),
      appBar: AppBar(
        title: Text('Map info'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 51, 51, 190),),
      body: Center(
        child: Material(
        color: Colors.blue,
        elevation: 8,
        borderRadius: BorderRadius.circular(28),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child:
          InkWell(
            splashColor: Colors.blueAccent,
            onTap: () {
              _toggleView();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [ 
              SizedBox(
                height: 400,
                width: 400,
                child: 
              _showImage 
              ?Ink.image(
              image: const NetworkImage('https://overfast-api.tekrop.fr/static/maps/necropolis.jpg'),
              height: 400,
              width: 400,
              fit: BoxFit.cover,
              )
              :const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('info goes here',
                style: TextStyle(fontSize: 16),),)),
              const SizedBox(height: 6),
              const Text('Map Name',
              style: TextStyle(fontSize: 32),)
            ]
          )
          )
      ),
    )
    );
  }
}




