import 'package:flutter/material.dart';

import '../../api_service.dart';
import '../../models/news_model.dart';
import '../home/news_detail_page.dart';
import 'category_data.dart';

class CategoryNewsPage extends StatefulWidget {
  final CategoryItemModel category;

  const CategoryNewsPage({super.key, required this.category});

  @override
  State<CategoryNewsPage> createState() => _CategoryNewsPageState();
}

class _CategoryNewsPageState extends State<CategoryNewsPage> {
  // Variabel untuk menyimpan data dari API
  late Future<List<NewsModel>> _newsFuture;

  @override
  void initState() {
    super.initState();
    // Panggil API saat halaman pertama kali dibuka
    _newsFuture = ApiService.fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: kBgColor,
        appBar: AppBar(
          backgroundColor: kCardColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              children: [
                const TextSpan(
                  text: 'menit',
                  style: TextStyle(color: Colors.white),
                ),
                TextSpan(
                  text: widget.category.label.toLowerCase(),
                  style: const TextStyle(color: Color(0xFF218CF3)),
                ),
              ],
            ),
          ),
          centerTitle: true,
          actions: [
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'News'),
              Tab(text: 'Internasional'),
              Tab(text: 'Pro Kontra'),
              Tab(text: 'Kolom'),
              Tab(text: 'Style'),
            ],
          ),
        ),
        body: FutureBuilder<List<NewsModel>>(
          future: _newsFuture,
          builder: (context, snapshot) {
            // 1. Tampilan saat loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            // 2. Tampilan jika error (misal server backend mati)
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Gagal memuat berita.\nPastikan backend Node.js menyala.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }

            // 3. Ambil semua data, lalu FILTER berdasarkan kategori yang diklik
            final allNews = snapshot.data ?? [];

            final filteredNews = allNews.where((news) {
              final dbCategory = news.categoryName.toLowerCase();
              final clickedCategory = widget.category.label.toLowerCase();
              return dbCategory.contains(clickedCategory) ||
                  clickedCategory.contains(dbCategory);
            }).toList();

            // 4. Jika berita di kategori tersebut kosong
            if (filteredNews.isEmpty) {
              return const Center(
                child: Text(
                  'Belum ada berita di kategori ini.',
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }

            // 5. Jika data ada, tampilkan!
            return ListView(
              padding: const EdgeInsets.all(12),
              children: [
                // Berita Utama (Index ke-0)
                _buildFeaturedNews(filteredNews[0]),
                const SizedBox(height: 16),

                // Banner Iklan
                Container(
                  width: double.infinity,
                  height: 250,
                  color: const Color(0xFF2C313A), // Warna gelap
                  child: const Center(
                    child: Text(
                      'Iklan - Scroll untuk melanjutkan',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // List Berita Sisanya (Index 1 sampai habis)
                ...filteredNews.skip(1).map((news) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildListNews(news),
                  );
                }).toList(),
              ],
            );
          },
        ),
      ),
    );
  }

  // Widget untuk kartu berita utama (gambar besar)
  Widget _buildFeaturedNews(NewsModel news) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NewsDetailPage(newsId: news.newsId),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: kCardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kCardColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              news.imageUrl.isNotEmpty
                  ? news.imageUrl
                  : 'https://picsum.photos/600/400',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 200,
                color: Colors.grey[800],
                child: const Icon(Icons.broken_image, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    news.categoryName,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk list berita (teks kiri, gambar kanan)
  Widget _buildListNews(NewsModel news) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NewsDetailPage(newsId: news.newsId),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  news.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${news.categoryName} • ${news.publishedAt}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              news.imageUrl.isNotEmpty
                  ? news.imageUrl
                  : 'https://picsum.photos/150/100',
              width: 100,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 100,
                height: 70,
                color: Colors.grey[800],
                child: const Icon(Icons.broken_image, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
