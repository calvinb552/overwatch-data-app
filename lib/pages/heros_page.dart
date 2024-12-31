import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http;

Future<http.Response> hero_list() {
  return http.get(Uri.parse('https://overfast-api.tekrop.fr/heroes'));
}
Future<http.Response> hero_data(hero) {
  return http.get(Uri.parse('https://overfast-api.tekrop.fr/heroes/'+hero));
}
Future<http.Response> roles_info() {
  return http.get(Uri.parse('https://overfast-api.tekrop.fr/roles'));
}

class Heroes_Page extends StatefulWidget{
  const Heroes_Page({Key? key}) : super(key:key);
  @override
  State<Heroes_Page> createState() => _Heroes_PageState();
}
class _Heroes_PageState extends State<Heroes_Page> {
  bool _customIcon = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Heroes Page')),
      body: Column(
        children: <Widget>[
          ExpansionTile(
            title: const Text('test'),
            trailing: Icon(
              _customIcon ? Icons.arrow_drop_down_circle : Icons.arrow_drop_down,
            ),
            children: const <Widget>[
              ListTile(
                title: Text('test number 2'),
              ),
            ],
            onExpansionChanged: (bool expanded) {
              setState(() => _customIcon = expanded);
            },
          ),
        ],
      ),
    );
  }
}