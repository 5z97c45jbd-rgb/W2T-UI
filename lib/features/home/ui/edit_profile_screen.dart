import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/core/ui/app_snack_bar.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_bloc.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_event.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_state.dart';
import 'package:w2t_mobile/features/home/data/favourite_colors.dart';
import 'package:w2t_mobile/features/home/widgets/favourite_color_picker.dart';
import 'package:w2t_mobile/features/home/widgets/profile_chrome.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static const _genders = ['Male', 'Female', 'Other'];

  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _location;
  DateTime? _dob;
  String _gender = 'Male';
  late FavouriteColor _color;
  String? _avatarPath;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<SessionBloc>().state;
    final profile = state.profile;
    _name = TextEditingController(text: profile?.visibleFullName ?? '');
    _phone = TextEditingController(
      text: ProfileFormat.localPhone(profile?.phoneNumber),
    );
    _location = TextEditingController(
      text: ProfileFormat.location(profile?.location),
    );
    _dob = profile?.dateOfBirth;
    _gender = ProfileFormat.gender(profile?.gender);
    _color =
        FavouriteColor.matching(profile?.color) ?? FavouriteColor.options.first;
    _avatarPath = state.avatarPath;
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _location.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1920),
      lastDate: now,
      helpText: 'Date of Birth',
    );
    if (picked == null || !mounted) return;
    setState(() => _dob = picked);
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    final phone = _phone.text.trim();
    if (name.isEmpty || phone.length != 10) {
      AppSnackBar.show(
        context,
        name.isEmpty
            ? 'Please enter your full name'
            : 'Enter a valid 10-digit phone number',
      );
      return;
    }
    setState(() => _saving = true);
    context.read<SessionBloc>().add(
          SessionProfileUpdated(
            fullName: name,
            phoneNumber: phone,
            dateOfBirth: _dob,
            color: _color.name,
            location: _location.text.trim(),
            gender: _gender,
            avatarPath: _avatarPath,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final email = context.select<SessionBloc, String?>(
      (bloc) => bloc.state.profile?.email,
    );

    return BlocListener<SessionBloc, SessionState>(
      listenWhen: (previous, current) =>
          previous.isUpdatingProfile && !current.isUpdatingProfile,
      listener: (context, state) {
        setState(() => _saving = false);
        if (state.profileUpdateError != null) {
          AppSnackBar.show(context, state.profileUpdateError!);
          return;
        }
        if (context.canPop()) context.pop();
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: ProfilePalette.page,
          body: SafeArea(
            child: Column(
              children: [
                ProfileBrandHeader(
                  onBack: () {
                    if (context.canPop()) context.pop();
                  },
                ),
                Expanded(
                  child: ListView(
                    cacheExtent: 1200,
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Edit Profile',
                                  style: GoogleFonts.inter(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: ProfilePalette.navy,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Update your information',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.5,
                                    color: ProfilePalette.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // ProfileSaveChip(
                          //   isLoading: _saving,
                          //   onPressed: _saving ? null : _save,
                          // ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ProfileAvatar(
                          path: _avatarPath,
                          onCameraTap: () async {
                            final path = await pickProfileAvatar(context);
                            if (path == null || !mounted) return;
                            setState(() => _avatarPath = path);
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      _LabeledField(
                        label: 'Full Name',
                        required: true,
                        child: _InputBox(
                          controller: _name,
                          hint: 'Your name',
                          prefix: Icons.person_outline_rounded,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _LabeledField(
                        label: 'Phone Number',
                        required: true,
                        child: _PhoneBox(controller: _phone),
                      ),
                      const SizedBox(height: 16),
                      _LabeledField(
                        label: 'Email Address',
                        required: true,
                        child: _InputBox(
                          readOnly: true,
                          hint: 'email@example.com',
                          prefix: Icons.mail_outline_rounded,
                          filled: true,
                          value: email,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _LabeledField(
                        label: 'Location',
                        required: true,
                        child: _InputBox(
                          controller: _location,
                          hint: 'Hanamkonda, Warangal',
                          prefix: Icons.location_on_outlined,
                          suffix: Icons.gps_fixed_rounded,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _LabeledField(
                        label: 'Date of Birth',
                        child: _InputBox(
                          readOnly: true,
                          onTap: _pickDob,
                          hint: 'Select date',
                          value: _dob == null ? null : ProfileFormat.date(_dob),
                          prefix: Icons.calendar_month_outlined,
                          suffix: Icons.calendar_today_outlined,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _LabeledField(
                        label: 'Gender',
                        child: _GenderBox(
                          value: _gender,
                          options: _genders,
                          onChanged: (value) => setState(() => _gender = value),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _LabeledField(
                        label: 'Favourite Color',
                        child: FavouriteColorPicker(
                          selected: _color,
                          enabled: !_saving,
                          onSelected: (color) => setState(() => _color = color),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.label,
    required this.child,
    this.required = false,
  });

  final String label;
  final Widget child;
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
              fontWeight: FontWeight.w700,
              color: ProfilePalette.navy,
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
        child,
      ],
    );
  }
}

class _InputBox extends StatelessWidget {
  const _InputBox({
    this.controller,
    this.hint,
    this.prefix,
    this.suffix,
    this.readOnly = false,
    this.filled = false,
    this.value,
    this.onTap,
  });

  final TextEditingController? controller;
  final String? hint;
  final IconData? prefix;
  final IconData? suffix;
  final bool readOnly;
  final bool filled;
  final String? value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final valueStyle = GoogleFonts.inter(
      fontSize: 14.5,
      fontWeight: FontWeight.w500,
      color: filled ? ProfilePalette.muted : ProfilePalette.navy,
    );
    final display = (value ?? '').trim();
    if (controller == null) {
      return Material(
        color: filled ? const Color(0xFFF2F4F7) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: ProfilePalette.cardBorder),
            ),
            child: Row(
              children: [
                if (prefix != null) ...[
                  Icon(prefix, size: 20, color: ProfilePalette.iconBlue),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Text(
                    display.isEmpty ? (hint ?? '') : display,
                    style: display.isEmpty
                        ? GoogleFonts.inter(
                            fontSize: 14.5,
                            color: AppColors.textMuted,
                          )
                        : valueStyle,
                  ),
                ),
                if (suffix != null)
                  Icon(suffix, size: 18, color: ProfilePalette.iconBlue),
              ],
            ),
          ),
        ),
      );
    }
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      style: valueStyle,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(
          fontSize: 14.5,
          color: AppColors.textMuted,
        ),
        filled: true,
        fillColor: filled ? const Color(0xFFF2F4F7) : Colors.white,
        prefixIcon: prefix == null
            ? null
            : Icon(prefix, size: 20, color: ProfilePalette.iconBlue),
        suffixIcon: suffix == null
            ? null
            : Icon(suffix, size: 18, color: ProfilePalette.iconBlue),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: _border(ProfilePalette.cardBorder),
        enabledBorder: _border(ProfilePalette.cardBorder),
        focusedBorder: _border(AppColors.primary),
      ),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color),
    );
  }
}

class _PhoneBox extends StatelessWidget {
  const _PhoneBox({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ProfilePalette.cardBorder),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          Icon(Icons.phone_outlined, size: 20, color: ProfilePalette.iconBlue),
          const SizedBox(width: 8),
          Text(
            '+91',
            style: GoogleFonts.inter(
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              color: ProfilePalette.navy,
            ),
          ),
          const Icon(Icons.keyboard_arrow_down_rounded,
              size: 18, color: ProfilePalette.muted),
          Container(
            width: 1,
            height: 22,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            color: ProfilePalette.cardBorder,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              style: GoogleFonts.inter(
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                color: ProfilePalette.navy,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: '98765 43210',
                hintStyle: GoogleFonts.inter(
                  fontSize: 14.5,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GenderBox extends StatelessWidget {
  const _GenderBox({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onChanged,
      offset: const Offset(0, 48),
      color: Colors.white,
      itemBuilder: (context) {
        return [
          for (final option in options)
            PopupMenuItem(
              value: option,
              child: Text(option, style: GoogleFonts.inter(fontSize: 14.5)),
            ),
        ];
      },
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: ProfilePalette.cardBorder),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.male_rounded,
              size: 22,
              color: ProfilePalette.iconBlue,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                value,
                style: GoogleFonts.inter(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: ProfilePalette.navy,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: ProfilePalette.muted,
            ),
          ],
        ),
      ),
    );
  }
}
