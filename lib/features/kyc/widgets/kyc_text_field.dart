import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';

class KycTextField extends StatelessWidget {
  const KycTextField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.onChanged,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.prefix,
    this.suffix,
    this.textCapitalization = TextCapitalization.none,
    this.required = false,
    this.dense = false,
  });

  final String label;
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  final int? maxLength;
  final IconData? prefixIcon;
  final Widget? prefix;
  final Widget? suffix;
  final TextCapitalization textCapitalization;
  final bool required;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.titleNavy,
            ),
            children: [
              if (required)
                const TextSpan(
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
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          maxLength: maxLength,
          textCapitalization: textCapitalization,
          style: GoogleFonts.inter(
            fontSize: 14.5,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            counterText: maxLength == null ? '' : null,
            hintStyle: GoogleFonts.inter(
              fontSize: 14.5,
              color: AppColors.textMuted,
            ),
            filled: true,
            fillColor: AppColors.white,
            isDense: dense,
            prefixIcon: prefix ??
                (prefixIcon == null
                    ? null
                    : Icon(prefixIcon, size: 20, color: AppColors.primary)),
            prefixIconConstraints: prefix == null && prefixIcon == null
                ? null
                : const BoxConstraints(minWidth: 40, minHeight: 40),
            suffixIcon: suffix,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 14,
              vertical: dense ? 12 : 14,
            ),
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

class KycSelectField extends StatelessWidget {
  const KycSelectField({
    super.key,
    required this.label,
    required this.value,
    required this.hint,
    required this.onTap,
    this.required = false,
  });

  final String label;
  final String value;
  final String hint;
  final VoidCallback onTap;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.titleNavy,
            ),
            children: [
              if (required)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Color(0xFFE53935)),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Material(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.kycFieldBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      value.isEmpty ? hint : value,
                      style: GoogleFonts.inter(
                        fontSize: 14.5,
                        color: value.isEmpty
                            ? AppColors.textMuted
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
