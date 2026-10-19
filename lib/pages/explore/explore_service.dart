// lib/pages/explore/explore_service.dart
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'explore_models.dart';

class ExploreService {
  static const String? hostOverride = null;

  static String get baseUrl {
    if (hostOverride != null) return hostOverride!;
    if (kIsWeb) return 'http://localhost:3000';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://localhost:3000';
  }

  static const Duration _timeout = Duration(seconds: 12);

  Future<List<Map<String, dynamic>>> _getList(
    String path, [
    Map<String, String>? query,
  ]) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
    final res = await http.get(uri).timeout(_timeout);
    if (res.statusCode != 200) {
      throw Exception('Server error (${res.statusCode})');
    }
    final body = jsonDecode(utf8.decode(res.bodyBytes));
    final list = body is List
        ? body
        : (body is Map && body['data'] is List
              ? body['data'] as List
              : const []);
    return list.whereType<Map<String, dynamic>>().toList();
  }

  // DIUBAH: Mengarah ke API berita utama yang sudah ada di Home kamu (misal: /api/news)
  // Sesuaikan '/api/news' dengan endpoint yang dipakai di api_service.dart milikmu
  Future<List<NewsItem>> fetchPopular({int limit = 5}) async {
    final data = await _getList(
      '/api/news',
    ); // Menggunakan endpoint berita utama
    return data.take(limit).map(NewsItem.fromJson).toList();
  }

  // Untuk event & columns, jika belum ada endpoint-nya di backend,
  // kita buat kosong dulu agar tidak error "Cannot GET"
  Future<List<EventItem>> fetchEvents({int? limit}) async => [];

  Future<List<ColumnItem>> fetchColumns({int? limit}) async => [];

  // Untuk pencarian, menumpang ke endpoint berita utama lalu difilter secara lokal
  Future<List<NewsItem>> searchNews(String q) async {
    final data = await _getList('/api/news');
    final query = q.toLowerCase();
    return data
        .map(NewsItem.fromJson)
        .where((item) => item.title.toLowerCase().contains(query))
        .toList();
  }
}
