import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:marvel_app/character/character.dart';

class ApiService {
  String endpoint = "https://gateway.marvel.com:443/v1/public/characters";
  String ts = "1691596078205";
  String publicKey = "b5e16889cb9e3b6fc05da60116818d30";
  String hash = "ea1364ca386831224b9e2dc3a722f16c";

  Future<List<Character>> fetchCharacters(String nameSearch) async {
    String url = "$endpoint?apikey=$publicKey&ts=$ts&hash=$hash";

    if (nameSearch != "") {
      url += "&nameStartsWith=$nameSearch";
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List result = jsonDecode(response.body)['data']['results'];
      return result.map((character) => Character.fromJson(character)).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}