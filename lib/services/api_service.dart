import 'package:http/http.dart' as http;
import 'dart:convert';

const String baseUrl = 'http://127.0.0.1:5000';

Future<Map<String, dynamic>> fetchLTPData(String instrumentIdentifier) async {
  final url = 'http://127.0.0.1:5000/get_ltp?instrument_identifier=$instrumentIdentifier';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print('LTP Data for $instrumentIdentifier: $data');
      return data;
    } else {
      print('Error fetching LTP for $instrumentIdentifier: HTTP ${response.statusCode}');
      return {};
    }
  } catch (e) {
    print('Error fetching LTP for $instrumentIdentifier: $e');
    return {};
  }
}

Future<List<String>> getAllInstrumentIdentifiers() async {
  final response = await http.get(Uri.parse('$baseUrl/get_all_instrument_identifiers'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> identifiers = data['instrument_identifiers'];
    return identifiers.cast<String>();
  } else {
    throw Exception('Failed to load data');
  }
}
