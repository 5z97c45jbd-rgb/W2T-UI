import 'package:equatable/equatable.dart';

enum CityImageStatus { loading, success, failure }

class CityImageState extends Equatable {
  const CityImageState({
    this.status = CityImageStatus.loading,
    this.imageUrl,
  });

  final CityImageStatus status;
  final String? imageUrl;

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  @override
  List<Object?> get props => [status, imageUrl];
}
