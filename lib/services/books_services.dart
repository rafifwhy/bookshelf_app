import 'dart:convert';

import 'package:http/http.dart' as http;

class BooksService {
  static Future<bool> deleteBook(String id) async {
    final url = 'http://192.168.100.8:5000/books/${id}';
    final uri = Uri.parse(url);

    final response = await http.delete(uri);
    return response.statusCode == 200;
  }

  static Future<List?> fetchBooks() async {
    final url = 'http://192.168.100.8:5000/books';
    final uri = Uri.parse(url);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['data']['books'] as List;

      return result;
    } else {
      return null;
    }
  }

  static Future<bool> updateBook(String id, Map body) async {
    final url =
        'http://192.168.100.8:5000/books/${id}'; //Change into current IP
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    return response.statusCode == 200;
  }

  static Future<bool> addBook(Map body) async {
    final url = 'http://192.168.100.8:5000/books'; //Change into current IP
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    return response.statusCode == 201;
  }
}
