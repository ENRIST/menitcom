import 'package:flutter/material.dart';

import 'mpc_logo.dart';
import 'login_password_page.dart';

class LoginPhonePage extends StatefulWidget {
  const LoginPhonePage({super.key});

  @override
  State<LoginPhonePage> createState() => _LoginPhonePageState();
}

class _LoginPhonePageState extends State<LoginPhonePage> {
  final TextEditingController _phoneController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _continue() {
    final phone = _phoneController.text.trim();

    if (phone.isEmpty || phone.length < 8) {
      setState(() {
        _error = 'Masukkan nomor telepon yang valid.';
      });
      return;
    }

    setState(() {
      _error = null;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoginPasswordPage(phoneNumber: '+62 $phone'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const yellow = Color(0xFFFFBE24);
    const orange = Color(0xFFD98A32);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 62,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(Icons.arrow_back, size: 30),
                    ),
                  ),
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(30, 68, 30, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MpcLogo(size: 112),

                    const SizedBox(height: 65),

                    const Text(
                      'Sekarang cukup satu akun MPC untuk menikmati semua benefit di ekosistem CT Corp.',
                      style: TextStyle(
                        color: Color(0xFF707780),
                        fontSize: 16,
                        height: 1.45,
                      ),
                    ),

                    const SizedBox(height: 28),

                    Container(
                      height: 76,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFDADADA),
                          width: 1.4,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            '+62',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(width: 7),

                          const Icon(
                            Icons.arrow_drop_down,
                            size: 28,
                            color: Color(0xFF66717D),
                          ),

                          const SizedBox(width: 4),

                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              onChanged: (_) {
                                if (_error != null) {
                                  setState(() {
                                    _error = null;
                                  });
                                }
                              },
                              decoration: const InputDecoration(
                                hintText: 'Nomor telepon',
                                hintStyle: TextStyle(
                                  color: Color(0xFF969EA8),
                                  fontSize: 19,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (_error != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: const TextStyle(
                          color: Color(0xFFBE6660),
                          fontSize: 14,
                        ),
                      ),
                    ],

                    const SizedBox(height: 12),

                    const Text(
                      'Kode verifikasi akan dikirim lewat aplikasi WhatsApp.',
                      style: TextStyle(color: Color(0xFF707780), fontSize: 14),
                    ),

                    const SizedBox(height: 22),

                    SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: ElevatedButton(
                        onPressed: _continue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: yellow,
                          foregroundColor: const Color(0xFF3D3D3D),
                          elevation: 0,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text(
                          'Lanjutkan',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF66717D),
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(text: 'Belum menjadi anggota MPC? '),
                    TextSpan(
                      text: 'Daftar di sini',
                      style: TextStyle(color: orange),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
