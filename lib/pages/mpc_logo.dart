import 'package:flutter/material.dart';

class MpcLogo extends StatelessWidget {
  const MpcLogo({super.key, this.size = 112});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFFFB916),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF333333), width: 4),
        boxShadow: const [
          BoxShadow(color: Color(0x18000000), blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      alignment: Alignment.center,
      child: const Text(
        'mpc',
        style: TextStyle(
          color: Color(0xFF292929),
          fontSize: 35,
          fontWeight: FontWeight.w800,
          letterSpacing: -2,
        ),
      ),
    );
  }
}
