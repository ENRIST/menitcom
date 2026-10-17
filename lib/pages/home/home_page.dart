import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';

import 'story_detail_page.dart';

class StoryModel {
  final String title;
  final String videoPath; // Path ke file MP4 lokal
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

class _HomePageState extends State<HomePage> {
  // MASTER DATA 18 VIDEO LOKAL ASSETS (Tanpa thumbnail URL internet)
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
    StoryModel(
      title: 'Teknologi AI Terbaru Yang Mengubah Dunia Kerja',
      videoPath: 'videos/video7.mp4',
      time: '5 jam lalu',
    ),
    StoryModel(
      title: 'Resep Praktis Sarapan Sehat Hanya 5 Menit',
      videoPath: 'videos/video8.mp4',
      time: '6 jam lalu',
    ),
    StoryModel(
      title: 'Olahraga Ringan di Rumah untuk Membakar Kalori',
      videoPath: 'videos/video9.mp4',
      time: '7 jam lalu',
    ),
    StoryModel(
      title: 'Review Gadget Terbaru dengan Performa Terbaik',
      videoPath: 'videos/video10.mp4',
      time: '8 jam lalu',
    ),
    StoryModel(
      title: 'Kisah Inspiratif Pengusaha Muda Sukses di Indonesia',
      videoPath: 'videos/video11.mp4',
      time: '9 jam lalu',
    ),
    StoryModel(
      title: 'Tips Memilih Sepatu Lari yang Nyaman',
      videoPath: 'videos/video12.mp4',
      time: '10 jam lalu',
    ),
    StoryModel(
      title: 'Seni Fotografi Ponsel: Bikin Foto Selevel Kamera Pro',
      videoPath: 'videos/video13.mp4',
      time: '11 jam lalu',
    ),
    StoryModel(
      title: 'Keindahan Alam Nusa Penida Bali Yang Menakjubkan',
      videoPath: 'videos/video14.mp4',
      time: '12 jam lalu',
    ),
    StoryModel(
      title: 'Panduan Investasi Reksadana untuk Pemula',
      videoPath: 'videos/video15.mp4',
      time: '13 jam lalu',
    ),
    StoryModel(
      title: 'Perkembangan Otomotif Listrik Masa Depan',
      videoPath: 'videos/video16.mp4',
      time: '14 jam lalu',
    ),
    StoryModel(
      title: 'Manfaat Minum Air Putih Cukup Setiap Hari',
      videoPath: 'videos/video17.mp4',
      time: '15 jam lalu',
    ),
    StoryModel(
      title: 'Trik Produktif Bekerja dari Rumah Tanpa Stress',
      videoPath: 'videos/video18.mp4',
      time: '16 jam lalu',
    ),
  ];

  List<StoryModel> _displayedStories = [];

  @override
  void initState() {
    super.initState();
    _getRandomStories();
  }

  Future<void> _getRandomStories() async {
    final shuffled = List<StoryModel>.from(_allStories)..shuffle();
    setState(() {
      _displayedStories = shuffled.take(6).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: CustomAppBar(),
      ),
      body: RefreshIndicator(
        onRefresh: _getRandomStories,
        color: Colors.blue,
        backgroundColor: const Color(0xFF262A30),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CategoryTabBar(),
              const HashtagBanner(),
              const SizedBox(height: 12),
              StoriesSection(stories: _displayedStories),
              const SizedBox(height: 16),
              const FeaturedVideoCard(),
              const SizedBox(height: 16),
              const NewsListItem(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// WIDGET KHUSUS GENERATE THUMBNAIL LOKAL DARI VIDEO MP4
// -----------------------------------------------------------------------------
class VideoThumbnailWidget extends StatelessWidget {
  final String videoPath;

  const VideoThumbnailWidget({super.key, required this.videoPath});

  Future<Uint8List?> _generateThumbnail() async {
    final String fullAssetPath = 'assets/$videoPath';
    final XFile thumbnailXFile = await VideoThumbnail.thumbnailFile(
      video: fullAssetPath,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 250,
      quality: 75,
    );
    return await thumbnailXFile.readAsBytes();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _generateThumbnail(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            snapshot.data != null) {
          return Image.memory(
            snapshot.data!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          );
        }
        // Tampilan loading sementara saat thumbnail sedang di-generate
        return Container(
          color: const Color(0xFF1B1E23),
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.grey,
              ),
            ),
          ),
        );
      },
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
                    // 1. Thumbnail otomatis dari file video MP4
                    VideoThumbnailWidget(videoPath: story.videoPath),

                    // 2. Overlay gradient hitam transparan
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.8),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),

                    // 3. Icon Play di sudut kanan atas
                    const Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(
                        Icons.play_circle_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),

                    // 4. Judul video di bagian bawah
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
// WIDGET-WIDGET TAMPILAN LAINNYA
// -----------------------------------------------------------------------------
class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
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
            const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white30,
              child: Icon(Icons.person, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryTabBar extends StatefulWidget {
  const CategoryTabBar({super.key});

  @override
  State<CategoryTabBar> createState() => _CategoryTabBarState();
}

class _CategoryTabBarState extends State<CategoryTabBar> {
  int selectedCategory = 0;
  final List<String> categories = [
    'Terupdate',
    'Rekomendasi',
    'Populer',
    'Lifestyle',
    'Komentar',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = selectedCategory == index;
          return GestureDetector(
            onTap: () => setState(() => selectedCategory = index),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    categories[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[400],
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 3,
                    width: 30,
                    color: isSelected ? Colors.white : Colors.transparent,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

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

class FeaturedVideoCard extends StatelessWidget {
  const FeaturedVideoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                    child: const VideoThumbnailWidget(
                      videoPath: 'videos/video1.mp4',
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.5),
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
                      backgroundColor: Colors.grey.withOpacity(0.5),
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
                  children: const [
                    Text(
                      'Video: Lihat Lagi Alasan MSCI Buka Peluang Turunkan Kasta Pasar Saham RI',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'detikFinance',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewsListItem extends StatelessWidget {
  const NewsListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Trump Gunakan Nama 'Mohammad' untuk Jadi Bahan Candaan",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Text(
                      'detikNews',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      ' • 47 menit lalu',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 90,
              height: 65,
              child: const VideoThumbnailWidget(videoPath: 'videos/video2.mp4'),
            ),
          ),
        ],
      ),
    );
  }
}
