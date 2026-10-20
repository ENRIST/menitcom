import 'package:flutter/material.dart';

import 'profile_setelah_login.dart';

class CompleteProfilePage extends StatefulWidget {
  const CompleteProfilePage({super.key, this.onFinished, this.userData});

  final VoidCallback? onFinished;

  // Data pengguna yang berhasil login.
  final Map<String, String>? userData;

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  int? birthYear;
  String? gender;

  static const blue = Color(0xFF5B8FD6);
  static const yellow = Color(0xFFFFAC00);

  void finish({required bool save}) {
    // Tahun lahir wajib dipilih jika pengguna menekan SIMPAN.
    if (save && birthYear == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih tahun lahir terlebih dahulu.'),
        ),
      );
      return;
    }

    // Ambil data asli pengguna, jika tersedia.
    final data = <String, String>{
      'nama':
          widget.userData?['nama'] ??
          widget.userData?['username'] ??
          'Pengguna Menit',
      'email': widget.userData?['email'] ?? '',
      'ponsel':
          widget.userData?['ponsel'] ?? widget.userData?['phone_number'] ?? '',
    };

    // Tambahkan tanggal lahir dan gender jika pengguna menyimpan.
    if (save) {
      data['lahir'] = birthYear.toString();

      if (gender != null) {
        data['gender'] = gender!;
      }
    }

    // Jalankan callback jika tersedia.
    if (widget.onFinished != null) {
      widget.onFinished!();
      return;
    }

    // Kirim data pengguna ke halaman profil.
    masukKeProfil(context, data);
  }

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;

    final years = List<int>.generate(
      currentYear - 1900 + 1,
      (i) => currentYear - i,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Tombol tutup.
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                onPressed: () => finish(save: false),
                icon: const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFFE9E9E9),
                  child: Icon(Icons.close, color: Color(0xFF888888)),
                ),
              ),
            ),

            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(28, 95, 28, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.app_registration_rounded,
                    color: yellow,
                    size: 145,
                  ),

                  const SizedBox(height: 35),

                  const Text(
                    'Untuk melayani Anda lebih baik, '
                    'mohon lengkapi data di bawah ini.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF9A9A9A),
                      fontSize: 18,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 40),

                  const Text(
                    'Tahun Lahir',
                    style: TextStyle(color: Color(0xFF888888), fontSize: 15),
                  ),

                  const SizedBox(height: 10),

                  DropdownButtonFormField<int>(
                    value: birthYear,
                    isExpanded: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.calendar_month_outlined),
                      hintText: 'Pilih tahun lahir',
                      filled: true,
                      fillColor: const Color(0xFFEAF4F7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    items: years.map((year) {
                      return DropdownMenuItem<int>(
                        value: year,
                        child: Text('$year'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        birthYear = value;
                      });
                    },
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Jenis Kelamin',
                    style: TextStyle(color: Color(0xFF888888), fontSize: 15),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: _GenderButton(
                          label: 'Pria',
                          selected: gender == 'Pria',
                          onTap: () {
                            setState(() {
                              gender = 'Pria';
                            });
                          },
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: _GenderButton(
                          label: 'Wanita',
                          selected: gender == 'Wanita',
                          onTap: () {
                            setState(() {
                              gender = 'Wanita';
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 48),

                  // Tombol SIMPAN.
                  SizedBox(
                    height: 58,
                    child: ElevatedButton(
                      onPressed: () => finish(save: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: yellow,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text(
                        'SIMPAN',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Tombol Nanti Saja.
                  TextButton(
                    onPressed: () => finish(save: false),
                    child: const Text(
                      'Nanti Saja',
                      style: TextStyle(
                        color: blue,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GenderButton extends StatelessWidget {
  const _GenderButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: selected
              ? const Color(0xFFD3E8F0)
              : const Color(0xFFEAF4F7),
          foregroundColor: Colors.black,
          elevation: 0,
          side: BorderSide(
            color: selected ? const Color(0xFF5B8FD6) : Colors.transparent,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 17)),
      ),
    );
  }
}
