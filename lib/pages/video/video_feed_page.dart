import 'package:flutter/material.dart';

// 1. IMPORT API SERVICE & MODEL
import '../../api_service.dart';
import '../../models/video_feed_model.dart';

import '../nav_bar.dart'; 
import 'video_shorts_page.dart';

class VideoFeedPage extends StatefulWidget {
  final bool showBottomNavBar;

  const VideoFeedPage({super.key, this.showBottomNavBar = true});

  @override
  State<VideoFeedPage> createState() => _VideoFeedPageState();
}

class _VideoFeedPageState extends State<VideoFeedPage> {
  int _currentNavIndex = 4;
  
  // 2. VARIABEL UNTUK MENYIMPAN DATA API
  late Future<List<VideoFeedModel>> futureVideos;

  @override
  void initState() {
    super.initState();
    // Memanggil API saat halaman pertama kali dimuat
    futureVideos = ApiService.fetchVideoFeeds();
  }

  // Fungsi untuk refresh data (tarik layar ke bawah)
  Future<void> _refreshData() async {
    setState(() {
      futureVideos = ApiService.fetchVideoFeeds();
    });
  }

  void _navigateToShorts(int initialIndex, List<VideoFeedModel> videos) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoShortsPage(
          initialIndex: initialIndex,
          videosList: videos, // Mengirim data list video agar sinkron
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: _buildHeader(),
      
      // 3. GUNAKAN REFRESH INDICATOR & FUTURE BUILDER
      body: RefreshIndicator(
        onRefresh: _refreshData,
        color: Colors.blue,
        backgroundColor: const Color(0xFF262A30),
        child: FutureBuilder<List<VideoFeedModel>>(
          future: futureVideos,
          builder: (context, snapshot) {
            // Status: Loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.red));
            } 
            // Status: Error
            else if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Error Koneksi API:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              );
            } 
            // Status: Kosong
            else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'Belum ada video tersedia.',
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }

            // Status: Berhasil
            final feedList = snapshot.data!;

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                // Video Besar Pertama (Index 0)
                if (feedList.isNotEmpty) _buildLargeVideoCard(feedList[0], feedList),
                
                const SizedBox(height: 20),
                const Divider(color: Colors.white12, height: 1, thickness: 1),
                const SizedBox(height: 16),
                
                // Shorts Carousel (Menggunakan data dinamis dari feedList)
                _buildShortsSection(feedList),
                
                const SizedBox(height: 16),
                const Divider(color: Colors.white12, height: 1, thickness: 1),
                const SizedBox(height: 20),
                
                // Sisa Video Besar (Mulai dari Index 1)
                if (feedList.length > 1)
                  ...feedList.skip(1).map((video) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: _buildLargeVideoCard(video, feedList),
                    );
                  }),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: widget.showBottomNavBar
          ? CustomBottomNavBar(
              currentIndex: _currentNavIndex,
              onTap: (index) {
                setState(() {
                  _currentNavIndex = index;
                });
              },
            )
          : null,
    );
  }

  // --------------------------------------------------------------------------
  // HEADER APPBAR
  // --------------------------------------------------------------------------
  AppBar _buildHeader() {
    return AppBar(
      backgroundColor: const Color(0xFF1E1E1E),
      elevation: 0,
      titleSpacing: 16,
      title: Row(
        children: [
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: '20',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 24, letterSpacing: -1.0),
                ),
                TextSpan(
                  text: 'DETIK',
                  style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w300, fontSize: 22),
                ),
                TextSpan(
                  text: ' | ',
                  style: TextStyle(color: Colors.white30, fontSize: 22, fontWeight: FontWeight.w300),
                ),
                TextSpan(
                  text: 'Video',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // LARGE VIDEO CARD
  // --------------------------------------------------------------------------
  Widget _buildLargeVideoCard(VideoFeedModel video, List<VideoFeedModel> allVideos) {
    // Cari index video ini di dalam list agar saat diklik langsung pas
    final int index = allVideos.indexOf(video);

    return GestureDetector(
      onTap: () => _navigateToShorts(index >= 0 ? index : 0, allVideos), 
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.network(
                      video.thumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[850],
                        child: const Icon(Icons.broken_image, color: Colors.white54, size: 40),
                      ),
                    ),
                  ),

                  if (video.titleOverlay != null)
                    Positioned(
                      left: 20,
                      bottom: 20,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(left: BorderSide(color: Color(0xFFE50914), width: 8)),
                        ),
                        child: Text(
                          video.titleOverlay!,
                          style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w900, height: 1.2),
                        ),
                      ),
                    ),

                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        video.duration,
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              video.titleBelow,
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600, height: 1.4),
            ),
            const SizedBox(height: 6),
            Text(
              video.timeAgo,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // SHORTS CAROUSEL (Dinamis dari Database API)
  // --------------------------------------------------------------------------
  Widget _buildShortsSection(List<VideoFeedModel> videos) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: videos.length, 
        itemBuilder: (context, index) {
          final video = videos[index];
          return _buildShortsCard(video, index, videos);
        },
      ),
    );
  }

  Widget _buildShortsCard(VideoFeedModel video, int index, List<VideoFeedModel> allVideos) {
    return GestureDetector(
      onTap: () => _navigateToShorts(index, allVideos),
      child: Container(
        width: 140,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                video.thumbnailUrl, 
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[850],
                  child: const Icon(Icons.broken_image, color: Colors.white54, size: 30),
                ),
              ),
              Positioned(
                top: 8, right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4), 
                    shape: BoxShape.circle, 
                    border: Border.all(color: Colors.white54, width: 1),
                  ),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 18),
                ),
              ),
              Positioned(
                left: 12, right: 12, bottom: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 16, height: 16, color: const Color(0xFFE50914)),
                    Container(
                      width: double.infinity, 
                      color: Colors.white, 
                      padding: const EdgeInsets.all(6),
                      child: Text(
                        video.titleBelow, 
                        maxLines: 4, 
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.w900, height: 1.2),
                      ),
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