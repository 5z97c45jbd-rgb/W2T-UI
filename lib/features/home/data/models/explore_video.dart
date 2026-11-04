import 'package:equatable/equatable.dart';
import 'package:w2t_mobile/core/constants/app_assets.dart';

class ExploreVideo extends Equatable {
  const ExploreVideo({
    required this.title,
    required this.creator,
    required this.imageAsset,
    required this.duration,
    required this.likesLabel,
    required this.costLabel,
    required this.category,
    this.id,
    this.imageUrl,
    this.videoUrl,
    this.hashtags = const [],
    this.verified = false,
    this.trending = false,
    this.creatorIcon,
  });

  final String? id;
  final String title;
  final String creator;
  final String imageAsset;
  final String? imageUrl;
  final String? videoUrl;
  final String duration;
  final String likesLabel;
  final String costLabel;
  final String category;
  final List<String> hashtags;
  final bool verified;
  final bool trending;
  final String? creatorIcon;

  bool hasTopic(String topic) {
    final needle = topic.trim().toLowerCase();
    if (needle.isEmpty || needle == 'near you') return true;
    if (needle == 'trending') return trending;
    return hashtags.any((tag) => tag.toLowerCase().contains(needle));
  }

  ExploreVideo copyWith({
    String? id,
    String? title,
    String? creator,
    String? imageAsset,
    String? imageUrl,
    String? videoUrl,
    String? duration,
    String? likesLabel,
    String? costLabel,
    String? category,
    List<String>? hashtags,
    bool? verified,
    bool? trending,
    String? creatorIcon,
  }) {
    return ExploreVideo(
      id: id ?? this.id,
      title: title ?? this.title,
      creator: creator ?? this.creator,
      imageAsset: imageAsset ?? this.imageAsset,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      duration: duration ?? this.duration,
      likesLabel: likesLabel ?? this.likesLabel,
      costLabel: costLabel ?? this.costLabel,
      category: category ?? this.category,
      hashtags: hashtags ?? this.hashtags,
      verified: verified ?? this.verified,
      trending: trending ?? this.trending,
      creatorIcon: creatorIcon ?? this.creatorIcon,
    );
  }

  static ExploreVideo? fromJson(dynamic json, {required String category}) {
    if (json is! Map) return null;
    final name = _nonEmpty(json['name']);
    final id = _nonEmpty(json['itemId']);
    if (name == null && id == null) return null;

    final tags = _tags(json['tags']);
    final likes = _int(json['likes']) ?? 0;
    final quantity = _int(json['quantity']);
    return ExploreVideo(
      id: id,
      title: name ?? 'Item',
      creator: _nonEmpty(json['itemType']) ?? 'W2T',
      imageAsset: AppAssets.paradiseBiryani,
      imageUrl: _nonEmpty(json['itemUrl']),
      videoUrl: _nonEmpty(json['videoUrl']),
      duration: '',
      likesLabel: _likesLabel(likes),
      costLabel: quantity == null ? '' : '$quantity pcs',
      category: category,
      hashtags: [
        for (final tag in tags) tag.startsWith('#') ? tag : '#$tag',
      ],
      trending: tags.any((tag) => tag.toLowerCase() == 'trending'),
    );
  }

  static List<ExploreVideo> listFrom(dynamic json, {required String category}) {
    if (json is! List) return const [];
    return json
        .map((item) => fromJson(item, category: category))
        .whereType<ExploreVideo>()
        .toList(growable: false);
  }

  static List<String> _tags(Object? value) {
    if (value is! List) return const [];
    return [
      for (final item in value)
        if (item != null && item.toString().trim().isNotEmpty)
          item.toString().trim(),
    ];
  }

  static String _likesLabel(int likes) {
    if (likes >= 1000) {
      final value = likes / 1000;
      final label = value == value.roundToDouble()
          ? value.toInt().toString()
          : value.toStringAsFixed(1);
      return '${label}K';
    }
    return likes.toString();
  }

  static int? _int(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value.trim());
    return null;
  }

  static String? _nonEmpty(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        creator,
        imageAsset,
        imageUrl,
        videoUrl,
        duration,
        likesLabel,
        costLabel,
        category,
        hashtags,
        verified,
        trending,
        creatorIcon,
      ];
}
