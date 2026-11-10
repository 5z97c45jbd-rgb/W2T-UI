import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  const UserProfile({
    required this.userId,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.dateOfBirth,
    this.color,
    this.location,
    this.gender,
  });

  final String userId;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? color;
  final String? location;
  final String? gender;

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
    final userId =
        _string(nested['userId']) ?? _string(nested['id']) ?? fallbackUserId;
    return UserProfile(
      userId: userId,
      fullName: _nameOrNull(
        _string(nested['fullName']) ?? _string(nested['name']),
        userId,
      ),
      email: _string(nested['email']),
      phoneNumber: _string(nested['phoneNumber']),
      dateOfBirth: _date(
        nested['dateOfBirth'] ?? nested['dob'] ?? nested['date_of_birth'],
      ),
      color: _string(nested['color']) ??
          _string(nested['favouriteColor']) ??
          _string(nested['favoriteColor']),
      location: _string(nested['location']) ??
          _string(nested['city']) ??
          _string(nested['address']),
      gender: _string(nested['gender']),
    );
  }

  UserProfile copyWith({
    String? userId,
    String? fullName,
    String? email,
    String? phoneNumber,
    DateTime? dateOfBirth,
    String? color,
    String? location,
    String? gender,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      color: color ?? this.color,
      location: location ?? this.location,
      gender: gender ?? this.gender,
    );
  }

  String? get visibleFullName => _nameOrNull(fullName, userId);

  String get displayName {
    final name = visibleFullName;
    if (name != null) return name;
    final mail = email?.trim();
    if (mail != null && mail.isNotEmpty) return mail;
    return 'My Profile';
  }

  static String? _nameOrNull(String? value, String userId) {
    final name = value?.trim();
    if (name == null || name.isEmpty) return null;
    if (name == userId.trim()) return null;
    return name;
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
  List<Object?> get props => [
        userId,
        fullName,
        email,
        phoneNumber,
        dateOfBirth,
        color,
        location,
        gender,
      ];
}
