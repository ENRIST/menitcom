import 'package:flutter/material.dart';

// Import Service & Model
import '../../api_service.dart';
import '../../models/news_model.dart';

// Import Halaman Detail Berita
import 'news_detail_page.dart';

class PopulerPage extends StatefulWidget {
  const PopulerPage({super.key});

  @override
  State<PopulerPage> createState() => _PopulerPageState();
}

class _PopulerPageState extends State<PopulerPage> {
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
                  'Belum ada berita populer di database.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            );
          }

          // Ambil data dari snapshot dan lakukan shuffle (acak) lalu ambil maksimal 5 berita untuk populer
          final rawNewsList = List<NewsModel>.from(snapshot.data!)..shuffle();
          final populerList = rawNewsList.take(5).toList();

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HASHTAG BANNER[cite: 5]
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
                const SizedBox(height: 12),

                // LIST BERITA POPULER DINAMIS DARI DATABASE[cite: 5]
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: populerList.length,
                  itemBuilder: (context, index) {
                    final news = populerList[index];
                    final nomorUrut = (index + 1).toString();

                    return Column(
                      children: [
                        _buildPopulerItem(
                          context: context,
                          newsId: news.newsId,
                          number: nomorUrut,
                          title: news.title,
                          category: news.categoryName,
                          time: news.publishedAt,
                          imageUrl: news.imageUrl,
                        ),
                        if (index < populerList.length - 1)
                          const Divider(color: Colors.white10, height: 28),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),

                // BANNER IKLAN BAWAH[cite: 5]
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

  Widget _buildPopulerItem({
    required BuildContext context,
    required int newsId,
    required String number,
    required String title,
    required String category,
    required String time,
    required String imageUrl,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailPage(
              newsId: newsId,
            ), // Navigasi ke halaman detail[cite: 3]
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // NOMOR URUT[cite: 5]
            SizedBox(
              width: 32,
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 4),
            // JUDUL & KATEGORI[cite: 5]
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$category · $time',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            // THUMBNAIL GAMBAR URL[cite: 5]
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

// -----------------------------------------------------------------------------
// WIDGET CUSTOM NETWORK IMAGE[cite: 5]
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
