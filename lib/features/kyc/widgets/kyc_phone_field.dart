import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';

class KycPhoneField extends StatelessWidget {
  const KycPhoneField({
    super.key,
    required this.onChanged,
    this.controller,
  });

  final TextEditingController? controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: 'Phone Number',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.titleNavy,
            ),
            children: const [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Color(0xFFE53935)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          style: GoogleFonts.inter(
            fontSize: 14.5,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: '98765 43210',
            hintStyle: GoogleFonts.inter(
              fontSize: 14.5,
              color: AppColors.textMuted,
            ),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 14, right: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '+91',
                    style: GoogleFonts.inter(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 1,
                    height: 18,
                    color: AppColors.kycFieldBorder,
                  ),
                ],
              ),
            ),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            border: _border(AppColors.kycFieldBorder),
            enabledBorder: _border(AppColors.kycFieldBorder),
            focusedBorder: _border(AppColors.primary),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color),
    );
  }
}
