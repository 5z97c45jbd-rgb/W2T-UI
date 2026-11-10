import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum DeliveryVehicleType {
  truck,
  miniTruck,
  pickup,
  tempo,
  bike,
  scooter,
}

extension DeliveryVehicleTypeX on DeliveryVehicleType {
  String get label => switch (this) {
        DeliveryVehicleType.truck => 'Truck',
        DeliveryVehicleType.miniTruck => 'Mini Truck',
        DeliveryVehicleType.pickup => 'Pickup',
        DeliveryVehicleType.tempo => 'Tempo',
        DeliveryVehicleType.bike => 'Bike',
        DeliveryVehicleType.scooter => 'Scooter',
      };

  IconData get icon => switch (this) {
        DeliveryVehicleType.truck => Icons.local_shipping_rounded,
        DeliveryVehicleType.miniTruck => Icons.airport_shuttle_rounded,
        DeliveryVehicleType.pickup => Icons.fire_truck_rounded,
        DeliveryVehicleType.tempo => Icons.airport_shuttle_outlined,
        DeliveryVehicleType.bike => Icons.two_wheeler_rounded,
        DeliveryVehicleType.scooter => Icons.electric_moped_rounded,
      };

  String get imageAsset => switch (this) {
        DeliveryVehicleType.truck => 'assets/vehicles/truck.png',
        DeliveryVehicleType.miniTruck => 'assets/vehicles/mini_truck.png',
        DeliveryVehicleType.pickup => 'assets/vehicles/pickup.png',
        DeliveryVehicleType.tempo => 'assets/vehicles/tempo.png',
        DeliveryVehicleType.bike => 'assets/vehicles/bike.jpg',
        DeliveryVehicleType.scooter => 'assets/vehicles/scooter.jpg',
      };
}

class DeliveryVehicle extends Equatable {
  const DeliveryVehicle({
    required this.id,
    required this.type,
    required this.number,
    required this.brandModel,
    required this.capacityKg,
    this.volumeLabel,
    this.subtitle,
  });

  final String id;
  final DeliveryVehicleType type;
  final String number;
  final String brandModel;
  final String capacityKg;
  final String? volumeLabel;
  final String? subtitle;

  String get title => '$brandModel – $number';

  static List<DeliveryVehicle> samples() => const [
        DeliveryVehicle(
          id: 'tata-ace',
          type: DeliveryVehicleType.miniTruck,
          number: 'TS03AB1234',
          brandModel: 'Tata Ace',
          capacityKg: '1,000',
          volumeLabel: 'Volume: 6 m³',
          subtitle: 'Mini Truck (1 Ton)',
        ),
        DeliveryVehicle(
          id: 'hero-splendor',
          type: DeliveryVehicleType.bike,
          number: 'TS03EF5678',
          brandModel: 'Hero Splendor',
          capacityKg: '20',
          volumeLabel: 'Box: 50 L',
          subtitle: 'Bike',
        ),
      ];

  @override
  List<Object?> get props =>
      [id, type, number, brandModel, capacityKg, volumeLabel, subtitle];
}
