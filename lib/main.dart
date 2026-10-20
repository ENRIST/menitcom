import 'package:flutter/material.dart';

// Import halaman utama, navbar, category, dan explore
import 'pages/home/home_page.dart';
import 'pages/nav_bar.dart';
import 'pages/category/category_page.dart';
import 'pages/explore/explore_page.dart';
import 'pages/home/news_detail_page.dart'; // Agar berita di explore bisa diklik ke detail
import 'pages/video/video_feed_page.dart';

// import "routes.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menitcom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(
          0xFF1B1E23,
        ), // Background gelap detikcom
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1B1E23),
          elevation: 0,
        ),
      ),
      home: const MainPage(),
    );
  }
}

// MainPage sebagai pembungkus yang memegang BottomNavBar dan mengganti layar
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  // Halaman-halaman yang ditampilkan sesuai tab navbar
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      // Index 0: Home
      const HomePage(),

      // Index 1: Explore (Terhubung langsung dengan ExplorePage & NewsDetailPage)
      ExplorePage(
        onNewsTap: (news) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewsDetailPage(newsId: news.id),
            ),
          );
        },
      ),

      // Index 2: Milidetik
      const Center(
        child: Text('Halaman Milidetik', style: TextStyle(color: Colors.white)),
      ),

      // Index 3: Category
      const CategoryPage(),

      // Index 4: Video
      const VideoFeedPage(showBottomNavBar: false),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
