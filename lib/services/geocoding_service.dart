import 'dart:convert';
import 'package:http/http.dart' as http;

class GeocodingService {

  Future<Map<String, double>?> getCoordinates(String place) async {
    final url =
        "https://nominatim.openstreetmap.org/search?q=$place&format=json&limit=1";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'User-Agent': 'tripmate_app'
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data.isNotEmpty) {
        return {
          "lat": double.parse(data[0]["lat"]),
          "lon": double.parse(data[0]["lon"]),
        };
      }
    }

    return null;
  }
}