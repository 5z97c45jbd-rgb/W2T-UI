import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthErrorText extends StatelessWidget {
  const AuthErrorText(this.message, {super.key});

  final String? message;

  @override
  Widget build(BuildContext context) {
    if (message == null || message!.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        message!,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: const Color(0xFFE53935),
        ),
      ),
    );
  }
}
