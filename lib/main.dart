import 'package:flutter/material.dart';
import 'package:marvel_app/character/character.dart';
import 'package:marvel_app/api_request.dart';

void main() {
  runApp(const MaterialApp(
    title: 'Navigation Basics',
    home: SearchMenu(),
  ));
}

class SearchMenu extends StatefulWidget {
  const SearchMenu({super.key});

  @override
  State<SearchMenu> createState() => _SearchMenuState();
}

class _SearchMenuState extends State<SearchMenu> {
  late Future<Character> futureCharacterList;
  String nameSearch = "";

  final searchBarDecoration = const InputDecoration(
    filled: true,
    fillColor: Colors.white,
    prefixIcon: Icon(Icons.search),
    prefixIconColor: Colors.grey,
    hintText: 'Find your super hero',
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2.0),
    ),
    border: OutlineInputBorder(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Marvel Universe'),
      ),
      body: Column(
        children: [
          TextField(
            onChanged: (String value) {
              setState(() {
                nameSearch = value;
              });
            },
            cursorColor: Colors.red,
            decoration: searchBarDecoration,
          ),
          FutureBuilder<List<Character>>(
            future: ApiService().fetchCharacters(nameSearch),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              return Expanded(
                child: ListView(
                  children: [
                    ...snapshot.data!.map(
                      (item) => CharacterCard(
                        character: item,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
