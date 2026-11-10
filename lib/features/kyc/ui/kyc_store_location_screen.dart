import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_assets.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/core/router/app_router.dart';
import 'package:w2t_mobile/features/kyc/bloc/kyc_registration/kyc_registration_cubit.dart';
import 'package:w2t_mobile/features/kyc/bloc/kyc_registration/kyc_registration_state.dart';
import 'package:w2t_mobile/features/kyc/data/kyc_device_location.dart';
import 'package:w2t_mobile/features/kyc/data/kyc_validators.dart';
import 'package:w2t_mobile/features/kyc/widgets/kyc_page_scaffold.dart';
import 'package:w2t_mobile/features/kyc/widgets/kyc_text_field.dart';

/// KYC step 3: store address with a live map pin.
class KycStoreLocationScreen extends StatefulWidget {
  const KycStoreLocationScreen({super.key});

  @override
  State<KycStoreLocationScreen> createState() => _KycStoreLocationScreenState();
}

class _KycStoreLocationScreenState extends State<KycStoreLocationScreen> {
  late final TextEditingController _line1;
  late final TextEditingController _line2;
  late final TextEditingController _city;
  late final TextEditingController _pincode;
  bool _locating = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<KycRegistrationCubit>().state;
    _line1 = TextEditingController(text: state.addressLine1);
    _line2 = TextEditingController(text: state.addressLine2);
    _city = TextEditingController(text: state.city);
    _pincode = TextEditingController(text: state.pincode);
  }

  @override
  void dispose() {
    _line1.dispose();
    _line2.dispose();
    _city.dispose();
    _pincode.dispose();
    super.dispose();
  }

  void _syncFromState(KycRegistrationState state) {
    if (_line1.text != state.addressLine1) _line1.text = state.addressLine1;
    if (_line2.text != state.addressLine2) _line2.text = state.addressLine2;
    if (_city.text != state.city) _city.text = state.city;
    if (_pincode.text != state.pincode) _pincode.text = state.pincode;
  }

  Future<void> _useCurrentLocation(KycRegistrationCubit cubit) async {
    if (_locating) return;
    setState(() => _locating = true);
    final result = await KycDeviceLocation.fetch();
    if (!mounted) return;
    if (result != null) {
      cubit.applyDeviceLocation(result);
    } else {
      cubit.useCurrentLocation();
    }
    _syncFromState(cubit.state);
    setState(() => _locating = false);
  }

  Future<void> _pickState() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.55,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, controller) {
            return ListView.builder(
              controller: controller,
              itemCount: KycValidators.indianStates.length,
              itemBuilder: (context, index) {
                final name = KycValidators.indianStates[index];
                return ListTile(
                  title: Text(name, style: GoogleFonts.inter(fontSize: 15)),
                  onTap: () => Navigator.of(context).pop(name),
                );
              },
            );
          },
        );
      },
    );
    if (selected != null && mounted) {
      context.read<KycRegistrationCubit>().updateState(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KycRegistrationCubit, KycRegistrationState>(
      builder: (context, state) {
        final cubit = context.read<KycRegistrationCubit>();
        return KycPageScaffold(
          step: KycWizardStep.location,
          nextLabel: 'Continue',
          showNextArrow: true,
          nextEnabled: state.canContinueLocation,
          onBack: () => context.go(AppRoutes.kycBusiness),
          onNext: state.canContinueLocation
              ? () => context.push(AppRoutes.kycDocuments)
              : null,
          body: ListView(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            children: [
              Text(
                'Store Location',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.titleNavy,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Add your store address',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 14),
              _StoreMapCard(
                locating: _locating,
                onUseCurrentLocation: () => _useCurrentLocation(cubit),
              ),
              const SizedBox(height: 16),
              KycTextField(
                label: 'Address Line 1',
                hint: 'H.No 2-5-123, Main Road',
                required: true,
                dense: true,
                prefixIcon: Icons.location_on_outlined,
                controller: _line1,
                textCapitalization: TextCapitalization.words,
                onChanged: cubit.updateAddressLine1,
              ),
              const SizedBox(height: 12),
              KycTextField(
                label: 'Address Line 2 (Optional)',
                hint: 'Near Bus Stand',
                dense: true,
                prefixIcon: Icons.apartment_outlined,
                controller: _line2,
                textCapitalization: TextCapitalization.words,
                onChanged: cubit.updateAddressLine2,
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: KycTextField(
                      label: 'City',
                      hint: 'Hanamkonda',
                      required: true,
                      dense: true,
                      prefixIcon: Icons.location_on_outlined,
                      controller: _city,
                      textCapitalization: TextCapitalization.words,
                      onChanged: cubit.updateCity,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: KycTextField(
                      label: 'Pincode',
                      hint: '506001',
                      required: true,
                      dense: true,
                      prefix: const Icon(
                        Icons.location_on,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      controller: _pincode,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      onChanged: cubit.updatePincode,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              KycSelectField(
                label: 'State',
                hint: 'Select state',
                value: state.state,
                required: true,
                onTap: _pickState,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StoreMapCard extends StatelessWidget {
  const _StoreMapCard({
    required this.locating,
    required this.onUseCurrentLocation,
  });

  final bool locating;
  final VoidCallback onUseCurrentLocation;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 168,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              AppAssets.kycStoreMap,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              filterQuality: FilterQuality.high,
            ),
            Positioned(
              top: 12,
              right: 12,
              child: Material(
                color: AppColors.white,
                elevation: 3,
                shadowColor: Colors.black26,
                borderRadius: BorderRadius.circular(22),
                child: InkWell(
                  onTap: locating ? null : onUseCurrentLocation,
                  borderRadius: BorderRadius.circular(22),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (locating)
                          const SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else
                          const Icon(
                            Icons.near_me_rounded,
                            size: 15,
                            color: AppColors.primary,
                          ),
                        const SizedBox(width: 6),
                        Text(
                          'Use Current Location',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
