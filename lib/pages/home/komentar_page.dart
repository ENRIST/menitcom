import 'package:flutter/material.dart';

class KomentarPage extends StatelessWidget {
  const KomentarPage({super.key});

  // Fungsi untuk menampilkan Bottom Sheet daftar artikel ramai dikomentari
  void _showArtikelLainBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E2127),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.85,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 10),
                // HANDLE BAR ATAS (GARIS PUTIH)
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white38,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),

                // JUDUL BOTTOM SHEET (SELURUH AREA BISA DIKLIK UNTUK MENUTUP)
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Artikel lain yang ramai dikomentari',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(color: Colors.white10, height: 1),

                // DAFTAR ARTIKEL LAIN (2 s/d 8)
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    children: [
                      _buildBottomArticleItem(
                        '2',
                        'Israel Tolak Pilot WNI Mendarat, Kemlu RI Bereaksi',
                      ),
                      _buildBottomArticleItem(
                        '3',
                        'Eks Ketua KPU Sindir Doli-Arsul soal PKPU 19/2023: Lupa Boleh, Munafik Jangan',
                      ),
                      _buildBottomArticleItem(
                        '4',
                        'Pengumuman! Warga RI Bakal Dapat HP Gratis, Ini Bocorannya',
                      ),
                      _buildBottomArticleItem(
                        '5',
                        'Andi Arief: Yang Butuh Pansus DPR itu Gibran',
                      ),
                      _buildBottomArticleItem(
                        '6',
                        'Bos Bursa soal Pengumuman MSCI: Standalone Market Bukan Kasta Terendah!',
                      ),
                      _buildBottomArticleItem(
                        '7',
                        "Perbandingan Dulu dan Kini Ucapan Jokowi soal 'Prabowo Gibran 2 Periode'",
                      ),
                      _buildBottomArticleItem('8', 'Indonesia Kena Prank MSCI'),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildBottomArticleItem(String number, String title) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 28,
                child: Text(
                  number,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(color: Colors.white10, height: 1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HASHTAG BANNER
              Container(
                width: double.infinity,
                color: const Color(0xFF262A30),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: const Text(
                  '#DPD RI Awards',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // HEADER BERITA UTAMA & TOMBOL LIHAT KOMENTAR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 28,
                          child: Text(
                            '1',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                "MUI Soroti Rekam Jejak Andrea Bocelli, Desak Konser di Indonesia Dibatalkan",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  height: 1.35,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 6),
                              Text(
                                'detikHikmah · 10 Oktober 2026',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: const SizedBox(
                            width: 80,
                            height: 70,
                            child: NetworkImageWidget(
                              imageUrl: "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?q=80&w=300&auto=format&fit=crop",
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Padding(
                      padding: const EdgeInsets.only(left: 36),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF383C44),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Lihat 221 komentar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              const Divider(color: Colors.white10, height: 1),
              const SizedBox(height: 16),

              // TIMELINE KOMENTAR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildCommentTimelineItem(
                      username: "BocorAlueseeee",
                      time: "3 Jam yang lalu",
                      content: "Yg penting cabulers2 di pesantren gak di pesantren gak dilarang sm MUI...",
                      avatarWidget: const CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          "https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?q=80&w=200&auto=format&fit=crop",
                        ),
                      ),
                      isLast: false,
                    ),
                    _buildCommentTimelineItem(
                      username: "Zackih",
                      time: "6 Jam yang lalu",
                      content: "Andrea setiap konser menggalang dana untuk IDF Israel yg telah membunuh warga Palestina.. Anda paham???",
                      avatarWidget: const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.red,
                        child: Text(
                          'Z',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      isLast: false,
                    ),
                    _buildCommentTimelineItem(
                      username: "Darma Putra",
                      time: "6 Jam yang lalu",
                      content: "Andrea Bocelli musisi yg menginspirasi dunia. Cacat fisik tidak menjadi batasan untuk menyerah. bahkan terus berjuang menjadi musisi top dunia...",
                      avatarWidget: const CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0xFFE65100),
                        child: Text(
                          'DP',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // FLOATING BAR DI BAGIAN BAWAH
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => _showArtikelLainBottomSheet(context),
            child: Container(
              color: const Color(0xFF1E2127),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Artikel lain yang ramai dikomentari',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.keyboard_arrow_down, // Menggunakan panah bawah sesuai kondisi panel terbuka
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentTimelineItem({
    required String username,
    required String time,
    required String content,
    required Widget avatarWidget,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              avatarWidget,
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.white38,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
