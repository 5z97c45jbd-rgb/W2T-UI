import 'package:equatable/equatable.dart';

class AuthSession extends Equatable {
  const AuthSession({
    required this.userId,
    required this.accessToken,
    this.tokenType = 'Bearer',
  });

  final String userId;
  final String accessToken;
  final String tokenType;

  @override
  List<Object?> get props => [userId, accessToken, tokenType];
}
