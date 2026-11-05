import 'package:equatable/equatable.dart';

enum CityImageStatus { loading, success, failure }

class CityImageState extends Equatable {
  const CityImageState({
    this.status = CityImageStatus.loading,
    this.imageUrl,
    this.headline,
  });

  final CityImageStatus status;
  final String? imageUrl;
  final String? headline;

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  @override
  List<Object?> get props => [status, imageUrl, headline];
}
