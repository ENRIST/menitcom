import 'package:flutter/material.dart';

// Import Service & Model
import '../../api_service.dart';
import '../../models/news_model.dart';

// Import Halaman Detail Berita
import 'news_detail_page.dart';

class LifestylePage extends StatefulWidget {
  const LifestylePage({super.key});

  @override
  State<LifestylePage> createState() => _LifestylePageState();
}

class _LifestylePageState extends State<LifestylePage> {
  late Future<List<NewsModel>> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews =
        ApiService.fetchNews(); // Memanggil data dari API Node.js[cite: 3]
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          futureNews =
              ApiService.fetchNews(); // Refresh data dari backend[cite: 3]
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
                  'Belum ada berita lifestyle di database.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            );
          }

          // Ambil data dari snapshot
          final rawNewsList = List<NewsModel>.from(snapshot.data!);

          // 1. Ambil 1 berita pertama untuk Highlight Utama Lifestyle
          final featuredNews = rawNewsList[0];

          // 2. Sisa berita diacak (shuffle) lalu diambil maksimal 3 berita untuk bagian bawah
          final remainingNews = rawNewsList.skip(1).toList()..shuffle();
          final displayedNewsList = remainingNews.take(3).toList();

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HASHTAG BANNER[cite: 6]
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

                // BERITA UTAMA LIFESTYLE (GAMBAR BESAR DI ATAS)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailPage(
                          newsId: featuredNews.newsId,
                        ), //[cite: 3]
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

                // LIST BERITA BAWAH (DINAMIS DARI DATABASE & ACAK)
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
                        if (index < displayedNewsList.length - 1)
                          const Divider(color: Colors.white10, height: 28),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),

                // BANNER IKLAN BAWAH[cite: 6]
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      color: const Color(0xFF262A30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 180,
                            width: double.infinity,
                            child: NetworkImageWidget(
                              imageUrl: "https://images.unsplash.com/photo-1584515979956-d9f6e5d09982?q=80&w=600&auto=format&fit=crop",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: const Text(
                              '3 Alasan Penting Pastikan Air Minum untuk Keluarga Bebas BPA',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                            ),
                          ),
                        ],
                      ),
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
// WIDGET CUSTOM NETWORK IMAGE (UNTUK MEMUAT URL GAMBAR)[cite: 6]
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
// WIDGET ITEM LIST BERITA LIFESTYLE
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
            builder: (context) => NewsDetailPage(newsId: newsId), //[cite: 3]
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
                width: 90,
                height: 75,
                child: NetworkImageWidget(imageUrl: imageUrl),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
