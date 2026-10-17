import 'package:flutter/material.dart';

class LifestylePage extends StatelessWidget {
  const LifestylePage({super.key});

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

          // BERITA UTAMA LIFESTYLE (GAMBAR BESAR DI ATAS)
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
                      imageUrl: 'https://images.unsplash.com/photo-1541872703-74c5e44368f9?q=80&w=800&auto=format&fit=crop',
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Bahlil Bongkar Biang Kerok Antrean SPBU, Pajero Ikut Disorot',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'detikOto · 2 jam lalu',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // LIST BERITA BAWAH 1
          const NewsTileItem(
            title: "Demi Moore Pamer Foto Tanpa Makeup Jelang Usia 64, Wajah Glowing Banjir Pujian",
            category: "Wolipop",
            time: "3 jam lalu",
            imageUrl: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=300&auto=format&fit=crop",
          ),
          const Divider(color: Colors.white10, height: 28),

          // LIST BERITA BAWAH 2
          const NewsTileItem(
            title: "Toyota Sudah Ekspor 3 Juta Mobil Buatan Indonesia ke Mancanegara",
            category: "detikOto",
            time: "1 jam lalu",
            imageUrl: "https://images.unsplash.com/photo-1552519507-da3b142c6e3d?q=80&w=300&auto=format&fit=crop",
          ),
          const Divider(color: Colors.white10, height: 28),

          // LIST BERITA BAWAH TAMBAHAN 3
          const NewsTileItem(
            title: "Inspirasi Desain Interior Minimalis Modern untuk Rumah Tipe 36",
            category: "Wolipop",
            time: "5 jam lalu",
            imageUrl: "https://images.unsplash.com/photo-1618221195710-dd6b41faaea6?q=80&w=300&auto=format&fit=crop",
          ),
          const SizedBox(height: 24),

          // BANNER IKLAN BAWAH (MENYERUPAI REFERENSI)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: const Color(0xFF262A30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 180,
                      width: double.infinity,
                      child: NetworkImageWidget(
                        imageUrl: "https://images.unsplash.com/photo-1584515979956-d9f6e5d09982?q=80&w=600&auto=format&fit=crop",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: const Text(
                        '3 Alasan Penting Pastikan Air Minum untuk Keluarga Bebas BPA',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
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
// WIDGET CUSTOM NETWORK IMAGE (UNTUK MEMUAT URL GAMBAR)
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
// WIDGET ITEM LIST BERITA LIFESTYLE
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
                const SizedBox(height: 10),
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
              width: 90,
              height: 75,
              child: NetworkImageWidget(imageUrl: imageUrl),
            ),
          ),
        ],
      ),
    );
  }
}
