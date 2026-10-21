import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  const UserProfile({
    required this.userId,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.dateOfBirth,
    this.color,
  });

  final String userId;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? color;

  bool get needsPersonalization => dateOfBirth == null || !_hasColor;

  bool get _hasColor {
    final value = color?.trim();
    return value != null && value.isNotEmpty;
  }

  factory UserProfile.fromData(dynamic data, {required String fallbackUserId}) {
    final map =
        data is Map ? Map<String, dynamic>.from(data) : <String, dynamic>{};
    final nested = map['user'] is Map
        ? Map<String, dynamic>.from(map['user'] as Map)
        : map;
    return UserProfile(
      userId:
          _string(nested['userId']) ?? _string(nested['id']) ?? fallbackUserId,
      fullName: _string(nested['fullName']) ?? _string(nested['name']),
      email: _string(nested['email']),
      phoneNumber: _string(nested['phoneNumber']),
      dateOfBirth: _date(
        nested['dateOfBirth'] ?? nested['dob'] ?? nested['date_of_birth'],
      ),
      color: _string(nested['color']) ??
          _string(nested['favouriteColor']) ??
          _string(nested['favoriteColor']),
    );
  }

  UserProfile copyWith({
    String? userId,
    String? fullName,
    String? email,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? color,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      color: color ?? this.color,
    );
  }

  String get displayName {
    final name = fullName?.trim();
    if (name != null && name.isNotEmpty) return name;
    final mail = email?.trim();
    if (mail != null && mail.isNotEmpty) return mail;
    return userId;
  }

  static String? _string(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  static DateTime? _date(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true).toLocal();
    }
    if (value is String) {
      return DateTime.tryParse(value.trim());
    }
    return null;
  }

  @override
  List<Object?> get props =>
      [userId, fullName, email, phoneNumber, dateOfBirth, color];
}
