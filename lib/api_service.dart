import 'dart:convert';
import 'package:http/http.dart' as http;

import 'models/news_model.dart';
import 'models/video_feed_model.dart';

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

  static Future<List<VideoFeedModel>> fetchVideoFeeds() async {
    try {
      // Asumsi endpoint di backend Node.js kamu adalah /api/videos
      final response = await http.get(Uri.parse('$baseUrl/videos'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        // Membaca array data dari backend (mengikuti struktur json yang sama)
        final List<dynamic> listData = jsonResponse['data'];
        return listData.map((item) => VideoFeedModel.fromJson(item)).toList();
      } else {
        print('Error Server Video: ${response.body}');
        throw Exception('Status Server: ${response.statusCode}');
      }
    } catch (e) {
      print('Detail Error ApiService (Video): $e');
      throw Exception('Gagal memuat data video dari server ($e)');
    }
  }
}
