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
      appBar: AppBar(title: Text('Map info')),
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