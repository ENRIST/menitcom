import 'package:flutter/material.dart';

// Import halaman utama dan navbar dari folder pages
import 'pages/home_page.dart';
import 'pages/nav_bar.dart';

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
      // initialRoute: AppRoutes.login,
      // routes: AppRoutes.routes,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(
          0xFF1B1E23,
        ), // Background gelap detikcom
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1B1E23),
          elevation: 0,
        ),
      ),
      home: const MainPage(), // <--- Menambahkan home ke MainPage
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

  // Halaman-halaman yang ditampilkan sesuai tab
  final List<Widget> _pages = [
    const HomePage(),
    const Center(
      child: Text('Halaman Explore', style: TextStyle(color: Colors.white)),
    ),
    const Center(
      child: Text('Halaman Milidetik', style: TextStyle(color: Colors.white)),
    ),
    const Center(
      child: Text('Halaman Category', style: TextStyle(color: Colors.white)),
    ),
    const Center(
      child: Text('Halaman Video', style: TextStyle(color: Colors.white)),
    ),
  ];

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
