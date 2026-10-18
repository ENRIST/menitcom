import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/news_model.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';

  static Future<List<NewsModel>> fetchNews() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/news'));

      // Jika response sukses (HTTP Status 200)
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        // Membaca array data dari backend
        final List<dynamic> listData = jsonResponse['data'];
        return listData.map((item) => NewsModel.fromJson(item)).toList();
      } else {
        // Cetak isi error ke Debug Console VS Code
        print('Error Server: ${response.body}');
        throw Exception('Status Server: ${response.statusCode}');
      }
    } catch (e) {
      print('Detail Error ApiService: $e');
      throw Exception('Gagal memuat data dari server ($e)');
    }
  }
}
