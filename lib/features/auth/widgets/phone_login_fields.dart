import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';

class PhoneLoginFields extends StatefulWidget {
  const PhoneLoginFields({
    super.key,
    required this.onChanged,
  });

  final ValueChanged<String> onChanged;

  @override
  State<PhoneLoginFields> createState() => _PhoneLoginFieldsState();
}

class _PhoneLoginFieldsState extends State<PhoneLoginFields> {
  final _phone = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _phone.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _openPhoneKeypad() {
    FocusScope.of(context).requestFocus(_focus);
    SystemChannels.textInput.invokeMethod<void>('TextInput.show');
  }

  @override
  Widget build(BuildContext context) {
    final focused = _focus.hasFocus;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 92,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Code', style: _label),
              const SizedBox(height: 8),
              Container(
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF1F8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '+91',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Phone', style: _label),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _openPhoneKeypad,
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF1F8),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: focused ? AppColors.primary : Colors.transparent,
                      width: 1.4,
                    ),
                  ),
                  child: TextField(
                    controller: _phone,
                    focusNode: _focus,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    onTap: _openPhoneKeypad,
                    onChanged: widget.onChanged,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    cursorColor: AppColors.primary,
                    decoration: InputDecoration(
                      hintText: 'Enter Phone Number',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF8E97A8),
                      ),
                      border: InputBorder.none,
                      isCollapsed: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

final TextStyle _label = GoogleFonts.inter(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: AppColors.textPrimary,
);
