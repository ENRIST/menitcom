// lib/pages/explore/explore_models.dart

const List<String> _bulan = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
];

/// "2026-12-11" -> "11 Des 2026"
String formatTanggal(DateTime? d) {
  if (d == null) return '-';
  return '${d.day.toString().padLeft(2, '0')} ${_bulan[d.month - 1]} ${d.year}';
}

/// 850000 -> "Rp850.000" (0 -> "Gratis")
String formatRupiah(int value) {
  if (value <= 0) return 'Gratis';
  final s = value.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return 'Rp$buf';
}

int _toInt(dynamic v) => v is num ? v.toInt() : int.tryParse('${v ?? 0}') ?? 0;
String _toStr(dynamic v) => v == null ? '' : v.toString();

// ---------------------------------------------------------------------
class NewsItem {
  final int id;
  final String title;
  final String slug;
  final String imageUrl;
  final String publishedAt; // varchar di DB, mis. "2 jam lalu"
  final String categoryName;
  final int views;

  const NewsItem({
    required this.id,
    required this.title,
    required this.slug,
    required this.imageUrl,
    required this.publishedAt,
    required this.categoryName,
    required this.views,
  });

  factory NewsItem.fromJson(Map<String, dynamic> j) => NewsItem(
        id: _toInt(j['news_id']),
        title: _toStr(j['title']),
        slug: _toStr(j['slug']),
        imageUrl: _toStr(j['image_url']),
        publishedAt: _toStr(j['published_at']),
        categoryName: _toStr(j['category_name']),
        views: _toInt(j['views_count']),
      );
}

// ---------------------------------------------------------------------
class EventItem {
  final int id;
  final String title;
  final String imageUrl;
  final DateTime? startDate;
  final DateTime? endDate;
  final int price;
  final String? bookingUrl;

  const EventItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.price,
    this.bookingUrl,
  });

  String get dateRange => '${formatTanggal(startDate)} - ${formatTanggal(endDate)}';
  String get priceLabel => formatRupiah(price);

  factory EventItem.fromJson(Map<String, dynamic> j) => EventItem(
        id: _toInt(j['event_id']),
        title: _toStr(j['title']),
        imageUrl: _toStr(j['image_url']),
        startDate: DateTime.tryParse(_toStr(j['start_date'])),
        endDate: DateTime.tryParse(_toStr(j['end_date'])),
        price: _toInt(j['price']),
        bookingUrl: j['booking_url']?.toString(),
      );
}

// ---------------------------------------------------------------------
class ColumnItem {
  final int id;
  final String title;
  final String authorName;
  final String? authorAvatar;
  final String imageUrl;
  final String content;

  const ColumnItem({
    required this.id,
    required this.title,
    required this.authorName,
    required this.authorAvatar,
    required this.imageUrl,
    required this.content,
  });

  factory ColumnItem.fromJson(Map<String, dynamic> j) => ColumnItem(
        id: _toInt(j['column_id']),
        title: _toStr(j['title']),
        authorName: _toStr(j['author_name']),
        authorAvatar: (j['author_avatar'] == null || '${j['author_avatar']}'.isEmpty)
            ? null
            : j['author_avatar'].toString(),
        imageUrl: _toStr(j['image_url']),
        content: _toStr(j['content']),
      );
}
