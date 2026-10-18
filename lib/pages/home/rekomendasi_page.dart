import 'package:flutter/material.dart';

// Import Service & Model
import '../../api_service.dart';
import '../../models/news_model.dart';

// Import Halaman Detail Berita
import 'news_detail_page.dart';

class RekomendasiPage extends StatefulWidget {
  const RekomendasiPage({super.key});

  @override
  State<RekomendasiPage> createState() => _RekomendasiPageState();
}

class _RekomendasiPageState extends State<RekomendasiPage> {
  late Future<List<NewsModel>> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = ApiService.fetchNews(); // Memanggil data dari API Node.js
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          futureNews = ApiService.fetchNews(); // Refresh data dari backend
        });
      },
      color: Colors.blue,
      backgroundColor: const Color(0xFF262A30),
      child: FutureBuilder<List<NewsModel>>(
        future: futureNews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: CircularProgressIndicator(color: Colors.blue),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Gagal terhubung ke Server Node.js:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: Text(
                  'Belum ada berita rekomendasi di database.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            );
          }

          // Salin data berita dari snapshot
          final rawNewsList = List<NewsModel>.from(snapshot.data!);

          // 1. Ambil 1 berita pertama untuk Highlight Rekomendasi
          final featuredNews = rawNewsList[0];

          // 2. Sisa berita diacak (shuffle) lalu diambil maksimal 4 berita
          final remainingNews = rawNewsList.skip(1).toList()..shuffle();
          final displayedNewsList = remainingNews.take(4).toList();

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HASHTAG BANNER
                Container(
                  width: double.infinity,
                  color: const Color(0xFF262A30),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: const Text(
                    '#DPD RI Awards',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // BERITA UTAMA REKOMENDASI (HIGHLIGHT DARI DATABASE)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NewsDetailPage(newsId: featuredNews.newsId),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            height: 210,
                            width: double.infinity,
                            child: NetworkImageWidget(
                              imageUrl: featuredNews.imageUrl,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          featuredNews.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${featuredNews.categoryName} · ${featuredNews.publishedAt}',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // LIST BERITA LAINNYA (DENGAN REFRESH / RANDOM MAKSIMAL 4 BERITA)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayedNewsList.length,
                  itemBuilder: (context, index) {
                    final news = displayedNewsList[index];
                    return Column(
                      children: [
                        NewsTileItem(
                          newsId: news.newsId,
                          title: news.title,
                          category: news.categoryName,
                          time: news.publishedAt,
                          imageUrl: news.imageUrl,
                        ),
                        const Divider(color: Colors.white10, height: 28),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 24),

                // BANNER MPC
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC107),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            'mpc',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Yuk! Registrasi di MPC',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// WIDGET KHUSUS CUSTOM NETWORK IMAGE
// -----------------------------------------------------------------------------
class NetworkImageWidget extends StatelessWidget {
  final String imageUrl;

  const NetworkImageWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: const Color(0xFF262A30),
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white24,
              ),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: const Color(0xFF262A30),
          child: const Center(
            child: Icon(Icons.broken_image, color: Colors.grey, size: 30),
          ),
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// WIDGET ITEM LIST BERITA DENGAN KLIK NAVIGASI KE DETAIL BERITA
// -----------------------------------------------------------------------------
class NewsTileItem extends StatelessWidget {
  final int newsId;
  final String title;
  final String category;
  final String time;
  final String imageUrl;

  const NewsTileItem({
    super.key,
    required this.newsId,
    required this.title,
    required this.category,
    required this.time,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailPage(newsId: newsId),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$category · $time',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 85,
                height: 85,
                child: NetworkImageWidget(imageUrl: imageUrl),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
