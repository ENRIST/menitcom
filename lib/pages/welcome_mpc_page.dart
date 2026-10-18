import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'complete_profile_page.dart';

class WelcomeMpcPage extends StatelessWidget {
  const WelcomeMpcPage({
    super.key,
    this.onProfileComplete,
    this.onActivateAlloBank,
  });

  final VoidCallback? onProfileComplete;
  final VoidCallback? onActivateAlloBank;

  static const yellow = Color(0xFFFFBD25);
  static const orange = Color(0xFFF2A000);

  // Lanjut ke halaman pelengkapan profil.
  void goNext(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CompleteProfilePage(onFinished: onProfileComplete),
      ),
    );
  }

  // Membuka halaman unduhan Allo Bank.
  Future<void> _openAlloBank(BuildContext context) async {
    final Uri url;

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      url = Uri.parse('https://apps.apple.com/id/app/allo-bank/id1591223632');
    } else {
      url = Uri.parse(
        'https://play.google.com/store/apps/details?id=com.alloapp.yump',
      );
    }

    try {
      final opened = await launchUrl(url, mode: LaunchMode.externalApplication);

      if (!opened && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak dapat membuka halaman unduhan Allo Bank.'),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Terjadi kesalahan saat membuka Allo Bank.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 42, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 35),

              const Icon(Icons.celebration_rounded, color: yellow, size: 160),

              const SizedBox(height: 25),

              const Text(
                'Selamat datang di MPC!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Akunmu sudah siap digunakan',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 14),

              const Text(
                'Nikmati semua fitur di ekosistem CT Corp.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF777777), fontSize: 17),
              ),

              const SizedBox(height: 32),

              // Informasi Allo Bank.
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE9AE),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sekalian aktifkan Allo Bank?',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 12),

                    Text(
                      'Transaksi mudah, banyak untung',
                      style: TextStyle(fontSize: 17),
                    ),

                    SizedBox(height: 8),

                    Text('•  Bunga 2%', style: TextStyle(fontSize: 16)),

                    SizedBox(height: 5),

                    Text('•  Promo & poin', style: TextStyle(fontSize: 16)),

                    SizedBox(height: 5),

                    Text('•  Kejutan hadiah', style: TextStyle(fontSize: 16)),

                    SizedBox(height: 12),

                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        'allobank',
                        style: TextStyle(
                          color: Color(0xFFE5A000),
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Informasi persetujuan.
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.verified_user, color: orange, size: 28),

                  SizedBox(width: 14),

                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(fontSize: 15, height: 1.45),
                        children: [
                          TextSpan(
                            text: 'Dengan mengaktifkan, kamu menyetujui ',
                          ),

                          TextSpan(
                            text: 'Syarat penggunaan',
                            style: TextStyle(
                              color: orange,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          TextSpan(text: ' & '),

                          TextSpan(
                            text: 'Kebijakan privasi.',
                            style: TextStyle(
                              color: orange,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Tombol aktifkan Allo Bank.
              SizedBox(
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    if (onActivateAlloBank != null) {
                      onActivateAlloBank!();
                    } else {
                      _openAlloBank(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellow,
                    foregroundColor: const Color(0xFF292929),
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    'Aktifkan Allo Bank',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // Lanjut ke halaman tahun lahir dan jenis kelamin.
              SizedBox(
                height: 58,
                child: OutlinedButton(
                  onPressed: () => goNext(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF333333),
                    side: const BorderSide(
                      color: Color(0xFFE6CF7A),
                      width: 1.5,
                    ),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    'Lewati & selesai',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
