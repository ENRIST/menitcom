// lib/pages/explore/explore_service.dart
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'explore_models.dart';

class ExploreService {
  /// Isi jika memakai HP fisik, mis. 'http://192.168.1.10:3000'
  /// (IP laptop di jaringan WiFi yang sama). Biarkan null untuk emulator.
  static const String? hostOverride = null;

  static String get baseUrl {
    if (hostOverride != null) return hostOverride!;
    if (kIsWeb) return 'http://localhost:3000';
    // Emulator Android: localhost laptop = 10.0.2.2
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://localhost:3000'; // iOS simulator / desktop
  }

  static const Duration _timeout = Duration(seconds: 12);

  /// Menerima respons berbentuk `[...]` maupun `{ success, data: [...] }`.
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
        : (body is Map && body['data'] is List ? body['data'] as List : const []);
    return list.whereType<Map<String, dynamic>>().toList();
  }

  Future<List<NewsItem>> fetchPopular({int limit = 5}) async =>
      (await _getList('/api/explore/popular', {'limit': '$limit'}))
          .map(NewsItem.fromJson)
          .toList();

  Future<List<EventItem>> fetchEvents({int? limit}) async =>
      (await _getList('/api/explore/events', limit == null ? null : {'limit': '$limit'}))
          .map(EventItem.fromJson)
          .toList();

  Future<List<ColumnItem>> fetchColumns({int? limit}) async =>
      (await _getList('/api/explore/columns', limit == null ? null : {'limit': '$limit'}))
          .map(ColumnItem.fromJson)
          .toList();

  Future<List<NewsItem>> searchNews(String q) async =>
      (await _getList('/api/explore/search', {'q': q}))
          .map(NewsItem.fromJson)
          .toList();
}
