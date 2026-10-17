import 'package:flutter/material.dart';

class RekomendasiPage extends StatelessWidget {
  const RekomendasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HASHTAG BANNER
          Container(
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
          ),
          const SizedBox(height: 16),

          // BERITA UTAMA REKOMENDASI (GAMBAR HIGHLIGHT UTAMA)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: const SizedBox(
                    height: 210,
                    width: double.infinity,
                    child: NetworkImageWidget(
                      imageUrl: 'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?q=80&w=800&auto=format&fit=crop',
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Jasad Abuzala Dibawa Berkeliling Sukabumi Sebelum Dibuang di Tol Bocimi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Jabar · 22 jam lalu',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),

          // JARAK ANTARA HIGHLIGHT DAN LIST BERITA
          const SizedBox(height: 20),

          // LIST BERITA LAINNYA (BERITA 1)
          const NewsTileItem(
            title:
                "Apa Itu Standalone Market? Status Pasar Modal yang Bayangi RI",
            category: "Finance",
            time: "16 Oktober 2026",
            imageUrl: "https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?q=80&w=300&auto=format&fit=crop",
          ),
          const Divider(color: Colors.white10, height: 28),

          // LIST BERITA LAINNYA (BERITA 2)
          const NewsTileItem(
            title: "Bahlil Sindir Bakrie di Depan Muka: Kawan Ini Tidak Paham-paham Juga",
            category: "Finance",
            time: "13 Oktober 2026",
            imageUrl: "https://images.unsplash.com/photo-1551836022-d5d88e9218df?q=80&w=300&auto=format&fit=crop",
          ),
          const Divider(color: Colors.white10, height: 28),

          // BERITA TAMBAHAN 1 (BERITA 3)
          const NewsTileItem(
            title:
                "Pemerintah Resmi Naikkan Insentif Kendaraan Listrik Tahun Ini",
            category: "Otomotif",
            time: "10 Oktober 2026",
            imageUrl: "https://images.unsplash.com/photo-1558981806-ec527fa84c39?q=80&w=300&auto=format&fit=crop",
          ),
          const Divider(color: Colors.white10, height: 28),

          // BERITA TAMBAHAN 2 (BERITA 4)
          const NewsTileItem(
            title:
                "Tips Investasi Emas bagi Pemula Agar Aman dari Inflasi Global",
            category: "Finance",
            time: "8 Oktober 2026",
            imageUrl: "https://images.unsplash.com/photo-1610375461246-83df859d849d?q=80&w=300&auto=format&fit=crop",
          ),

          const SizedBox(height: 24),

          // BANNER MPC
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFC107),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      'mpc',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Yuk! Registrasi di MPC',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// WIDGET KHUSUS CUSTOM NETWORK IMAGE
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

// -----------------------------------------------------------------------------
// WIDGET ITEM LIST BERITA DENGAN PADDING LEBIH RENGGANG
// -----------------------------------------------------------------------------
class NewsTileItem extends StatelessWidget {
  final String title;
  final String category;
  final String time;
  final String imageUrl;

  const NewsTileItem({
    super.key,
    required this.title,
    required this.category,
    required this.time,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Padding vertikal ditambahkan menjadi 4 agar jarak antar baris berita tidak dempet
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
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
                    height: 1.35,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10), // Diperbesar dari 8 ke 10 agar teks kategori tidak terlalu mepet
                Text(
                  '$category · $time',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 85,
              height: 85,
              child: NetworkImageWidget(imageUrl: imageUrl),
            ),
          ),
        ],
      ),
    );
  }
}
