import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: CustomAppBar(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            CategoryTabBar(),
            HashtagBanner(),
            SizedBox(height: 12),
            StoriesSection(),
            SizedBox(height: 16),
            FeaturedVideoCard(),
            SizedBox(height: 16),
            NewsListItem(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// WIDGET-WIDGET TAMPILAN HOME
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

class StoriesSection extends StatelessWidget {
  const StoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            width: 110,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: const DecorationImage(
                image: NetworkImage('https://picsum.photos/200/300'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.7),
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
                const Positioned(
                  bottom: 10,
                  left: 8,
                  right: 8,
                  child: Text(
                    'Judul Singkat Story atau Video',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
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
                  Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.black,
                    child: Center(
                      child: Image.network(
                        'https://picsum.photos/500/300',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
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
            child: Image.network(
              'https://picsum.photos/120/80',
              width: 90,
              height: 65,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
