import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_keys.dart';

class WeatherService {
  final String apiKey = ApiKeys.weatherApiKey;

  Future<Map<String, dynamic>?> fetchWeather(String city) async {
    final url =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return null;
    }
  }
}