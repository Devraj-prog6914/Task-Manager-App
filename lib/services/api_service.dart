import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quote_model.dart';

class ApiService {
  static const String _url = 'https://api.quotable.io/random';

  Future<Quote> fetchRandomQuote() async {
    try {
      final response = await http.get(Uri.parse(_url));
      if (response.statusCode == 200) {
        return Quote.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load quote');
      }
    } catch (e) {
      // Fallback quote in case of network issues or API downtime
      return Quote(content: "Keep pushing forward!", author: "Motivation Bot");
    }
  }
}
