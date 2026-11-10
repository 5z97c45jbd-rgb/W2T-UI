import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:w2t_mobile/core/constants/app_colors.dart';
import 'package:w2t_mobile/core/router/app_router.dart';
import 'package:w2t_mobile/core/router/safe_nav.dart';
import 'package:w2t_mobile/core/ui/app_snack_bar.dart';
import 'package:w2t_mobile/features/home/data/models/delivery_vehicle.dart';
import 'package:w2t_mobile/features/home/widgets/profile_chrome.dart';

class SelectVehicleScreen extends StatefulWidget {
  const SelectVehicleScreen({super.key});

  @override
  State<SelectVehicleScreen> createState() => _SelectVehicleScreenState();
}

class _SelectVehicleScreenState extends State<SelectVehicleScreen> {
  static const _brands = [
    'Tata Ace',
    'Tata Intra',
    'Mahindra Bolero Pickup',
    'Piaggio Ape',
    'Hero Splendor',
    'Honda Activa',
    'TVS Jupiter',
  ];

  final _number = TextEditingController();
  final _capacity = TextEditingController();
  final _volume = TextEditingController();

  var _vehicles = DeliveryVehicle.samples();
  var _selectedId = DeliveryVehicle.samples().first.id;
  var _type = DeliveryVehicleType.truck;
  String? _brand;
  String? _editingId;
  var _showForm = false;

  @override
  void dispose() {
    _number.dispose();
    _capacity.dispose();
    _volume.dispose();
    super.dispose();
  }

  void _resetForm() {
    _number.clear();
    _capacity.clear();
    _volume.clear();
    _brand = null;
    _type = DeliveryVehicleType.truck;
    _editingId = null;
  }

  void _startAdd() {
    setState(() {
      _resetForm();
      _showForm = true;
    });
  }

  void _startEdit(DeliveryVehicle vehicle) {
    setState(() {
      _editingId = vehicle.id;
      _selectedId = vehicle.id;
      _type = vehicle.type;
      _brand = vehicle.brandModel;
      _number.text = vehicle.number;
      _capacity.text = vehicle.capacityKg.replaceAll(',', '');
      _volume.clear();
      _showForm = true;
    });
  }

  void _deleteVehicle(DeliveryVehicle vehicle) {
    final remaining = _vehicles.where((item) => item.id != vehicle.id).toList();
    setState(() {
      _vehicles = remaining;
      _selectedId = remaining.isEmpty ? '' : remaining.first.id;
      _resetForm();
      _showForm = false;
    });
    AppSnackBar.show(context, 'Vehicle deleted');
  }

  void _saveVehicle() {
    final number = _number.text.trim().toUpperCase();
    final brand = _brand?.trim() ?? '';
    final capacity = _capacity.text.trim();
    if (number.isEmpty || brand.isEmpty || capacity.isEmpty) {
      AppSnackBar.show(
          context, 'Please fill vehicle number, brand and capacity');
      return;
    }
    final vehicle = DeliveryVehicle(
      id: _editingId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      type: _type,
      number: number,
      brandModel: brand,
      capacityKg: capacity,
      volumeLabel: _volume.text.trim().isEmpty
          ? null
          : 'Volume: ${_volume.text.trim()} m³',
      subtitle: _type.label,
    );
    setState(() {
      if (_editingId == null) {
        _vehicles = [..._vehicles, vehicle];
      } else {
        _vehicles = [
          for (final item in _vehicles)
            if (item.id == _editingId) vehicle else item,
        ];
      }
      _selectedId = vehicle.id;
      _resetForm();
      _showForm = false;
    });
    AppSnackBar.show(context, 'Vehicle saved');
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final topGap = media.padding.top + 8;
    final sheetHeight = media.size.height - topGap;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFE8EEF2),
        body: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: sheetHeight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD7DEE5),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 14, 8, 0),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F6FB),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.local_shipping_rounded,
                                color: ProfilePalette.iconBlue,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Select Vehicle for Delivery',
                                    style: GoogleFonts.inter(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                      color: ProfilePalette.navy,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Choose a vehicle, add details, or manage your saved vehicles.',
                                    style: GoogleFonts.inter(
                                      fontSize: 11.5,
                                      height: 1.35,
                                      color: ProfilePalette.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (_showForm) {
                                  setState(() {
                                    _resetForm();
                                    _showForm = false;
                                  });
                                  return;
                                }
                                goBackOr(context, AppRoutes.home);
                              },
                              icon: const Icon(Icons.close_rounded),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: _showForm ? _buildForm(context) : _buildList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    return ListView(
      padding: EdgeInsets.fromLTRB(
        16,
        8,
        16,
        20 + MediaQuery.paddingOf(context).bottom,
      ),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Your Saved Vehicles',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: ProfilePalette.navy,
                ),
              ),
            ),
            _HeaderAction(
              tooltip: 'Add',
              icon: Icons.add_rounded,
              onPressed: _startAdd,
            ),
          ],
        ),
        const SizedBox(height: 4),
        for (final vehicle in _vehicles) ...[
          _SavedVehicleCard(
            vehicle: vehicle,
            selected: vehicle.id == _selectedId,
            onTap: () => setState(() => _selectedId = vehicle.id),
            onEdit: () => _startEdit(vehicle),
            onDelete: () => _deleteVehicle(vehicle),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            children: [
              Text(
                _editingId == null ? 'Add New Vehicle' : 'Edit Vehicle',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: ProfilePalette.navy,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Select Vehicle Type',
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF5B6573),
                ),
              ),
              const SizedBox(height: 10),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.92,
                children: [
                  for (final type in DeliveryVehicleType.values)
                    _VehicleTypeChip(
                      type: type,
                      selected: type == _type,
                      onTap: () => setState(() => _type = type),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                'Vehicle Details',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: ProfilePalette.navy,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _VehicleField(
                      label: 'Vehicle Number',
                      isRequired: true,
                      controller: _number,
                      hint: 'e.g. TS03AB1234',
                      icon: Icons.pin_outlined,
                      textCapitalization: TextCapitalization.characters,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _BrandField(
                      value: _brand,
                      options: _brands,
                      onChanged: (value) => setState(() => _brand = value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _VehicleField(
                      label: 'Load Capacity (kg)',
                      isRequired: true,
                      controller: _capacity,
                      hint: 'e.g. 1000',
                      icon: Icons.shopping_bag_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _VehicleField(
                      label: 'Load Volume (m³)',
                      controller: _volume,
                      hint: 'e.g. 6.0',
                      icon: Icons.inventory_2_outlined,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16, 4, 16, 12 + bottom),
          child: SizedBox(
            height: 52,
            width: double.infinity,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: const LinearGradient(
                  colors: [Color(0xFF2AA4E0), Color(0xFF1578C8)],
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _saveVehicle,
                  borderRadius: BorderRadius.circular(26),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Save Vehicle',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.check_rounded, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.color,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tint = color ?? ProfilePalette.iconBlue;
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 36, height: 36),
      icon: Icon(icon, size: 20, color: tint),
    );
  }
}

class _VehiclePhoto extends StatelessWidget {
  const _VehiclePhoto({
    required this.asset,
    this.width,
    this.height,
  });

  final String asset;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      width: width,
      height: height,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
      errorBuilder: (_, __, ___) => const Icon(
        Icons.local_shipping_outlined,
        color: ProfilePalette.iconBlue,
      ),
    );
  }
}

class _SavedVehicleCard extends StatelessWidget {
  const _SavedVehicleCard({
    required this.vehicle,
    required this.selected,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final DeliveryVehicle vehicle;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFEFF8FF) : Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? const Color(0xFF8EC8EA)
                  : ProfilePalette.cardBorder,
              width: selected ? 1.4 : 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 72,
                    height: 56,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE8EEF2)),
                    ),
                    child: _VehiclePhoto(asset: vehicle.type.imageAsset),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vehicle.title,
                          style: GoogleFonts.inter(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: ProfilePalette.navy,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 10,
                          runSpacing: 4,
                          children: [
                            _Meta(
                              icon: vehicle.type.icon,
                              text: vehicle.subtitle ?? vehicle.type.label,
                            ),
                            _Meta(
                              icon: Icons.inventory_2_outlined,
                              text: 'Capacity: ${vehicle.capacityKg} kg',
                            ),
                            if (vehicle.volumeLabel != null)
                              _Meta(
                                icon: Icons.inventory_outlined,
                                text: vehicle.volumeLabel!,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _RadioDot(selected: selected),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _HeaderAction(
                    tooltip: 'Edit',
                    icon: Icons.edit_outlined,
                    onPressed: onEdit,
                  ),
                  _HeaderAction(
                    tooltip: 'Delete',
                    icon: Icons.delete_outline_rounded,
                    color: const Color(0xFFE53935),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: ProfilePalette.muted),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 10.5,
              color: const Color(0xFF6B7380),
            ),
          ),
        ),
      ],
    );
  }
}

class _RadioDot extends StatelessWidget {
  const _RadioDot({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? const Color(0xFF1E8FD4) : const Color(0xFFC5CDD4),
          width: 2,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E8FD4),
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}

class _VehicleTypeChip extends StatelessWidget {
  const _VehicleTypeChip({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final DeliveryVehicleType type;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEFF8FF) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                selected ? const Color(0xFF1E8FD4) : ProfilePalette.cardBorder,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: _VehiclePhoto(asset: type.imageAsset),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              type.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: ProfilePalette.navy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VehicleField extends StatelessWidget {
  const _VehicleField({
    required this.label,
    required this.controller,
    required this.hint,
    required this.icon,
    this.isRequired = false,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
  });

  final String label;
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool isRequired;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: ProfilePalette.navy,
            ),
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Color(0xFFE53935)),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          style: GoogleFonts.inter(fontSize: 13.5, color: ProfilePalette.navy),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              fontSize: 12.5,
              color: AppColors.textMuted,
            ),
            prefixIcon: Icon(icon, size: 18, color: ProfilePalette.iconBlue),
            filled: true,
            fillColor: Colors.white,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: ProfilePalette.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: ProfilePalette.cardBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}

class _BrandField extends StatelessWidget {
  const _BrandField({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String? value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: 'Brand & Model',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: ProfilePalette.navy,
            ),
            children: const [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Color(0xFFE53935)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        PopupMenuButton<String>(
          onSelected: onChanged,
          color: Colors.white,
          itemBuilder: (context) => [
            for (final option in options)
              PopupMenuItem(
                value: option,
                child: Text(option, style: GoogleFonts.inter(fontSize: 13.5)),
              ),
          ],
          child: Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ProfilePalette.cardBorder),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.directions_car_outlined,
                  size: 18,
                  color: ProfilePalette.iconBlue,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value ?? 'e.g. Tata Ace',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      color: value == null
                          ? AppColors.textMuted
                          : ProfilePalette.navy,
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
        ),
      ],
    );
  }
}
