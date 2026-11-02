import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:w2t_mobile/features/kyc/bloc/kyc_registration/kyc_registration_cubit.dart';

class KycScope extends StatefulWidget {
  const KycScope({super.key, required this.child});

  final Widget child;

  @override
  State<KycScope> createState() => _KycScopeState();
}

class _KycScopeState extends State<KycScope> {
  late final KycRegistrationCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = KycRegistrationCubit();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: widget.child,
    );
  }
}
