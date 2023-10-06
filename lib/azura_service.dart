import 'dart:convert';
import 'package:http/http.dart' as http;

class AzuraService {
  final String _baseUrl = 'https://a2.asurahosting.com/api';
  final String _apiKey = '49d6ed5c1f169d1f:2aa595bbb7b090b39f2878930f0a88c5';

  Future<Map<String, dynamic>> fetchNowPlaying() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/nowplaying/onlybelieveradio-india'),
      headers: {
        'Authorization': 'Bearer $_apiKey',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load track details');
    }
  }
}
