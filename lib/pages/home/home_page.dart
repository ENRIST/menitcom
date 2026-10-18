import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// Import Service & Model
import '../../api_service.dart';
import '../../models/news_model.dart';

// Import halaman-halaman tab & detail berita
import 'rekomendasi_page.dart';
import 'populer_page.dart';
import 'lifestyle_page.dart';
import 'komentar_page.dart';
import 'story_detail_page.dart';
import 'news_detail_page.dart';

// Import Halaman Profil Sebelum Login
import '../profile_sebelum_login.dart';

class StoryModel {
  final String title;
  final String videoPath;
  final String time;

  StoryModel({
    required this.title,
    required this.videoPath,
    required this.time,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17191D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF17191D),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(
                Icons.cast_connected_outlined,
                color: Colors.white,
                size: 26,
              ),
              onPressed: () {},
            ),
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: 'menit',
                    style: TextStyle(color: Colors.white),
                  ),
                  TextSpan(
                    text: 'com',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
            // ICON PROFIL DIARAHKAN KE PROFIL SEBELUM LOGIN
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilSebelumLogin(),
                  ),
                );
              },
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white30,
                child: Icon(Icons.person, color: Colors.white70, size: 20),
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          padding: EdgeInsets.zero,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[400],
          labelStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
          ),
          tabs: const [
            Tab(text: 'Terupdate'),
            Tab(text: 'Rekomendasi'),
            Tab(text: 'Populer'),
            Tab(text: 'Lifestyle'),
            Tab(text: 'Komentar'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          TerupdateTab(), // Konten Tab Utama (Terupdate)
          RekomendasiPage(), // Konten Tab Rekomendasi
          PopulerPage(), // Konten Tab Populer
          LifestylePage(), // Konten Tab Lifestyle
          KomentarPage(), // Konten Tab Komentar
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// KONTEN TAB UTAMA (TERUPDATE) - TERINTEGRASI BACKEND NODE.JS & DATABASE MYSQL
// -----------------------------------------------------------------------------
class TerupdateTab extends StatefulWidget {
  const TerupdateTab({super.key});

  @override
  State<TerupdateTab> createState() => _TerupdateTabState();
}

class _TerupdateTabState extends State<TerupdateTab> {
  late Future<List<NewsModel>> futureNews;

  final List<StoryModel> _allStories = [
    StoryModel(
      title: 'Bukan Cuma Modal Sabar, Mancing Juga Butuh Strategi!',
      videoPath: 'videos/video1.mp4',
      time: '12 menit lalu',
    ),
    StoryModel(
      title: 'Alasan MSCI Buka Peluang Turunkan Kasta Pasar Saham RI',
      videoPath: 'videos/video2.mp4',
      time: '25 menit lalu',
    ),
    StoryModel(
      title: 'Sehari Habis 250 Porsi! Sop Buntut Cut Meutia Viral',
      videoPath: 'videos/video3.mp4',
      time: '1 jam lalu',
    ),
    StoryModel(
      title: 'Tips & Trik Mengatur Keuangan untuk Anak Muda',
      videoPath: 'videos/video4.mp4',
      time: '2 jam lalu',
    ),
    StoryModel(
      title: 'Destinasi Wisata Tersembunyi di Indonesia yang Wajib Dikunjungi',
      videoPath: 'videos/video5.mp4',
      time: '3 jam lalu',
    ),
    StoryModel(
      title: 'Eksplorasi Kuliner Malam Jakarta Paling Hits',
      videoPath: 'videos/video6.mp4',
      time: '4 jam lalu',
    ),
  ];

  List<StoryModel> _displayedStories = [];

  @override
  void initState() {
    super.initState();
    _getRandomStories();
    futureNews = ApiService.fetchNews(); // Memanggil data dari API Node.js
  }

  Future<void> _getRandomStories() async {
    final shuffled = List<StoryModel>.from(_allStories)..shuffle();
    setState(() {
      _displayedStories = shuffled.take(6).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await _getRandomStories();
        setState(() {
          futureNews =
              ApiService.fetchNews(); // Refresh data dari backend Node.js
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
                  'Belum ada berita tersedia di database.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            );
          }

          final rawNewsList = List<NewsModel>.from(snapshot.data!);

          // 1. Ambil 1 berita pertama untuk Highlight Utama
          final featuredNews = rawNewsList[0];

          // 2. Sisa berita diacak (shuffle) lalu diambil maksimal 4 berita saja
          final remainingNews = rawNewsList.skip(1).toList()..shuffle();
          final displayedNewsList = remainingNews.take(4).toList();

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HashtagBanner(),
                const SizedBox(height: 12),
                StoriesSection(stories: _displayedStories),
                const SizedBox(height: 16),

                // BERITA HIGHLIGHT UTAMA (INDEX 0)
                FeaturedVideoCard(
                  newsId: featuredNews.newsId,
                  imageUrl: featuredNews.imageUrl,
                  title: featuredNews.title,
                  category: featuredNews.categoryName,
                ),
                const SizedBox(height: 20),

                // DAFTAR BERITA BAWAH (ACAK MAKSIMAL 4 BERITA)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayedNewsList.length,
                  itemBuilder: (context, index) {
                    final news = displayedNewsList[index];
                    return Column(
                      children: [
                        NewsListItem(
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

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// WIDGET KHUSUS NETWORK IMAGE
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
// WIDGET KHUSUS THUMBNAIL VIDEO UNTUK STORIES ATAS
// -----------------------------------------------------------------------------
class VideoThumbnailWidget extends StatefulWidget {
  final String videoPath;

  const VideoThumbnailWidget({super.key, required this.videoPath});

  @override
  State<VideoThumbnailWidget> createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitialized) {
      return FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: VideoPlayer(_controller),
        ),
      );
    }

    return Container(
      color: const Color(0xFF1B1E23),
      child: const Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white24,
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// WIDGET STORIES SECTION
// -----------------------------------------------------------------------------
class StoriesSection extends StatelessWidget {
  final List<StoryModel> stories;

  const StoriesSection({super.key, required this.stories});

  @override
  Widget build(BuildContext context) {
    if (stories.isEmpty) {
      return const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator(color: Colors.blue)),
      );
    }

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StoryDetailPage(
                    videoPath: story.videoPath,
                    title: story.title,
                    time: story.time,
                  ),
                ),
              );
            },
            child: Container(
              width: 110,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    VideoThumbnailWidget(videoPath: story.videoPath),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.8),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(
                        Icons.play_circle_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 8,
                      right: 8,
                      child: Text(
                        story.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// WIDGET PENDUKUNG LAINNYA
// -----------------------------------------------------------------------------
class HashtagBanner extends StatelessWidget {
  const HashtagBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF262A30),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: const Text(
        '#DPD RI Awards',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }
}

// WIDGET BERITA UTAMA DENGAN DUKUNGAN KLIK NAVIGASI KE DETAIL
class FeaturedVideoCard extends StatelessWidget {
  final int newsId;
  final String imageUrl;
  final String title;
  final String category;

  const FeaturedVideoCard({
    super.key,
    required this.newsId,
    required this.imageUrl,
    required this.title,
    required this.category,
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            color: const Color(0xFF262A30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: NetworkImageWidget(imageUrl: imageUrl),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withValues(alpha: 0.5),
                        radius: 16,
                        child: const Icon(
                          Icons.volume_off,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: LinearProgressIndicator(
                        value: 0.3,
                        backgroundColor: Colors.grey.withValues(alpha: 0.5),
                        color: Colors.white,
                        minHeight: 3,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1E5BB1), Color(0xFF163E78)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// WIDGET ITEM LIST BERITA DENGAN DUKUNGAN KLIK NAVIGASI KE DETAIL
class NewsListItem extends StatelessWidget {
  final int newsId;
  final String title;
  final String category;
  final String time;
  final String imageUrl;

  const NewsListItem({
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
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        category,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        ' • $time',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
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
