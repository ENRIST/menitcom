import 'package:flutter/material.dart';

class PopulerPage extends StatelessWidget {
  const PopulerPage({super.key});

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
          const SizedBox(height: 12),

          // LIST BERITA POPULER (DENGAN NOMOR URUT DAN GAMBAR URL)
          _buildPopulerItem(
            number: '1',
            title: "Trump Gunakan Nama 'Mohammad' untuk Jadi Bahan Candaan",
            category: "detikNews",
            time: "2 jam lalu",
            imageUrl: "https://images.unsplash.com/photo-1540910419892-4a36d2c3266c?q=80&w=300&auto=format&fit=crop",
          ),
          const Divider(color: Colors.white10, height: 28),

          _buildPopulerItem(
            number: '2',
            title: "Ini Alasan Prabowo Kumpulkan Semua Anggota Kabinet di Istana Bogor Semalam",
            category: "detikNews",
            time: "1 jam lalu",
            imageUrl: "https://images.unsplash.com/photo-1507679799987-c73779587ccf?q=80&w=300&auto=format&fit=crop",
          ),
          const Divider(color: Colors.white10, height: 28),

          _buildPopulerItem(
            number: '3',
            title: "Saham-saham yang Dibeli Adik Eks Kepala BNPB dari Dana Bencana",
            category: "detikNews",
            time: "42 menit lalu",
            imageUrl: "https://images.unsplash.com/photo-1611974789855-9c2a0a7236a3?q=80&w=300&auto=format&fit=crop",
          ),
          const Divider(color: Colors.white10, height: 28),

          // BERITA POPULER TAMBAHAN 4
          _buildPopulerItem(
            number: '4',
            title:
                "Daftar Harga BBM Terbaru di Seluruh SPBU Pertamina Hari Ini",
            category: "detikFinance",
            time: "3 jam lalu",
            imageUrl: "https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?q=80&w=300&auto=format&fit=crop",
          ),
          const Divider(color: Colors.white10, height: 28),

          // BERITA POPULER TAMBAHAN 5
          _buildPopulerItem(
            number: '5',
            title: "Timnas Indonesia Gelar Latihan Perdana Jelang Lanjutan Kualifikasi Piala Dunia",
            category: "detikSport",
            time: "4 jam lalu",
            imageUrl: "https://images.unsplash.com/photo-1508098682722-e99c43a406b2?q=80&w=300&auto=format&fit=crop",
          ),
          const SizedBox(height: 24),

          // BANNER IKLAN BAWAH (MENYERupai REFERENSI AIR MINUM)
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

  Widget _buildPopulerItem({
    required String number,
    required String title,
    required String category,
    required String time,
    required String imageUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // NOMOR URUT
          SizedBox(
            width: 32,
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 4),
          // JUDUL & KATEGORI
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  '$category · $time',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          // THUMBNAIL GAMBAR URL (DIPERBESAR SEDIKIT KE BAWAH)
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
