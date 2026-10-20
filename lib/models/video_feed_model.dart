class VideoFeedModel {
  final String id;
  final String? titleOverlay;
  final String titleBelow;   
  final String duration;
  final String timeAgo;
  final String thumbnailUrl;

  const VideoFeedModel({
    required this.id,
    this.titleOverlay,
    required this.titleBelow,
    required this.duration,
    required this.timeAgo,
    required this.thumbnailUrl,
  });

  factory VideoFeedModel.fromJson(Map<String, dynamic> json) {
    return VideoFeedModel(
      id: json['story_id'].toString(), // Membaca story_id dari MySQL
      titleOverlay: null,
      titleBelow: json['title'] ?? 'Judul Tidak Tersedia', // Membaca title dari MySQL
      duration: '00:00',
      timeAgo: json['time_ago'] ?? '-', // Membaca time_ago dari MySQL
      thumbnailUrl: 'https://images.unsplash.com/photo-1542282088-fe8426682b8f?w=800&q=80',
    );
  }
}