import 'dart:convert';
import 'package:http/http.dart' as http;

class AzuraService {
  final String _baseUrl = 'https://a4.asurahosting.com/api';
  final String _apiKey = '0a9f605fbc1c73d8:0cc302f454626d3a6f1a52e93e2f9646';

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
