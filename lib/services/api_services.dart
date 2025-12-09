import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServices {
  final String baseUrl = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey = "4b7d38cc19d049d4f106d7e46b4d8281";

  Future<Map<String, dynamic>> getWeather(String city) async {
    final url = Uri.parse("$baseUrl?q=$city&appid=$apiKey&units=metric");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load Weather");
    }
    }
  }