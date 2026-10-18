class NewsModel {
  final int newsId;
  final String title;
  final String categoryName;
  final String imageUrl;
  final String imageCaption;
  final String content;
  final String publishedAt;
  final String authorName;

  NewsModel({
    required this.newsId,
    required this.title,
    required this.categoryName,
    required this.imageUrl,
    required this.imageCaption,
    required this.content,
    required this.publishedAt,
    required this.authorName,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      newsId: json['news_id'],
      title: json['title'] ?? '',
      categoryName: json['category_name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      imageCaption: json['image_caption'] ?? '',
      content: json['content'] ?? '',
      publishedAt: json['published_at'] ?? '',
      authorName: json['author_name'] ?? 'Redaksi',
    );
  }
}
