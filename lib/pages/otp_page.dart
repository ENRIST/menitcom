import 'dart:async';
import 'package:flutter/material.dart';
import 'welcome_mpc_page.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key, this.phoneNumber = '+62 812****1234'});
  final String phoneNumber;
  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  Timer? timer;
  int seconds = 180;
  String? error;
  static const yellow = Color(0xFFFFBD25);

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (seconds == 0) { t.cancel(); } else { setState(() => seconds--); }
    });
  }

  String get timeText => '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';

  void verify() {
    if (controller.text.length != 6) {
      setState(() => error = 'Masukkan kode OTP sebanyak 6 digit.');
      return;
    }
    // Simulasi prototipe: semua kode 6 digit diterima.
    Navigator.push(context, MaterialPageRoute(builder: (_) => const WelcomeMpcPage()));
  }

  @override
  void dispose() {
    timer?.cancel();
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(backgroundColor: Colors.white, foregroundColor: Colors.black,
      elevation: 0, leading: BackButton(onPressed: () => Navigator.pop(context)),
      title: const Text('Verifikasi OTP'), centerTitle: true),
    body: SafeArea(child: SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Center(child: _Logo()),
        const SizedBox(height: 100),
        const Text('Masukkan kode 6-digit',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Text('Kami telah mengirimkan kode OTP ke ${widget.phoneNumber}. Mohon cek aplikasi WhatsApp kamu.',
          style: const TextStyle(color: Color(0xFF777777), fontSize: 16, height: 1.45)),
        const SizedBox(height: 42),
        GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(focusNode),
          child: Container(height: 74,
            decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE6CF7A), width: 1.5),
              borderRadius: BorderRadius.circular(14)),
            child: Stack(alignment: Alignment.center, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (i) => Container(width: 18, height: 18,
                  decoration: BoxDecoration(shape: BoxShape.circle,
                    color: i < controller.text.length ? yellow : const Color(0xFFD5DBE0))))),
              Opacity(opacity: 0.02, child: TextField(
                controller: controller, focusNode: focusNode, keyboardType: TextInputType.number,
                maxLength: 6, decoration: const InputDecoration(counterText: '', border: InputBorder.none),
                onChanged: (_) => setState(() => error = null))),
            ]),
          ),
        ),
        if (error != null) Padding(padding: const EdgeInsets.only(top: 8),
          child: Text(error!, style: const TextStyle(color: Colors.red, fontSize: 13))),
        const SizedBox(height: 42),
        Text('Tidak menerima OTP? ${seconds > 0 ? 'Kirim ulang via SMS dalam $timeText' : 'Kirim ulang via SMS'}',
          style: const TextStyle(color: Color(0xFF777777), fontSize: 15)),
        if (seconds == 0) Align(alignment: Alignment.centerLeft, child: TextButton(
          onPressed: () {
            setState(() => seconds = 180);
            timer?.cancel();
            timer = Timer.periodic(const Duration(seconds: 1), (t) {
              if (!mounted) return;
              if (seconds == 0) { t.cancel(); } else { setState(() => seconds--); }
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Simulasi: kode OTP dikirim ulang.')));
          }, child: const Text('Kirim ulang OTP'))),
        const SizedBox(height: 24),
        SizedBox(height: 52, child: ElevatedButton(onPressed: verify,
          style: ElevatedButton.styleFrom(backgroundColor: yellow, foregroundColor: Colors.black,
            elevation: 0, shape: const StadiumBorder()),
          child: const Text('Verifikasi OTP'))),
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
