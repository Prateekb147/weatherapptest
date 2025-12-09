import 'package:http/http.dart' as http;
import 'dart:convert';

class CitySuggestionService {
  static Future<List<String>> fetchCities(String query) async {
  if (query.isEmpty) return [];

  final url = Uri.parse(
    "https://wft-geo-db.p.rapidapi.com/v1/geo/cities?limit=10&namePrefix=$query"
  );

  final response = await http.get(
    url,
    headers: {
      "X-RapidAPI-Key" : "5fc8972bfdmsh3aa49c3e2aef0ccp16e7f7jsnbe7a8de0bedc",
      "X-RapidAPI-Host": "wft-geo-db.p.rapidapi.com"
    },
  );

  if (response.statusCode != 200) return [];

  final data = json.decode(response.body);

  List cities = data["data"];
  return cities.map<String>((c) => c["city"]).toList();
  }
}