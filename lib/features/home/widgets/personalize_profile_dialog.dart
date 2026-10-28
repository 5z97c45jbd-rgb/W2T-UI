import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/features/home/data/favourite_colors.dart';

class PersonalizeProfileDialog extends StatefulWidget {
  const PersonalizeProfileDialog({
    super.key,
    this.initialDateOfBirth,
    this.initialColor,
    this.isSaving = false,
    this.errorMessage,
    required this.onSave,
  });

  final DateTime? initialDateOfBirth;
  final String? initialColor;
  final bool isSaving;
  final String? errorMessage;
  final ValueChanged<({DateTime dateOfBirth, String color})> onSave;

  @override
  State<PersonalizeProfileDialog> createState() =>
      _PersonalizeProfileDialogState();
}

class _PersonalizeProfileDialogState extends State<PersonalizeProfileDialog> {
  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  DateTime? _dateOfBirth;
  late FavouriteColor _color;

  @override
  void initState() {
    super.initState();
    _dateOfBirth = widget.initialDateOfBirth;
    _color = FavouriteColor.matching(widget.initialColor) ??
        FavouriteColor.options.first;
  }

  bool get _canSave => _dateOfBirth != null && !widget.isSaving;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirth ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1920),
      lastDate: now,
      helpText: 'Date of Birth',
    );
    if (picked == null || !mounted) return;
    setState(() => _dateOfBirth = picked);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Material(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(32),
            clipBehavior: Clip.antiAlias,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _PersonalizeHero(),
                  const SizedBox(height: 18),
                  Text(
                    "Let's personalize your\nW2T experience",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      height: 1.25,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tell us a few details to help us serve you better with personalized recommendations.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      height: 1.45,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 26),
                  const _FieldLabel(text: 'Date of Birth'),
                  const SizedBox(height: 8),
                  _DateField(
                    label: _dateOfBirth == null
                        ? 'Select date'
                        : '${_dateOfBirth!.day} ${_months[_dateOfBirth!.month - 1]} ${_dateOfBirth!.year}',
                    placeholder: _dateOfBirth == null,
                    onTap: widget.isSaving ? null : _pickDate,
                  ),
                  const SizedBox(height: 22),
                  const _FieldLabel(text: 'Favourite Color'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    children: [
                      for (final color in FavouriteColor.options)
                        _ColorDot(
                          color: color,
                          selected: color.name == _color.name,
                          onTap: widget.isSaving
                              ? null
                              : () => setState(() => _color = color),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _color.name,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  if (widget.errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      widget.errorMessage!,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: const Color(0xFFDC2626),
                      ),
                    ),
                  ],
                  const SizedBox(height: 22),
                  _SaveButton(
                    isLoading: widget.isSaving,
                    enabled: _canSave,
                    onPressed: _canSave
                        ? () => widget.onSave((
                              dateOfBirth: _dateOfBirth!,
                              color: _color.name,
                            ))
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PersonalizeHero extends StatelessWidget {
  const _PersonalizeHero();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 108,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 78,
            top: 10,
            child:
                Icon(Icons.auto_awesome, size: 14, color: Colors.blue.shade300),
          ),
          Positioned(
            right: 86,
            top: 18,
            child: Icon(Icons.auto_awesome,
                size: 12, color: Colors.amber.shade400),
          ),
          Positioned(
            left: 64,
            bottom: 22,
            child: Icon(Icons.hexagon_outlined,
                size: 14, color: Colors.cyan.shade300),
          ),
          Positioned(
            right: 70,
            bottom: 28,
            child: Icon(Icons.hexagon, size: 12, color: Colors.blue.shade200),
          ),
          Positioned(
            left: 108,
            top: 28,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade200,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE8F3FF),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.12),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 46,
              color: Color(0xFF3B82F6),
            ),
          ),
          Positioned(
            right: 118,
            bottom: 14,
            child: Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: const Color(0xFF3B82F6),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.edit_rounded,
                size: 13,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: text,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF111827),
        ),
        children: [
          TextSpan(
            text: ' *',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFEF4444),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.placeholder,
    required this.onTap,
  });

  final String label;
  final bool placeholder;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.calendar_today_rounded,
                  size: 16,
                  color: Color(0xFF2563EB),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: placeholder
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF111827),
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF9CA3AF),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final FavouriteColor color;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isLight = color.name == 'White';
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.value,
          border: Border.all(
            color: selected
                ? const Color(0xFF2563EB)
                : isLight
                    ? const Color(0xFFE5E7EB)
                    : Colors.transparent,
            width: selected ? 3 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFF3B82F6).withValues(alpha: 0.28),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: selected
            ? Icon(
                Icons.check_rounded,
                size: 18,
                color: isLight ? const Color(0xFF2563EB) : Colors.white,
              )
            : null,
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.enabled,
    required this.isLoading,
    required this.onPressed,
  });

  final bool enabled;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              enabled ? AppColors.primary : AppColors.indicatorInactive,
          disabledBackgroundColor: AppColors.indicatorInactive,
          shadowColor: Colors.transparent,
          foregroundColor: AppColors.white,
          disabledForegroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: AppColors.white,
                ),
              )
            : FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Save & Continue',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ),
              ),
      ),
    );
  }
}
