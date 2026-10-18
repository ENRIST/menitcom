// lib/pages/explore/explore_widgets.dart
// Widget yang dipakai bersama oleh ExplorePage, AllEventsPage, AllColumnsPage.
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'explore_models.dart';

// ---------------------------------------------------------------- Warna
const Color kPrimary = Color(0xFF2B55A0);
const Color kTextDark = Color(0xFF1A1A1A);
const Color kTextGrey = Color(0xFF8A8A8A);
const Color kDivider = Color(0xFFEDEDED);
const Color kSectionGap = Color(0xFFF1F1F1);
const Color kPlaceholder = Color(0xFFE9ECF1);

// ---------------------------------------------------------------- Gambar
class NetImage extends StatelessWidget {
  const NetImage(
    this.url, {
    super.key,
    this.width,
    this.height,
    this.radius = 12,
  });

  final String url;
  final double? width;
  final double? height;
  final double radius;

  Widget _placeholder() => Container(
        width: width,
        height: height,
        color: kPlaceholder,
        alignment: Alignment.center,
        child: const Icon(Icons.image_outlined, color: Color(0xFFB0B7C3)),
      );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: url.isEmpty
          ? _placeholder()
          : Image.network(
              url,
              width: width,
              height: height,
              fit: BoxFit.cover,
              loadingBuilder: (c, child, p) => p == null ? child : _placeholder(),
              errorBuilder: (c, e, s) => _placeholder(),
            ),
    );
  }
}

// ---------------------------------------------------------------- Judul seksi
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.onArrowTap});
  final String text;
  final VoidCallback? onArrowTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 8, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: kTextDark,
              ),
            ),
          ),
          if (onArrowTap != null)
            IconButton(
              onPressed: onArrowTap,
              icon: const Icon(Icons.arrow_forward, color: kPrimary),
              tooltip: 'Lihat semua',
            ),
        ],
      ),
    );
  }
}

/// Garis tebal pemisah antar seksi
class SectionGap extends StatelessWidget {
  const SectionGap({super.key});
  @override
  Widget build(BuildContext context) =>
      Container(height: 6, color: kSectionGap, margin: const EdgeInsets.symmetric(vertical: 20));
}

/// Tombol "Selengkapnya ->"
class MoreButton extends StatelessWidget {
  const MoreButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: kDivider)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selengkapnya',
              style: TextStyle(color: kPrimary, fontSize: 17, fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: kPrimary, size: 20),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- Loading / error
class LoadingBox extends StatelessWidget {
  const LoadingBox({super.key, this.height = 200});
  final double height;
  @override
  Widget build(BuildContext context) => SizedBox(
        height: height,
        child: const Center(child: CircularProgressIndicator(color: kPrimary)),
      );
}

class ErrorBox extends StatelessWidget {
  const ErrorBox({super.key, required this.onRetry, this.message});
  final VoidCallback onRetry;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Icon(Icons.wifi_off_rounded, size: 40, color: kTextGrey),
          const SizedBox(height: 12),
          Text(
            message ?? 'Gagal memuat data.\nPastikan server Node.js sudah berjalan.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: kTextGrey),
          ),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onRetry, child: const Text('Coba lagi')),
        ],
      ),
    );
  }
}

class EmptyText extends StatelessWidget {
  const EmptyText(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(32),
        child: Center(child: Text(text, style: const TextStyle(color: kTextGrey))),
      );
}

// ---------------------------------------------------------------- Berita
class NewsTile extends StatelessWidget {
  const NewsTile({super.key, required this.news, this.rank, this.onTap});
  final NewsItem news;
  final int? rank; // null = tanpa nomor (hasil pencarian)
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: kDivider)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (rank != null)
              SizedBox(
                width: 34,
                child: Text(
                  '$rank',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFA5A5A5),
                  ),
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                      color: kTextDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: news.categoryName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        if (news.publishedAt.isNotEmpty)
                          TextSpan(text: '  •  ${news.publishedAt}'),
                      ],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: kTextGrey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            NetImage(news.imageUrl, width: 96, height: 96),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- Avatar
class AuthorAvatar extends StatelessWidget {
  const AuthorAvatar({super.key, required this.name, this.url, this.size = 40});
  final String name;
  final String? url;
  final double size;

  static const _palette = [
    Color(0xFFF4511E), Color(0xFF3949AB), Color(0xFF00897B),
    Color(0xFF8E24AA), Color(0xFFF9A825), Color(0xFF546E7A),
  ];

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts[1][0]).toUpperCase();
  }

  Widget _fallback() => Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        color: _palette[name.codeUnits.fold<int>(0, (a, b) => a + b) % _palette.length],
        child: Text(
          _initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.42,
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: (url == null || url!.isEmpty)
          ? _fallback()
          : Image.network(
              url!,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => _fallback(),
            ),
    );
  }
}

// ---------------------------------------------------------------- Kolom
class ColumnTile extends StatelessWidget {
  const ColumnTile({super.key, required this.column, this.onTap});
  final ColumnItem column;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: kDivider)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    column.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                      color: kTextDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      AuthorAvatar(name: column.authorName, url: column.authorAvatar),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(text: 'Oleh: '),
                              TextSpan(
                                text: column.authorName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF555555),
                                ),
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14, color: kTextGrey),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            NetImage(column.imageUrl, width: 96, height: 96),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- Event
class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event, required this.onBook});
  final EventItem event;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE3E6EC)),
        boxShadow: const [
          BoxShadow(color: Color(0x0F000000), blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: NetImage(event.imageUrl, radius: 0),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    color: kPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFFE5533D)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        event.dateRange,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  event.priceLabel,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: kTextDark,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: onBook,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimary,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const Text(
                      'Pesan Tiket',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Buka link pemesanan tiket di browser/aplikasi luar.
Future<void> openBooking(BuildContext context, EventItem event) async {
  final messenger = ScaffoldMessenger.of(context);
  final raw = event.bookingUrl;
  if (raw == null || raw.isEmpty) {
    messenger.showSnackBar(const SnackBar(content: Text('Link pemesanan belum tersedia')));
    return;
  }
  try {
    final ok = await launchUrl(Uri.parse(raw), mode: LaunchMode.externalApplication);
    if (!ok) {
      messenger.showSnackBar(const SnackBar(content: Text('Tidak dapat membuka link')));
    }
  } catch (_) {
    messenger.showSnackBar(const SnackBar(content: Text('Tidak dapat membuka link')));
  }
}
