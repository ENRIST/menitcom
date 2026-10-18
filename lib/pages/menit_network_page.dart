import 'package:flutter/material.dart';

import 'mpc_intro_page.dart';
import 'login_phone_page.dart';

class MenitNetworkPage extends StatelessWidget {
  const MenitNetworkPage({super.key, required this.fromProfileLogin});

  final bool fromProfileLogin;

  static const Color blue = Color(0xFF5B8FD6);
  static const Color orange = Color(0xFFFFAC00);

  @override
  Widget build(BuildContext context) {
    final registerButtonText = fromProfileLogin ? 'BUAT AKUN MPC' : 'REGISTER';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 1,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 110),
                    const _RegisterIllustration(),
                    const SizedBox(height: 70),

                    if (!fromProfileLogin) ...[
                      const Text(
                        'REGISTER',
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 29,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 38),
                    ],
                    const Text(
                      'menitNetwork adalah bagian dari CT Corp.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFFA5A5A5), fontSize: 18),
                    ),
                    const SizedBox(height: 42),
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                          color: Color(0xFFA5A5A5),
                          fontSize: 18,
                          height: 1.55,
                        ),
                        children: [
                          TextSpan(text: 'Satu akun '),
                          TextSpan(
                            text: 'MPC',
                            style: TextStyle(
                              color: blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: ' untuk beraktivitas di semua layanan CT Corp dan Allo Bank.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Pelajari lebih lanjut.',
                      style: TextStyle(
                        color: blue,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 44),
                    SizedBox(
                      width: double.infinity,
                      height: 62,
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MpcIntroPage(),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: orange,
                          foregroundColor: Colors.black,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text(
                          registerButtonText,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 62,
                      child: OutlinedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginPhonePage(),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: const BorderSide(
                            color: Color(0xFFE6C66E),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 72),
                    const Text(
                      'Untuk bantuan daftar dan masuk,',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFFA5A5A5), fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                          color: Color(0xFFA5A5A5),
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(text: 'email ke '),
                          TextSpan(
                            text: 'info@menit.com',
                            style: TextStyle(
                              color: blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RegisterIllustration extends StatelessWidget {
  const _RegisterIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 220,
            height: 165,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0D7),
              borderRadius: BorderRadius.circular(70),
            ),
          ),
          Positioned(
            bottom: 20,
            child: Container(
              width: 180,
              height: 115,
              decoration: BoxDecoration(
                color: const Color(0xFFFFAC00),
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          Positioned(
            bottom: 26,
            child: Container(
              width: 158,
              height: 92,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Align(
                alignment: Alignment(0, 0.45),
                child: Icon(
                  Icons.password_rounded,
                  color: Color(0xFFFFAC00),
                  size: 64,
                ),
              ),
            ),
          ),
          Positioned(
            top: 28,
            child: Container(
              width: 82,
              height: 82,
              decoration: const BoxDecoration(
                color: Color(0xFF4D83E6),
                shape: BoxShape.circle,
                border: Border.fromBorderSide(
                  BorderSide(color: Colors.white, width: 4),
                ),
              ),
              child: const Icon(
                Icons.person,
                color: Color(0xFFFFAC00),
                size: 54,
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            child: Container(
              width: 190,
              height: 15,
              decoration: BoxDecoration(
                color: const Color(0xFF333333),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
