import 'package:flutter/material.dart';

import 'category_data.dart';

class CategoryNewsPage extends StatelessWidget {
  final CategoryItemModel category;

  const CategoryNewsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // Jumlah tab
      child: Scaffold(
        backgroundColor: kBgColor, // Background abu-abu terang
        appBar: AppBar(
          backgroundColor: kCardColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          // Mockup Logo Detik (bisa diganti Image.asset nanti)
          title: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              children: [
                const TextSpan(
                  text: 'menit',
                  style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                ),
                TextSpan(
                  text: category.label.toLowerCase(),
                  style: const TextStyle(
                    color: Color.fromARGB(255, 33, 140, 243),
                  ),
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
        body: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            // ===== BERITA UTAMA (Kartu Besar) =====
            _buildFeaturedNews(category),
            const SizedBox(height: 16),

            // ===== LIST BERITA =====
            _buildListNews(
              "Pemulihan Pascabencana Bener Meriah, Anggaran Terserap Capai Rp 7 Miliar",
            ),
            const SizedBox(height: 16),

            // ===== BANNER IKLAN (Mockup) =====
            Container(
              width: double.infinity,
              height: 250,
              color: const Color(0xFF2C313A),
              child: const Center(
                child: Text(
                  'Iklan - Scroll untuk melanjutkan',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ===== LIST BERITA LAGI =====
            _buildListNews(
              "Satu Tahun Danantara Indonesia TRUST: Dari Komitmen Menjadi Aksi",
            ),
            const SizedBox(height: 16),
            _buildListNews(
              "Trump Gunakan Nama 'Mohammad' untuk Jadi Bahan Candaan",
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk kartu berita utama (gambar besar)
  Widget _buildFeaturedNews(CategoryItemModel category) {
    return Container(
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
            'https://picsum.photos/600/400', // Gambar dummy
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Vonis Jadi 9 Tahun Penjara, Nadiem Makarim Ajukan Kasasi",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'menit${category.label}', // Dinamis mengikuti ikon yang diklik
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk list berita (teks kiri, gambar kanan)
  Widget _buildListNews(String title) {
    return Row(
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
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'menitNews • 5 menit lalu',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            'https://picsum.photos/150/100',
            width: 100,
            height: 70,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}
