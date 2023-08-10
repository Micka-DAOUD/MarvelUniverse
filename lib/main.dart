import 'package:flutter/material.dart';
import 'package:marvel_app/character/character.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  List<Character> characterList = [];
  String nameSearch = "";
  var offset = 0;

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

  fetch() {
    String endpoint = "https://gateway.marvel.com:443/v1/public/characters";
    String ts = "1691596078205";
    String publicKey = "b5e16889cb9e3b6fc05da60116818d30";
    String hash = "ea1364ca386831224b9e2dc3a722f16c";

    String url =
        "$endpoint?apikey=$publicKey&ts=$ts&hash=$hash&offset=${offset * 20}";

    if (nameSearch != "") {
      url += "&nameStartsWith=$nameSearch";
    }

    http.get(Uri.parse(url)).then((response) {
      if (response.statusCode != 200) {
        throw Exception(response.reasonPhrase);
      }
      final List fetchedData = jsonDecode(response.body)['data']['results'];
      final results = fetchedData
          .map((character) => Character.fromJson(character))
          .toList();

      setState(() {
        characterList.addAll(results);
        offset++;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetch();
  }

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
                characterList.clear();
                offset = 0;
                fetch();
              });
            },
            cursorColor: Colors.red,
            decoration: searchBarDecoration,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                if (index < characterList.length) {
                  return CharacterCard(character: characterList[index]);
                } else {
                  fetch();
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  );
                }
              },
              itemCount: characterList.length + 1,
            ),
          ),
        ],
      ),
    );
  }
}
