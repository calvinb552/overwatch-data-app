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
class heros_page extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('Hero stats')),
      body: Center(child: Text('get hero stats here!'),)
    );
  }
}