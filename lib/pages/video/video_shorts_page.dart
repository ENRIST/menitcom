import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// Import Service & Model
import '../../api_service.dart';
import '../../models/video_feed_model.dart';

class VideoShortsPage extends StatefulWidget {
  final int initialIndex;
  final List<VideoFeedModel>? videosList;

  const VideoShortsPage({
    super.key,
    this.initialIndex = 0,
    this.videosList,
  });

  @override
  State<VideoShortsPage> createState() => _VideoShortsPageState();
}

class _VideoShortsPageState extends State<VideoShortsPage> {
  late final PageController _pageController;
  int _currentPageIndex = 0;
  late Future<List<VideoFeedModel>> _futureVideos;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);

    if (widget.videosList != null && widget.videosList!.isNotEmpty) {
      _futureVideos = Future.value(widget.videosList);
    } else {
      _futureVideos = ApiService.fetchVideoFeeds();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<List<VideoFeedModel>>(
        future: _futureVideos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Gagal memuat video:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada video tersedia.',
                style: TextStyle(color: Colors.white70),
              ),
            );
          }

          final videoList = snapshot.data!;

          return PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: videoList.length,
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final video = videoList[index];
              final isActive = index == _currentPageIndex;

              return _ShortsPlayerItem(
                video: video,
                isActive: isActive,
              );
            },
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// KOMPONEN PLAYER PER-ITEM (HIBRIDA DENGAN FALLBACK AMAN UNTUK WEB / PRESENTASI)
// -----------------------------------------------------------------------------
class _ShortsPlayerItem extends StatefulWidget {
  final VideoFeedModel video;
  final bool isActive;

  const _ShortsPlayerItem({
    required this.video,
    required this.isActive,
  });

  @override
  State<_ShortsPlayerItem> createState() => _ShortsPlayerItemState();
}

class _ShortsPlayerItemState extends State<_ShortsPlayerItem> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    final String sourcePath = widget.video.thumbnailUrl; 

    // Pendekatan Hibrida: URL Network vs Asset Lokal
    if (sourcePath.startsWith('http://') || sourcePath.startsWith('https://')) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(sourcePath));
    } else {
      final assetPath = sourcePath.isNotEmpty && sourcePath.contains('videos/') 
          ? sourcePath 
          : 'videos/video1.mp4';
          
      _controller = VideoPlayerController.asset(assetPath);
    }

    _controller.initialize().then((_) {
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
        _controller.setLooping(true);
        if (widget.isActive) {
          _controller.play();
        }
      }
    }).catchError((error) {
      debugPrint("Error initializing video player: $error. Falling back to local asset.");
      
      // Fallback Otomatis: Jika terjadi error MEDIA_ERR_SRC_NOT_SUPPORTED di Web/Network,
      // langsung alihkan ke video lokal di assets agar demo presentasi tetap berjalan lancar.
      _controller = VideoPlayerController.asset('videos/video1.mp4');
      _controller.initialize().then((_) {
        if (mounted) {
          setState(() {
            _isInitialized = true;
          });
          _controller.setLooping(true);
          if (widget.isActive) {
            _controller.play();
          }
        }
      }).catchError((fallbackError) {
        debugPrint("Fallback video initialization failed: $fallbackError");
      });
    });
  }

  @override
  void didUpdateWidget(covariant _ShortsPlayerItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isInitialized) {
      if (widget.isActive != oldWidget.isActive) {
        if (widget.isActive) {
          _controller.play();
        } else {
          _controller.pause();
          _controller.seekTo(Duration.zero);
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0 : 1.0);
    });
  }

  // ---------------------------------------------------------------------------
  // METHOD: POPUP BOTTOM SHEET KOMENTAR
  // ---------------------------------------------------------------------------
  void _showCommentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1B1E23),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return _CommentBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          // 1. Pemutar Video Hibrida
          Center(
            child: _isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : const CircularProgressIndicator(color: Colors.white),
          ),

          // 2. Gradient Overlay Gelap
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.5),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.85),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.2, 0.6, 1.0],
              ),
            ),
          ),

          // 3. Header Atas (Kembali & Mute)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                IconButton(
                  icon: Icon(
                    _isMuted ? Icons.volume_off : Icons.volume_up,
                    color: Colors.white,
                    size: 26,
                  ),
                  onPressed: _toggleMute,
                ),
              ],
            ),
          ),

          // 4. Watermark "20DETIK" (Pojok Kanan Atas)
          Positioned(
            top: 70,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '20DETIK',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),

          // 5. Tombol Interaksi Kanan (Samping)
          Positioned(
            right: 16,
            bottom: 40,
            child: Column(
              children: [
                _buildActionButton(Icons.thumb_up_outlined, ''),
                const SizedBox(height: 20),
                _buildActionButton(Icons.thumb_down_outlined, ''),
                const SizedBox(height: 20),
                _buildActionButton(Icons.bookmark_border, ''),
                const SizedBox(height: 20),
                // Fitur Komentar Bottom Sheet
                GestureDetector(
                  onTap: () => _showCommentSheet(context),
                  child: _buildActionButton(Icons.chat_bubble_outline, ''),
                ),
                const SizedBox(height: 20),
                _buildActionButton(Icons.share_outlined, 'Share'),
                const SizedBox(height: 20),
                _buildActionButton(Icons.info_outline, 'Caption'),
              ],
            ),
          ),

          // 6. Informasi Kiri Bawah (Judul & Waktu dari Database)
          Positioned(
            left: 16,
            right: 90,
            bottom: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      '20DETIK',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      ' • ${widget.video.timeAgo}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.video.titleBelow,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        if (label.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// WIDGET MODULAR: BOTTOM SHEET KOMENTAR
// -----------------------------------------------------------------------------
class _CommentBottomSheet extends StatefulWidget {
  @override
  State<_CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<_CommentBottomSheet> {
  final TextEditingController _commentController = TextEditingController();

  final List<Map<String, String>> _dummyComments = [
    {'name': 'Budi Santoso', 'comment': 'Infonya sangat bermanfaat!', 'time': '5 mnt'},
    {'name': 'Siti Rahma', 'comment': 'Wah seru banget penjelasannya.', 'time': '12 mnt'},
    {'name': 'Ahmad Fauzi', 'comment': 'Mantap 20DETIK selalu update!', 'time': '20 mnt'},
    {'name': 'Rina Wijaya', 'comment': 'Menarik sekali sudut pandangnya.', 'time': '1 jam'},
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    if (_commentController.text.trim().isNotEmpty) {
      setState(() {
        _dummyComments.insert(0, {
          'name': 'Pengguna Baru',
          'comment': _commentController.text.trim(),
          'time': 'Baru saja',
        });
        _commentController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[600],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Komentar (${_dummyComments.length})',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(color: Colors.white12),
            Expanded(
              child: ListView.builder(
                itemCount: _dummyComments.length,
                itemBuilder: (context, index) {
                  final item = _dummyComments[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white24,
                          child: Icon(Icons.person, color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    item['name']!,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    item['time']!,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                item['comment']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(color: Colors.white12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Tulis komentar...',
                      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                      filled: true,
                      fillColor: const Color(0xFF262A30),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: _addComment,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}