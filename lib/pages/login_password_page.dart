import 'package:flutter/material.dart';

import 'mpc_logo.dart';
import 'captcha_page.dart';

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

  // Simulasi login sementara karena backend belum terhubung.
  void _login() {
    final password = _passwordController.text.trim();

    if (password.isEmpty) {
      setState(() {
        _showError = true;
      });
      return;
    }

    setState(() {
      _showError = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CaptchaPage(phoneNumber: widget.phoneNumber),
      ),
    );
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
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: yellow,
                          foregroundColor: const Color(0xFF3D3D3D),
                          elevation: 0,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text(
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
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Fitur pemulihan password akan dibuat pada tahap berikutnya.',
                              ),
                            ),
                          );
                        },
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
