import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http;

Future<List<mapInfo>> fetchMaps() async{
  final response = await http.get(Uri.parse('https://overfast-api.tekrop.fr/maps'));

  if(response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData.map((map) => mapInfo.fromJson(map)).toList();
  } else {
    throw Exception("failed to load map details");
  }
}

class Maps_Page extends StatefulWidget{
  const Maps_Page({Key? key}) : super(key:key);
  @override
  State<Maps_Page> createState() => _Maps_PageState();
}

class _Maps_PageState extends State<Maps_Page> {
  late Future<List<mapInfo>> _mapsFuture;

  @override
  void initState() {
    super.initState();
    _mapsFuture = fetchMaps();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 112, 108, 168),
      appBar: AppBar(
        title: Text('Map info'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 51, 51, 190),),
      body: FutureBuilder<List<mapInfo>>(
        future: _mapsFuture,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }else if (snapshot.hasError){
            return Center(child: Text('Error: ${snapshot.error}'),);
          }else if (!snapshot.hasData || snapshot.data!.isEmpty){
            return const Center(child: Text('no maps availible'),);
          }

          final maps = snapshot.data!;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // Number of items per row
        crossAxisSpacing: 8.0, // Spacing between items horizontally
        mainAxisSpacing: 8.0, // Spacing between items vertically
        childAspectRatio: 1, // Aspect ratio of each item (1 for square items)
          ),
          itemCount: maps.length,
          itemBuilder: (context, index) {
            final map = maps[index];
            return MapCard(map: map);
          }
          );
        }
    )
    );
  }
}

class MapCard extends StatefulWidget{
  final mapInfo map;

  const MapCard({required this.map, Key? key}) : super(key: key);

  @override
  State<MapCard> createState() => _MapCardState();
}

class _MapCardState extends State<MapCard> {
  bool _showImage = true;

  void _toggleView() {
    setState((){
      _showImage = !_showImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 8,
      color: const Color.fromARGB(255, 122, 122, 229),
      child:InkWell(
            splashColor: Colors.blueAccent,
            onTap: () {
              _toggleView();
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 300,
                  width: 300,
                  
                  child: _showImage
                  ?Image.network(
                    widget.map.screenshot,
                    fit: BoxFit.cover,
                    )
                  : Padding(padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text('Location: ${widget.map.location} (${widget.map.country_code})',
                      style: const TextStyle(fontSize: 16)),
                       const SizedBox(height: 8),
                            Text(
                              'Game Modes: ${widget.map.gamemodes.join(", ")}',
                              style: const TextStyle(fontSize: 16),)
                    ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Center(
                    child: Text(
                      widget.map.name,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                )
              ],
            ),
    ));
  }
}

class mapInfo{
  final String name;
  final String screenshot;
  final List gamemodes;
  final String location;
  final String country_code;
  const mapInfo({
    required this.name,
    required this.screenshot,
    required this.gamemodes,
    required this.location,
    required this.country_code,
  });

  factory mapInfo.fromJson(Map<String, dynamic>json){
    return mapInfo(
      name: json['name'] ?? 'unkown name', 
      screenshot: json['screenshot'] ?? 'no screenshot availible', 
      gamemodes: json['gamemodes'] ?? 'no gamemodes acessable at this time', 
      location: json['location'] ?? 'location unkown', 
      country_code: json['country_code'] ?? 'no currently avalible country code');
  }
}




