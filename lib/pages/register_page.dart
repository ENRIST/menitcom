import 'package:flutter/material.dart';

import 'mpc_logo.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _agree = false;
  bool _submitted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  bool get _hasUpper => _passwordController.text.contains(RegExp(r'[A-Z]'));
  bool get _hasLower => _passwordController.text.contains(RegExp(r'[a-z]'));
  bool get _hasNumber => _passwordController.text.contains(RegExp(r'[0-9]'));
  bool get _hasLength => _passwordController.text.length >= 8;

  bool get _canSubmit =>
      _nameController.text.trim().isNotEmpty &&
      _phoneController.text.trim().length >= 8 &&
      _emailController.text.contains('@') &&
      _hasUpper &&
      _hasLower &&
      _hasNumber &&
      _hasLength &&
      _confirmController.text == _passwordController.text &&
      _agree;

  // Fungsi registrasi ke backend
  Future<void> _register() async {
    if (_isLoading) return;

    setState(() {
      _submitted = true;
    });

    if (!_canSubmit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lengkapi formulir dan persetujuan terlebih dahulu.'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Membersihkan format nomor telepon.
    // Contoh: 08123456789 menjadi +628123456789
    String phone = _phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (phone.startsWith('0')) {
      phone = phone.substring(1);
    } else if (phone.startsWith('62')) {
      phone = phone.substring(2);
    }

    phone = '+62$phone';

    try {
      final response = await http
          .post(
            Uri.parse('http://localhost:3000/api/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'username': _nameController.text.trim(),
              'phone_number': phone,
              'email': _emailController.text.trim(),
              'password': _passwordController.text,
            }),
          )
          .timeout(const Duration(seconds: 15));

      Map<String, dynamic> result = {};

      try {
        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic>) {
          result = decoded;
        }
      } catch (_) {
        // Respons server bukan JSON.
      }

      if (!mounted) return;

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message']?.toString() ??
                  'Registrasi berhasil. Akun berhasil dibuat.',
            ),
          ),
        );

        // Kembali ke halaman sebelumnya setelah registrasi berhasil.
        Navigator.maybePop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message']?.toString() ??
                  result['error']?.toString() ??
                  'Registrasi gagal. Periksa data dan coba lagi.',
            ),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Tidak dapat terhubung ke server. '
            'Pastikan backend dan MySQL berjalan.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFD98A32);
    const yellow = Color(0xFFFFBE24);
    const grey = Color(0xFF929AA4);

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
                    'Registrasi',
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF333333),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const MpcLogo(size: 112),
                    const SizedBox(height: 58),
                    const Text(
                      'Selamat datang di MPC',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 8),
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 17,
                          height: 1.5,
                          color: Color(0xFF707780),
                        ),
                        children: [
                          TextSpan(
                            text:
                                'Daftar akun MPC untuk akses semua ekosistem ',
                          ),
                          TextSpan(
                            text: 'CT Corp.',
                            style: TextStyle(color: orange),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Nama lengkap
                    _input(
                      controller: _nameController,
                      hint: 'Nama lengkap (sesuai e-KTP)',
                      onChanged: (_) => setState(() {}),
                    ),

                    const SizedBox(height: 18),

                    // Nomor telepon
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
                              onChanged: (_) => setState(() {}),
                              decoration: const InputDecoration(
                                hintText: 'Nomor telepon',
                                hintStyle: TextStyle(color: grey, fontSize: 18),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Kode verifikasi akan dikirim lewat aplikasi WhatsApp.',
                      style: TextStyle(fontSize: 14, color: Color(0xFF707780)),
                    ),

                    const SizedBox(height: 18),

                    // Email
                    _input(
                      controller: _emailController,
                      hint: 'Alamat email',
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (_) => setState(() {}),
                    ),

                    const SizedBox(height: 18),

                    // Password
                    _passwordInput(
                      controller: _passwordController,
                      hint: 'Password',
                      visible: _showPassword,
                      onToggle: () =>
                          setState(() => _showPassword = !_showPassword),
                      onChanged: (_) => setState(() {}),
                    ),

                    const SizedBox(height: 22),

                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Kekuatan password',
                            style: TextStyle(
                              color: Color(0xFFAAAAAA),
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Text(
                          _passwordController.text.isEmpty
                              ? '-'
                              : (_hasUpper &&
                                        _hasLower &&
                                        _hasNumber &&
                                        _hasLength
                                    ? 'Kuat'
                                    : '–'),
                          style: const TextStyle(
                            color: Color(0xFF777777),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: LinearProgressIndicator(
                        minHeight: 5,
                        value: _passwordController.text.isEmpty
                            ? 0
                            : ([
                                    _hasUpper,
                                    _hasLower,
                                    _hasNumber,
                                    _hasLength,
                                  ].where((v) => v).length /
                                  4),
                        backgroundColor: const Color(0xFFF0F0F0),
                        valueColor: const AlwaysStoppedAnimation<Color>(yellow),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: [
                        Expanded(child: _requirement('Huruf besar', _hasUpper)),
                        Expanded(
                          child: _requirement('Mengandung angka', _hasNumber),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Expanded(child: _requirement('Huruf kecil', _hasLower)),
                        Expanded(
                          child: _requirement('Minimum 8 karakter', _hasLength),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Konfirmasi password
                    _passwordInput(
                      controller: _confirmController,
                      hint: 'Konfirmasi password',
                      visible: _showConfirmPassword,
                      onToggle: () => setState(
                        () => _showConfirmPassword = !_showConfirmPassword,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),

                    if (_submitted &&
                        _confirmController.text !=
                            _passwordController.text) ...[
                      const SizedBox(height: 8),
                      const Text(
                        'Konfirmasi password belum sama.',
                        style: TextStyle(
                          color: Color(0xFFC87570),
                          fontSize: 14,
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    // Persetujuan ketentuan
                    InkWell(
                      onTap: () => setState(() => _agree = !_agree),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            margin: const EdgeInsets.only(right: 16, top: 2),
                            decoration: BoxDecoration(
                              border: Border.all(color: yellow, width: 2),
                              borderRadius: BorderRadius.circular(6),
                              color: _agree ? yellow : Colors.white,
                            ),
                            child: _agree
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 24,
                                  )
                                : null,
                          ),
                          const Expanded(
                            child: Text.rich(
                              TextSpan(
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.45,
                                  color: Color(0xFF707070),
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        'Dengan membuat akun, saya menyetujui ',
                                  ),
                                  TextSpan(
                                    text: 'Ketentuan Penggunaan',
                                    style: TextStyle(color: orange),
                                  ),
                                  TextSpan(text: ' dan '),
                                  TextSpan(
                                    text: 'Kebijakan Privasi.',
                                    style: TextStyle(color: orange),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Tombol registrasi
                    SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                _register();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _canSubmit
                              ? yellow
                              : const Color(0xFFE2E2E2),
                          foregroundColor: _canSubmit
                              ? const Color(0xFF444444)
                              : const Color(0xFF888888),
                          disabledBackgroundColor: const Color(0xFFE2E2E2),
                          elevation: 0,
                          shape: const StadiumBorder(),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'Buat akun',
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
          ],
        ),
      ),
    );
  }

  // Widget input biasa
  Widget _input({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFDADADA), width: 1.4),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF969EA8), fontSize: 18),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // Widget input password
  Widget _passwordInput({
    required TextEditingController controller,
    required String hint,
    required bool visible,
    required VoidCallback onToggle,
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFDADADA), width: 1.4),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: !visible,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Color(0xFF969EA8),
                  fontSize: 18,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: onToggle,
            icon: Icon(
              visible
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }

  // Indikator persyaratan password
  Widget _requirement(String label, bool valid) {
    return Row(
      children: [
        Icon(
          Icons.check_circle_outline,
          size: 22,
          color: valid ? const Color(0xFF5E9B77) : const Color(0xFF9CA4AD),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: valid ? const Color(0xFF5E9B77) : const Color(0xFF9CA4AD),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
