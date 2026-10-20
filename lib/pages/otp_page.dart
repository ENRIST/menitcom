import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'welcome_mpc_page.dart';
import 'reset_password_page.dart';

enum OtpMode { login, resetPassword }

class OtpPage extends StatefulWidget {
  const OtpPage({
    super.key,
    this.phoneNumber = '+62 812****1234',
    this.mode = OtpMode.login,
    this.userData,
  });

  final String phoneNumber;
  final OtpMode mode;
  final Map<String, String>? userData;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  Timer? timer;

  int seconds = 180;

  String? error;

  bool isLoading = false;
  bool otpRequested = false;

  static const Color yellow = Color(0xFFFFBD25);
  static const String baseUrl = 'http://localhost:3000';

  String get normalizedPhone {
    return widget.phoneNumber.replaceAll(RegExp(r'[\s\-()]'), '');
  }

  String get purpose {
    return widget.mode == OtpMode.resetPassword ? 'reset_password' : 'login';
  }

  String get timeText {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');

    return '$minutes:$remainingSeconds';
  }

  @override
  void initState() {
    super.initState();

    startTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        requestOtp();
      }
    });
  }

  void startTimer() {
    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }

      if (seconds <= 0) {
        t.cancel();
        setState(() {
          seconds = 0;
        });
      } else {
        setState(() {
          seconds--;
        });
      }
    });
  }

  // Mengirim permintaan OTP ke backend.
  Future<void> requestOtp() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/otp/request'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'phone': normalizedPhone, 'purpose': purpose}),
          )
          .timeout(const Duration(seconds: 10));

      debugPrint('STATUS REQUEST OTP: ${response.statusCode}');
      debugPrint('BODY REQUEST OTP: ${response.body}');

      final dynamic result = jsonDecode(response.body);

      if (result is! Map) {
        throw const FormatException('Respons server bukan objek JSON.');
      }

      final Map<String, dynamic> data = Map<String, dynamic>.from(result);

      if (!mounted) return;

      if (response.statusCode == 200 && data['status'] == 'success') {
        setState(() {
          otpRequested = true;
          controller.clear();
          seconds = 180;
          error = null;
        });

        startTimer();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP berhasil dibuat. Periksa terminal backend.'),
          ),
        );
      } else {
        setState(() {
          otpRequested = false;
          error = data['message']?.toString() ?? 'Gagal meminta OTP.';
        });
      }
    } on TimeoutException {
      if (!mounted) return;

      setState(() {
        error = 'Backend terlalu lama merespons.';
      });
    } on FormatException catch (e) {
      debugPrint('FORMAT REQUEST OTP: $e');

      if (!mounted) return;

      setState(() {
        error = 'Respons server tidak dapat dibaca.';
      });
    } catch (e) {
      debugPrint('ERROR REQUEST OTP: $e');

      if (!mounted) return;

      setState(() {
        error = 'Gagal menghubungi backend. Periksa server.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Memverifikasi OTP ke backend.
  Future<void> verify() async {
    final String enteredOtp = controller.text.trim();

    if (!RegExp(r'^\d{6}$').hasMatch(enteredOtp)) {
      setState(() {
        error = 'Masukkan kode OTP sebanyak 6 digit.';
      });
      return;
    }

    if (!otpRequested) {
      setState(() {
        error = 'Silakan minta OTP terlebih dahulu.';
      });
      return;
    }

    if (seconds <= 0) {
      setState(() {
        error = 'OTP sudah kedaluwarsa. Silakan minta OTP baru.';
      });
      return;
    }

    if (isLoading) return;

    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/api/otp/verify'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'phone': normalizedPhone,
              'otp': enteredOtp,
              'purpose': purpose,
            }),
          )
          .timeout(const Duration(seconds: 10));

      debugPrint('STATUS VERIFY OTP: ${response.statusCode}');
      debugPrint('BODY VERIFY OTP: ${response.body}');

      final dynamic result = jsonDecode(response.body);

      if (result is! Map) {
        throw const FormatException('Respons server bukan objek JSON.');
      }

      final Map<String, dynamic> data = Map<String, dynamic>.from(result);

      if (!mounted) return;

      if (response.statusCode != 200 || data['status'] != 'success') {
        setState(() {
          error = data['message']?.toString() ?? 'Verifikasi OTP gagal.';
        });
        return;
      }

      timer?.cancel();

      // Alur lupa password.
      if (widget.mode == OtpMode.resetPassword) {
        final dynamic resetToken = data['reset_token'];

        if (resetToken is! String || resetToken.isEmpty) {
          setState(() {
            error = 'Token pemulihan tidak diterima dari server.';
          });
          return;
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ResetPasswordPage(
              phoneNumber: widget.phoneNumber,
              resetToken: resetToken,
            ),
          ),
        );
      } else {
        // Alur login biasa.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => WelcomeMpcPage(userData: widget.userData),
          ),
        );
      }
    } on TimeoutException {
      if (!mounted) return;

      setState(() {
        error = 'Backend terlalu lama merespons.';
      });
    } on FormatException catch (e) {
      debugPrint('FORMAT VERIFY OTP: $e');

      if (!mounted) return;

      setState(() {
        error = 'Respons server tidak dapat dibaca.';
      });
    } catch (e) {
      debugPrint('ERROR VERIFY OTP: $e');

      if (!mounted) return;

      setState(() {
        error = 'Gagal menghubungi backend. Periksa server.';
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: BackButton(onPressed: () => Navigator.pop(context)),
        title: const Text('Verifikasi OTP'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(child: _Logo()),

              const SizedBox(height: 100),

              const Text(
                'Masukkan kode 6-digit',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),

              const SizedBox(height: 6),

              Text(
                'Masukkan kode OTP untuk '
                '${widget.phoneNumber}. '
                'Kode simulasi dapat dilihat di terminal backend.',
                style: const TextStyle(
                  color: Color(0xFF777777),
                  fontSize: 16,
                  height: 1.45,
                ),
              ),

              const SizedBox(height: 42),

              GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(focusNode);
                },
                child: Container(
                  height: 74,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFE6CF7A),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(
                          6,
                          (i) => Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: i < controller.text.length
                                  ? yellow
                                  : const Color(0xFFD5DBE0),
                            ),
                          ),
                        ),
                      ),

                      Opacity(
                        opacity: 0.02,
                        child: TextField(
                          controller: controller,
                          focusNode: focusNode,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          decoration: const InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                          ),
                          onChanged: (_) {
                            setState(() {
                              error = null;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    error!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),

              const SizedBox(height: 42),

              Text(
                seconds > 0
                    ? 'Tidak menerima OTP? '
                          'Kirim ulang dalam $timeText'
                    : 'Waktu OTP habis.',
                style: const TextStyle(color: Color(0xFF777777), fontSize: 15),
              ),

              if (seconds == 0)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: isLoading ? null : requestOtp,
                    child: const Text('Kirim ulang OTP'),
                  ),
                ),

              const SizedBox(height: 24),

              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : verify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yellow,
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: const StadiumBorder(),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : const Text('Verifikasi OTP'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 94,
      height: 94,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFFBD25),
        border: Border.all(color: const Color(0xFF333333), width: 4),
      ),
      child: const Center(
        child: Text(
          'mpc',
          style: TextStyle(
            color: Color(0xFF292929),
            fontSize: 31,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
