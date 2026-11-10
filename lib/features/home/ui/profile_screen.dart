import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/core/router/app_router.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_bloc.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_event.dart';
import 'package:w2t_mobile/features/auth/bloc/session/session_state.dart';
import 'package:w2t_mobile/features/auth/widgets/primary_button.dart';
import 'package:w2t_mobile/features/home/bloc/home_tab/home_tab_cubit.dart';
import 'package:w2t_mobile/features/home/widgets/home_bottom_nav_bar.dart';
import 'package:w2t_mobile/features/home/widgets/profile_chrome.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: ProfilePalette.page,
        body: SafeArea(
          bottom: false,
          child: BlocBuilder<SessionBloc, SessionState>(
            builder: (context, state) {
              final profile = state.profile;
              final phone = ProfileFormat.phone(profile?.phoneNumber);
              final email = profile?.email?.trim();
              final hasEmail = email != null && email.isNotEmpty;

              return Column(
                children: [
                  ProfileBrandHeader(
                    onBack: () =>
                        HomeTabCubit.maybeOf(context)?.select(HomeTab.home),
                  ),
                  Expanded(
                    child: ListView(
                      cacheExtent: 1200,
                      padding: EdgeInsets.fromLTRB(
                        18,
                        2,
                        18,
                        HomeBottomNavBar.contentBottomInset(context) + 16,
                      ),
                      children: [
                        SizedBox(
                          height: 64,
                          child: Stack(
                            children: [
                              const Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _TitleText('My Profile'),
                                    SizedBox(height: 2),
                                    _SubtitleText(
                                      'View your profile information',
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 4,
                                child: _EditButton(
                                  onTap: () =>
                                      context.push(AppRoutes.editProfile),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: ProfileAvatar(
                            path: state.avatarPath,
                            onCameraTap: () async {
                              final path = await pickProfileAvatar(context);
                              if (path == null || !context.mounted) return;
                              context
                                  .read<SessionBloc>()
                                  .add(SessionAvatarChanged(path));
                            },
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          profile?.displayName ?? 'My Profile',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: ProfilePalette.navy,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          hasEmail ? email : 'Add your email',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 12.5,
                            color: ProfilePalette.muted,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: _VerifiedCard(
                                icon: Icons.phone_rounded,
                                value: phone,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _VerifiedCard(
                                icon: Icons.mail_rounded,
                                value: hasEmail ? email : '—',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _InfoCard(
                          children: [
                            _InfoRow(
                              icon: Icons.person_rounded,
                              label: 'Full Name',
                              value: profile?.visibleFullName ?? '—',
                              onTap: () => context.push(AppRoutes.editProfile),
                            ),
                            _InfoRow(
                              icon: Icons.phone_rounded,
                              label: 'Phone Number',
                              value: phone,
                              onTap: () => context.push(AppRoutes.editProfile),
                            ),
                            _InfoRow(
                              icon: Icons.mail_rounded,
                              label: 'Email Address',
                              value: hasEmail ? email : '—',
                              onTap: () => context.push(AppRoutes.editProfile),
                            ),
                            _InfoRow(
                              icon: Icons.location_on_rounded,
                              label: 'Location',
                              value: ProfileFormat.location(profile?.location),
                              onTap: () => context.push(AppRoutes.editProfile),
                            ),
                            _InfoRow(
                              icon: Icons.calendar_month_rounded,
                              label: 'Date of Birth',
                              value: ProfileFormat.date(profile?.dateOfBirth),
                              onTap: () => context.push(AppRoutes.editProfile),
                            ),
                            _InfoRow(
                              icon: Icons.person_rounded,
                              label: 'Gender',
                              value: ProfileFormat.gender(profile?.gender),
                              onTap: () => context.push(AppRoutes.editProfile),
                            ),
                            _InfoRow(
                              icon: Icons.palette_outlined,
                              label: 'Favourite Color',
                              value: ProfileFormat.color(profile?.color),
                              onTap: () => context.push(AppRoutes.editProfile),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _InfoCard(
                          children: [
                            _InfoRow(
                              icon: Icons.groups_rounded,
                              label: 'Account Type',
                              value: 'Customer',
                              onTap: () {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _DistributorButton(
                          onPressed: () =>
                              context.push(AppRoutes.selectVehicle),
                        ),
                        const SizedBox(height: 12),
                        PrimaryButton(
                          label: 'Log out',
                          isLoading: state.isLoggingOut,
                          onPressed: () {
                            context
                                .read<SessionBloc>()
                                .add(const SessionLogoutRequested());
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: ProfilePalette.navy,
        height: 1.1,
      ),
    );
  }
}

class _SubtitleText extends StatelessWidget {
  const _SubtitleText(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: GoogleFonts.inter(
        fontSize: 12.5,
        fontWeight: FontWeight.w400,
        color: ProfilePalette.muted,
      ),
    );
  }
}

class _EditButton extends StatelessWidget {
  const _EditButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF122033).withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.edit_outlined,
            size: 16,
            color: ProfilePalette.iconBlue,
          ),
        ),
      ),
    );
  }
}

class _VerifiedCard extends StatelessWidget {
  const _VerifiedCard({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      padding: const EdgeInsets.fromLTRB(12, 12, 10, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: ProfilePalette.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: ProfilePalette.iconBlue),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: ProfilePalette.navy,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                size: 13,
                color: ProfilePalette.verified,
              ),
              const SizedBox(width: 4),
              Text(
                'Verified',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: ProfilePalette.verified,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: ProfilePalette.cardShadow,
      ),
      child: Column(children: children),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 13, 10, 13),
          child: Row(
            children: [
              Icon(icon, size: 20, color: ProfilePalette.iconBlue),
              const SizedBox(width: 12),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: ProfilePalette.label,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: ProfilePalette.value,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: ProfilePalette.chevron,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DistributorButton extends StatelessWidget {
  const _DistributorButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            colors: [AppColors.kycGradientStart, AppColors.kycGradientEnd],
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.local_shipping_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Be a Distributor',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
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
