import 'package:flutter/material.dart';
import 'register_page.dart';

class MpcIntroPage extends StatelessWidget {
  const MpcIntroPage({super.key});

  static const Color yellow = Color(0xFFFFBE24);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF303030),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 26, 30, 38),
          child: Column(
            children: [
              const Spacer(flex: 3),
              const _MpcEcosystemIllustration(),
              const SizedBox(height: 70),
              const Text(
                'Satu akun untuk semua kesenangan!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Sekarang anda bisa mengakses semua ekosistem CT Corp hanya dengan satu akun MPC.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  height: 1.6,
                ),
              ),
              const Spacer(flex: 4),
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellow,
                    foregroundColor: const Color(0xFF343434),
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    'Mulai',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
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

class _MpcEcosystemIllustration extends StatelessWidget {
  const _MpcEcosystemIllustration();

  Widget _badge(IconData icon, {double size = 70, Color color = Colors.white}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(color: Color(0x26000000), blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Icon(icon, size: size * 0.55, color: const Color(0xFFFFB91D)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(left: 14, top: 10, child: _badge(Icons.workspace_premium, size: 82)),
          Positioned(right: 12, top: 10, child: _badge(Icons.monetization_on, size: 82, color: const Color(0xFFFFC32D))),
          Positioned(left: 8, bottom: 16, child: _badge(Icons.card_giftcard, size: 82)),
          Positioned(right: 8, bottom: 16, child: _badge(Icons.stars, size: 82)),
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: const Color(0xFF24252A),
              borderRadius: BorderRadius.circular(34),
              boxShadow: const [
                BoxShadow(color: Color(0x55000000), blurRadius: 14, offset: Offset(0, 8)),
              ],
            ),
            child: const Icon(Icons.person, size: 105, color: Colors.white),
          ),
          Positioned(
            right: 72,
            bottom: 72,
            child: Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: Color(0xFFFFBE24),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 36),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'register_page.dart';

class MpcIntroPage extends StatelessWidget {
  const MpcIntroPage({super.key});

  static const Color yellow = Color(0xFFFFBE24);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF303030),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 26, 30, 38),
          child: Column(
            children: [
              const Spacer(flex: 3),
              const _MpcEcosystemIllustration(),
              const SizedBox(height: 70),
              const Text(
                'Satu akun untuk semua kesenangan!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Sekarang anda bisa mengakses semua ekosistem CT Corp hanya dengan satu akun MPC.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  height: 1.6,
                ),
              ),
              const Spacer(flex: 4),
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellow,
                    foregroundColor: const Color(0xFF343434),
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    'Mulai',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
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

class _MpcEcosystemIllustration extends StatelessWidget {
  const _MpcEcosystemIllustration();

  Widget _badge(IconData icon, {double size = 70, Color color = Colors.white}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(color: Color(0x26000000), blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Icon(icon, size: size * 0.55, color: const Color(0xFFFFB91D)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(left: 14, top: 10, child: _badge(Icons.workspace_premium, size: 82)),
          Positioned(right: 12, top: 10, child: _badge(Icons.monetization_on, size: 82, color: const Color(0xFFFFC32D))),
          Positioned(left: 8, bottom: 16, child: _badge(Icons.card_giftcard, size: 82)),
          Positioned(right: 8, bottom: 16, child: _badge(Icons.stars, size: 82)),
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: const Color(0xFF24252A),
              borderRadius: BorderRadius.circular(34),
              boxShadow: const [
                BoxShadow(color: Color(0x55000000), blurRadius: 14, offset: Offset(0, 8)),
              ],
            ),
            child: const Icon(Icons.person, size: 105, color: Colors.white),
          ),
          Positioned(
            right: 72,
            bottom: 72,
            child: Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: Color(0xFFFFBE24),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 36),
            ),
          ),
        ],
      ),
    );
  }
}
