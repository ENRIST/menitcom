import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'mpc_logo.dart';
import 'captcha_page.dart';
import 'otp_page.dart';

class LoginPasswordPage extends StatefulWidget {
  final String phoneNumber;

  const LoginPasswordPage({super.key, required this.phoneNumber});

  @override
  State<LoginPasswordPage> createState() => _LoginPasswordPageState();
}

class _LoginPasswordPageState extends State<LoginPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();

  bool _obscure = true;
  bool _showError = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  void _showForgotPasswordCaptcha() {
    final captchaController = TextEditingController();

    String generateCaptcha() {
      const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
      final random = DateTime.now().microsecondsSinceEpoch;

      return List.generate(
        5,
        (index) => chars[(random ~/ (index + 1) + index * 7) % chars.length],
      ).join();
    }

    String captchaCode = generateCaptcha();
    String? errorMessage;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              insetPadding: const EdgeInsets.symmetric(horizontal: 28),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Verifikasi Captcha',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF333333),
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Masukkan kode verifikasi yang tertera '
                      'untuk melanjutkan.',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Color(0xFF666666),
                      ),
                    ),

                    const SizedBox(height: 22),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 76,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF4F4F4),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE2E2E2),
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CustomPaint(
                                  size: const Size(double.infinity, 76),
                                  painter: _CaptchaLinePainter(),
                                ),
                                Text(
                                  captchaCode,
                                  style: const TextStyle(
                                    fontSize: 27,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 7,
                                    color: Color(0xFF333333),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        IconButton(
                          tooltip: 'Ganti kode CAPTCHA',
                          onPressed: () {
                            setDialogState(() {
                              captchaCode = generateCaptcha();
                              errorMessage = null;
                              captchaController.clear();
                            });
                          },
                          icon: const Icon(
                            Icons.refresh,
                            size: 28,
                            color: Color(0xFF555555),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    TextField(
                      controller: captchaController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        hintText: 'Masukkan kode CAPTCHA',
                        hintStyle: const TextStyle(
                          color: Color(0xFF969EA8),
                          fontSize: 15,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 17,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFDADADA),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFD98A32),
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),

                    if (errorMessage != null) ...[
                      const SizedBox(height: 9),
                      Text(
                        errorMessage!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFFC87570),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF555555),
                                side: const BorderSide(
                                  color: Color(0xFFDADADA),
                                ),
                                shape: const StadiumBorder(),
                              ),
                              child: const Text(
                                'Kembali',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                final answer = captchaController.text
                                    .trim()
                                    .toUpperCase();

                                if (answer == captchaCode) {
                                  Navigator.pop(dialogContext);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => OtpPage(
                                        phoneNumber: widget.phoneNumber,
                                        mode: OtpMode.resetPassword,
                                      ),
                                    ),
                                  );
                                } else {
                                  setDialogState(() {
                                    errorMessage =
                                        'Kode salah. Silakan coba kode baru.';

                                    captchaCode = generateCaptcha();
                                    captchaController.clear();
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFBE24),
                                foregroundColor: const Color(0xFF333333),
                                elevation: 0,
                                shape: const StadiumBorder(),
                              ),
                              child: const Text(
                                'Verifikasi',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      captchaController.dispose();
    });
  }

  Future<void> _login() async {
    final password = _passwordController.text;

    if (password.isEmpty) {
      setState(() {
        _showError = true;
      });
      return;
    }

    setState(() {
      _showError = false;
      _isLoading = true;
    });

    try {
      final response = await http
          .post(
            Uri.parse('http://localhost:3000/api/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'phone_number': widget.phoneNumber,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (!mounted) return;

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        final user = Map<String, dynamic>.from(data['user'] ?? {});

        final userData = <String, String>{
          'nama': (user['username'] ?? 'Pengguna Menit').toString(),
          'username': (user['username'] ?? 'Pengguna Menit').toString(),
          'phone_number': (user['phone_number'] ?? widget.phoneNumber)
              .toString(),
          'ponsel': (user['phone_number'] ?? widget.phoneNumber).toString(),
          'email': (user['email'] ?? '').toString(),
        };

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CaptchaPage(
              phoneNumber: widget.phoneNumber,
              userData: userData,
            ),
          ),
        );
      } else {
        setState(() {
          _showError = true;
        });
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak dapat terhubung ke server. Periksa backend.'),
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
    const yellow = Color(0xFFFFBE24);
    const orange = Color(0xFFD98A32);

    final borderColor = _showError
        ? const Color(0xFFC87570)
        : const Color(0xFFDADADA);

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

                    const SizedBox(height: 70),

                    const Text(
                      'Halo, anggota MPC',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF333333),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Selamat datang',
                      style: TextStyle(fontSize: 18, color: Color(0xFF454545)),
                    ),

                    const SizedBox(height: 30),

                    Container(
                      height: 78,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColor, width: 1.4),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _passwordController,
                              obscureText: _obscure,
                              onChanged: (_) {
                                if (_showError) {
                                  setState(() {
                                    _showError = false;
                                  });
                                }
                              },
                              decoration: const InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  color: Color(0xFF969EA8),
                                  fontSize: 19,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),

                          IconButton(
                            onPressed: () {
                              setState(() {
                                _obscure = !_obscure;
                              });
                            },
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 25,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (_showError) ...[
                      const SizedBox(height: 10),
                      const Text(
                        'Password salah. Coba lagi atau klik Lupa Password.',
                        style: TextStyle(
                          color: Color(0xFFC87570),
                          fontSize: 14,
                        ),
                      ),
                    ],

                    const SizedBox(height: 44),

                    SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: yellow,
                          foregroundColor: const Color(0xFF3D3D3D),
                          elevation: 0,
                          shape: const StadiumBorder(),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Color(0xFF3D3D3D),
                                ),
                              )
                            : const Text(
                                'Masuk dengan MPC',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Center(
                      child: TextButton(
                        onPressed: _showForgotPasswordCaptcha,
                        child: const Text(
                          'Lupa Password?',
                          style: TextStyle(
                            color: orange,
                            fontSize: 18,
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
              child: TextButton(
                onPressed: () => Navigator.maybePop(context),
                child: const Text(
                  'Gunakan akun lain',
                  style: TextStyle(
                    color: orange,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CaptchaLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFB8B8B8)
      ..strokeWidth = 1.2;

    canvas.drawLine(
      Offset(0, size.height * 0.25),
      Offset(size.width, size.height * 0.75),
      paint,
    );

    canvas.drawLine(
      Offset(0, size.height * 0.8),
      Offset(size.width, size.height * 0.2),
      paint,
    );

    canvas.drawLine(
      Offset(size.width * 0.15, 0),
      Offset(size.width * 0.8, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
