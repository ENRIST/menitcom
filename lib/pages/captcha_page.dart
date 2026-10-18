import 'dart:math';
import 'package:flutter/material.dart';
import 'otp_page.dart';

class CaptchaPage extends StatefulWidget {
  const CaptchaPage({super.key, this.phoneNumber = '+62 812****1234'});
  final String phoneNumber;
  @override
  State<CaptchaPage> createState() => _CaptchaPageState();
}

class _CaptchaPageState extends State<CaptchaPage> {
  final input = TextEditingController();
  late String code;
  String? error;
  static const yellow = Color(0xFFFFBD25);

  @override
  void initState() {
    super.initState();
    refreshCode();
  }

  void refreshCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random();
    code = List.generate(5, (_) => chars[random.nextInt(chars.length)]).join();
  }

  void verify() {
    if (input.text.trim().toUpperCase() != code) {
      setState(() {
        error = 'Captcha belum sesuai. Silakan coba lagi.';
        refreshCode();
        input.clear();
      });
      return;
    }
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => OtpPage(phoneNumber: widget.phoneNumber),
    ));
  }

  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0,
      leading: BackButton(onPressed: () => Navigator.pop(context)),
      title: const Text('Verifikasi OTP'), centerTitle: true,
    ),
    body: SafeArea(child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Center(child: _Logo()),
        const SizedBox(height: 35),
        const Text('Verifikasi keamanan',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text('Sebelum OTP dikirim ke ${widget.phoneNumber}, selesaikan verifikasi di bawah ini.',
          style: const TextStyle(color: Colors.grey, fontSize: 16, height: 1.5)),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFE5E5E5)),
            boxShadow: const [BoxShadow(color: Color(0x16000000), blurRadius: 16)],
          ),
          child: Column(children: [
            const Text('Verifikasi', style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            const Text('Sebelum OTP kamu dikirim, silakan menyelesaikan verifikasi di bawah ini.',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 22),
            Row(children: [
              Expanded(child: Container(
                height: 62, alignment: Alignment.center,
                decoration: BoxDecoration(color: const Color(0xFFFFF6DF), borderRadius: BorderRadius.circular(8)),
                child: Text(code.split('').join(' '), style: const TextStyle(
                  color: Color(0xFF3979C8), fontSize: 22, fontWeight: FontWeight.w800,
                  letterSpacing: 2, fontStyle: FontStyle.italic)),
              )),
              IconButton(onPressed: () => setState(() { refreshCode(); input.clear(); error = null; }),
                icon: const Icon(Icons.refresh, size: 30)),
            ]),
            const SizedBox(height: 18),
            TextField(controller: input, textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(hintText: 'Masukkan captcha', errorText: error,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.all(18))),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, height: 54, child: ElevatedButton(
              onPressed: verify,
              style: ElevatedButton.styleFrom(backgroundColor: yellow, foregroundColor: Colors.black,
                elevation: 0, shape: const StadiumBorder()),
              child: const Text('Verifikasi', style: TextStyle(fontSize: 18)))),
            const SizedBox(height: 12),
            SizedBox(width: double.infinity, height: 54, child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(side: const BorderSide(color: yellow, width: 1.5),
                shape: const StadiumBorder(), foregroundColor: Colors.black),
              child: const Text('Kembali', style: TextStyle(fontSize: 18)))),
          ]),
        ),
      ]),
    )),
  );
}

class _Logo extends StatelessWidget {
  const _Logo();
  @override
  Widget build(BuildContext context) => Container(
    width: 94, height: 94,
    decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFFFBD25),
      border: Border.all(color: const Color(0xFF333333), width: 4)),
    child: const Center(child: Text('mpc', style: TextStyle(
      color: Color(0xFF292929), fontSize: 31, fontWeight: FontWeight.w900))),
  );
}
