class ExploreVideo {
  const ExploreVideo({
    required this.title,
    required this.creator,
    required this.imageAsset,
    required this.duration,
    required this.likesLabel,
    required this.costLabel,
    required this.category,
    this.hashtags = const [],
    this.verified = false,
    this.trending = false,
    this.creatorIcon,
  });

  final String title;
  final String creator;
  final String imageAsset;
  final String duration;
  final String likesLabel;
  final String costLabel;
  final String category;
  final List<String> hashtags;
  final bool verified;
  final bool trending;
  final String? creatorIcon;
}
