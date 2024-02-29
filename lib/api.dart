import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> fetchLTPData(String identifier) async {
  final response = await http.get(
    Uri.parse('http://127.0.0.1:5000/get_ltp?instrument_identifier=$identifier'),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    print('Failed to fetch LTP for $identifier');
    return {};
  }
}

Future<List<String>> getAllInstrumentIdentifiers() async {
  final response = await http.get(
    Uri.parse('http://127.0.0.1:5000/get_all_instrument_identifiers'),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    final List<dynamic> identifiers = data['instrument_identifiers'];

    return identifiers.map<String>((item) => item.toString()).toList();
  } else {
    print('Failed to fetch all instrument identifiers');
    return [];
  }
}

