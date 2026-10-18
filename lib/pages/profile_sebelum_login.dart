import 'package:flutter/material.dart';

import 'menit_network_page.dart';

// Warna utama aplikasi
const Color kPrimary = Color(0xFF22409A);

// Pengaturan tema aplikasi
final ValueNotifier<ThemeMode> modeTema = ValueNotifier<ThemeMode>(
  ThemeMode.light,
);

// Menampilkan notifikasi singkat
void showSnack(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}

// ======================================================
// HALAMAN PROFIL SEBELUM LOGIN
// ======================================================

class ProfilSebelumLogin extends StatefulWidget {
  const ProfilSebelumLogin({super.key});

  @override
  State<ProfilSebelumLogin> createState() => _ProfilSebelumLoginState();
}

class _ProfilSebelumLoginState extends State<ProfilSebelumLogin> {
  bool _pushNotif = true;

  // Navigasi ke halaman Menit Network untuk Sign In
  void _signIn() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MenitNetworkPage(fromProfileLogin: true),
      ),
    );
  }

  // Navigasi ke halaman Menit Network untuk Daftar
  void _daftar() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MenitNetworkPage(fromProfileLogin: false),
      ),
    );
  }

  // Pesan untuk fitur yang membutuhkan login
  void _perluLogin() {
    showSnack(context, 'Silakan Sign In dulu');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: ListView(
        children: [
          // Judul halaman
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Profil',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800),
            ),
          ),

          const SizedBox(height: 24),

          // Foto profil dan tombol login
          Column(
            children: [
              ClipOval(
                child: Container(
                  width: 92,
                  height: 92,
                  color: Colors.grey.shade300,
                  alignment: Alignment.bottomCenter,
                  child: Icon(
                    Icons.person,
                    size: 100,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: _signIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 10,
                  ),
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Belum daftar? ', style: TextStyle(fontSize: 16)),
                  GestureDetector(
                    onTap: _daftar,
                    child: const Text(
                      'Daftar',
                      style: TextStyle(
                        fontSize: 16,
                        color: kPrimary,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          const SectionDivider(),

          // Pengaturan aplikasi
          const SectionTitle('Settings'),

          const SettingTile(
            icon: Icons.brightness_6_outlined,
            title: 'Mode',
            trailing: ModeSelector(),
          ),

          SettingTile(
            icon: Icons.account_circle_outlined,
            title: 'Personal Information',
            onTap: _perluLogin,
          ),

          SettingTile(
            icon: Icons.notifications_none,
            title: 'Notifications List',
            onTap: _perluLogin,
          ),

          SettingTile(
            icon: Icons.notifications_active_outlined,
            title: 'Push Notifications',
            trailing: Switch(
              value: _pushNotif,
              activeColor: Colors.white,
              activeTrackColor: kPrimary,
              onChanged: (value) {
                setState(() {
                  _pushNotif = value;
                });
              },
            ),
          ),

          SettingTile(
            icon: Icons.bookmark_border,
            title: 'Bookmark',
            onTap: _perluLogin,
          ),

          const SectionDivider(),

          // Pengaturan TV
          const SectionTitle('TV'),

          SettingTile(
            icon: Icons.qr_code_scanner,
            title: 'Connect to TV / Scan QR',
            onTap: () {
              showSnack(context, 'Buka: Connect to TV');
            },
          ),

          const SectionDivider(),

          // Versi aplikasi
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            child: Text(
              'Version 7.12.0 (1)',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// JUDUL BAGIAN
// ======================================================

class SectionTitle extends StatelessWidget {
  final String text;

  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
      ),
    );
  }
}

// ======================================================
// PEMISAH BAGIAN
// ======================================================

class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 2,
      thickness: 2,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white12
          : Colors.grey.shade200,
    );
  }
}

// ======================================================
// BARIS PENGATURAN
// ======================================================

class SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? color;

  const SettingTile({
    super.key,
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 26, color: color ?? Colors.grey.shade700),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),

            trailing ??
                Icon(
                  Icons.chevron_right,
                  size: 30,
                  color: color ?? Colors.grey.shade600,
                ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// PEMILIH MODE TEMA
// ======================================================

class ModeSelector extends StatelessWidget {
  const ModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget chip(String label, ThemeMode mode) {
      final selected = modeTema.value == mode;

      return GestureDetector(
        onTap: () {
          modeTema.value = mode;
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: selected
                ? kPrimary
                : (isDark ? Colors.grey.shade800 : Colors.white),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: selected ? Colors.white : Colors.grey.shade500,
            ),
          ),
        ),
      );
    }

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: modeTema,
      builder: (context, _, __) {
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isDark ? Colors.white12 : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              chip('Auto', ThemeMode.system),
              const SizedBox(width: 4),
              chip('Day', ThemeMode.light),
              const SizedBox(width: 4),
              chip('Night', ThemeMode.dark),
            ],
          ),
        );
      },
    );
  }
}
